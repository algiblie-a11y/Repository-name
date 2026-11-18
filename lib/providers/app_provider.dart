import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/material.dart';
import '../core/storage/safe_storage.dart';
import '../models/hoja_models.dart';

class HojaAppProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  HojaUser? _currentUser;
  HojaUser? get currentUser => _currentUser;

  String _deliveryLocation = 'حدّد موقعك على الخريطة';
  String get deliveryLocation => _deliveryLocation;

  List<HojaUser> _users = [];
  List<HojaUser> get users => _users;

  List<MedicineItem> _medicines = [];
  List<MedicineItem> get medicines => _medicines;

  final List<MedicineItem> _cart = [];
  List<MedicineItem> get cart => List.unmodifiable(_cart);

  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  List<MedicationAlarm> _alarms = [];
  List<MedicationAlarm> get alarms => _alarms;

  List<DonationItem> _donations = [];
  List<DonationItem> get donations => _donations;

  double _driverEarnings = 85.0;
  double get driverEarnings => _driverEarnings;
  int _driverDeliveredCount = 6;
  int get driverDeliveredCount => _driverDeliveredCount;

  final List> _orders = [];
  List> get orders => _orders;

  HojaAppProvider() {
    _loadInitialData();
  }

  void _loadInitialData() {
    final savedTheme = SafeStorage.getJson<String>('theme', 'light', (v) => v.toString());
    _themeMode = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;

    _deliveryLocation = SafeStorage.getJson<String>(
      'delivery_location',
      'حدّد موقعك على الخريطة',
      (v) => v.toString(),
    );

    _users = SafeStorage.getJson<List<HojaUser>>(
      'users_list',
      _defaultUsers(),
      (list) => (list as List).map((e) => HojaUser.fromJson(e)).toList(),
    );

    _medicines = SafeStorage.getJson<List<MedicineItem>>(
      'medicines',
      _defaultMedicines(),
      (list) => (list as List).map((e) => MedicineItem.fromJson(e)).toList(),
    );

    _messages = SafeStorage.getJson<List<ChatMessage>>(
      'messages',
      [],
      (list) => (list as List).map((e) => ChatMessage.fromJson(e)).toList(),
    );

    _alarms = SafeStorage.getJson<List<MedicationAlarm>>(
      'active_alarms',
      [],
      (list) => (list as List).map((e) => MedicationAlarm.fromJson(e)).toList(),
    );

    _donations = SafeStorage.getJson<List<DonationItem>>(
      'donations',
      [],
      (list) => (list as List).map((e) => DonationItem.fromJson(e)).toList(),
    );

    final savedUser = SafeStorage.getJson?>(
      'current_user',
      null,
      (v) => v as Map<String, dynamic>?,
    );
    if (savedUser != null && savedUser['id'] != null) {
      _currentUser = _users.firstWhere(
        (u) => u.id == savedUser['id'],
        orElse: () => HojaUser.fromJson(savedUser),
      );
    }
    notifyListeners();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    SafeStorage.setJson('theme', _themeMode == ThemeMode.dark ? 'dark' : 'light');
    notifyListeners();
  }

  void setDeliveryLocation(String loc) {
    _deliveryLocation = loc;
    SafeStorage.setJson('delivery_location', loc);
    notifyListeners();
  }

  String _hashPassword(String password, String salt) {
    final bytes = utf8.encode('$salt:$password');
    return crypto.sha256.convert(bytes).toString();
  }

  Future<String?> login(String username, String password) async {
    final cleanUser = username.trim();
    if (cleanUser.isEmpty || password.isEmpty) {
      return 'يرجى إدخال اسم المستخدم وكلمة المرور';
    }

    final matched = _users.where((u) => u.name == cleanUser || u.phone == cleanUser).toList();
    if (matched.isEmpty) {
      return 'اسم المستخدم أو كلمة المرور غير صحيحة';
    }

    final user = matched.first;
    if (user.status != 'نشط') {
      return 'هذا الحساب موقوف. تواصل مع الإدارة.';
    }

    _currentUser = user;
    await SafeStorage.setJson('current_user', user.toJson());
    notifyListeners();
    return null;
  }

  Future<String?> registerAccount({
    required String name,
    required String phone,
    required String email,
    required String password,
    required UserRole role,
    String studyYear = '',
    String pharmacyLicense = '',
    String companyName = '',
    String companyRegisterNumber = '',
    String companyCountry = '',
  }) async {
    if (name.trim().length < 3 || phone.trim().isEmpty || password.length < 6) {
      return 'أكمل البيانات وتأكد أن كلمة المرور 6 أحرف على الأقل';
    }
    if (_users.any((u) => u.phone == phone.trim())) {
      return 'رقم الهاتف مسجل بالفعل';
    }

    final newUser = HojaUser(
      id: 'u_${DateTime.now().millisecondsSinceEpoch}',
      accountId: HojaUser.generateAccountId(),
      name: name.trim(),
      phone: phone.trim(),
      email: email.trim(),
      role: role,
      specialty: role == UserRole.doctor ? 'طبيب عام' : '',
      studyYear: studyYear,
      pharmacyLicense: pharmacyLicense,
      companyName: companyName,
      companyRegisterNumber: companyRegisterNumber,
      companyCountry: companyCountry,
    );

    _users.add(newUser);
    await SafeStorage.setJson('users_list', _users.map((e) => e.toJson()).toList());

    _currentUser = newUser;
    await SafeStorage.setJson('current_user', newUser.toJson());
    notifyListeners();
    return null;
  }

  void enterAsGuest() {
    _currentUser = HojaUser(
      id: 'guest_${DateTime.now().millisecondsSinceEpoch}',
      accountId: 'HJ-GUEST',
      name: 'زائر',
      phone: '',
      role: UserRole.guest,
    );
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    await SafeStorage.setJson('current_user', null);
    notifyListeners();
  }

  void addToCart(MedicineItem item) {
    _cart.add(item);
    notifyListeners();
  }

  void removeFromCart(int index) {
    if (index >= 0 && index < _cart.length) {
      _cart.removeAt(index);
      notifyListeners();
    }
  }

  double get cartTotal => _cart.fold(0.0, (sum, item) => sum + item.price);

  void checkout(String paymentMethod, {String wakeTime = '08:00', String sleepTime = '23:00'}) {
    if (_cart.isEmpty) return;
    final itemsSnapshot = List<MedicineItem>.from(_cart);
    _orders.insert(0, {
      'id': 'ORD-${1000 + _orders.length}',
      'items': itemsSnapshot.map((e) => e.name).toList(),
      'total': cartTotal,
      'paymentMethod': paymentMethod,
      'status': 'معلق',
      'date': DateTime.now().toIso8601String(),
    });

    for (final med in itemsSnapshot) {
      _alarms.add(MedicationAlarm(
        drugName: med.name,
        dosesCount: med.dosesPerDay,
        timing: med.timing,
        times: ['08:00', '20:00'],
      ));
    }
    SafeStorage.setJson('active_alarms', _alarms.map((e) => e.toJson()).toList());
    _cart.clear();
    notifyListeners();
  }

  void addMedicine(MedicineItem med) {
    _medicines.insert(0, med);
    SafeStorage.setJson('medicines', _medicines.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  void addDonation(DonationItem item) {
    _donations.insert(0, item);
    SafeStorage.setJson('donations', _donations.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  void sendMessage(String toId, String text) {
    if (_currentUser == null || text.trim().isEmpty) return;
    _messages.add(ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      fromId: _currentUser!.id,
      fromName: _currentUser!.name,
      toId: toId,
      text: text.trim(),
      timestamp: DateTime.now().millisecondsSinceEpoch,
    ));
    SafeStorage.setJson('messages', _messages.map((e) => e.toJson()).toList());
    notifyListeners();
  }

  void confirmDeliveryOtp() {
    _driverEarnings += 15.0;
    _driverDeliveredCount += 1;
    notifyListeners();
  }

  List<HojaUser> _defaultUsers() => [
        HojaUser(id: 'u_doc1', accountId: 'HJ-10000001', name: 'د. أحمد الشربيني', phone: '+218911111111', role: UserRole.doctor, specialty: 'أمراض الباطنة'),
        HojaUser(id: 'u_doc2', accountId: 'HJ-10000002', name: 'د. سارة المنصوري', phone: '+218911111112', role: UserRole.doctor, specialty: 'طب الأطفال'),
      ];

  List<MedicineItem> _defaultMedicines() => [
        MedicineItem(id: 1, name: 'Augmentin 1g', generic: 'Amoxicillin', price: 28.5, stock: 'صيدلية النخبة', desc: 'مضاد حيوي واسع المجال'),
        MedicineItem(id: 2, name: 'Panadol Extra', generic: 'Paracetamol', price: 8.5, stock: 'صيدلية الحياة', desc: 'مسكن للآلام وخافض للحرارة'),
      ];
}
