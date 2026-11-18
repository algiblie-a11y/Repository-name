import 'dart:math';

enum UserRole {
  customer('Customer', 'زبون / مريض'),
  doctor('Doctor', 'طبيب'),
  student('University_Student', 'طالب'),
  pharmacy('Pharmacy_Owner', 'صيدلي / صيدلية'),
  delivery('Medical_Representative', 'مندوب'),
  company('Company_Owner', 'شركة'),
  admin('admin', 'مدير النظام'),
  guest('guest', 'زائر');

  final String code;
  final String arLabel;
  const UserRole(this.code, this.arLabel);

  static UserRole fromCode(String? code) {
    return UserRole.values.firstWhere(
      (e) => e.code == code || e.arLabel == code,
      orElse: () => UserRole.customer,
    );
  }
}

class HojaUser {
  final String id;
  final String accountId;
  final String name;
  final String phone;
  final String email;
  final UserRole role;
  final String status;
  final String specialty;
  final String bio;
  final String avatar;
  final String studyYear;
  final String pharmacyLicense;
  final String companyName;
  final String companyRegisterNumber;
  final String companyCountry;

  HojaUser({
    required this.id,
    required this.accountId,
    required this.name,
    required this.phone,
    this.email = '',
    required this.role,
    this.status = 'نشط',
    this.specialty = '',
    this.bio = '',
    this.avatar = '',
    this.studyYear = '',
    this.pharmacyLicense = '',
    this.companyName = '',
    this.companyRegisterNumber = '',
    this.companyCountry = '',
  });

  static String generateAccountId() {
    final rand = Random.secure();
    final num = 10000000 + rand.nextInt(90000000);
    return 'HJ-$num';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'accountId': accountId,
        'name': name,
        'phone': phone,
        'email': email,
        'role': role.code,
        'status': status,
        'specialty': specialty,
        'bio': bio,
        'avatar': avatar,
        'studyYear': studyYear,
        'pharmacyLicense': pharmacyLicense,
        'companyName': companyName,
        'companyRegisterNumber': companyRegisterNumber,
        'companyCountry': companyCountry,
      };

  factory HojaUser.fromJson(Map<String, dynamic> json) => HojaUser(
        id: json['id']?.toString() ?? '',
        accountId: json['accountId']?.toString() ?? generateAccountId(),
        name: json['name']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        role: UserRole.fromCode(json['role']?.toString()),
        status: json['status']?.toString() ?? 'نشط',
        specialty: json['specialty']?.toString() ?? '',
        bio: json['bio']?.toString() ?? '',
        avatar: json['avatar']?.toString() ?? '',
        studyYear: json['studyYear']?.toString() ?? '',
        pharmacyLicense: json['pharmacyLicense']?.toString() ?? '',
        companyName: json['companyName']?.toString() ?? '',
        companyRegisterNumber: json['companyRegisterNumber']?.toString() ?? '',
        companyCountry: json['companyCountry']?.toString() ?? '',
      );
}

class MedicineItem {
  final int id;
  final String name;
  final String generic;
  final double price;
  final String stock;
  final String desc;
  final int dosesPerDay;
  final String timing;
  final String? image;
  final String category;

  MedicineItem({
    required this.id,
    required this.name,
    required this.generic,
    required this.price,
    required this.stock,
    required this.desc,
    this.dosesPerDay = 2,
    this.timing = 'بعد الأكل',
    this.image,
    this.category = 'أدوية',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'generic': generic,
        'price': price,
        'stock': stock,
        'desc': desc,
        'dosesPerDay': dosesPerDay,
        'timing': timing,
        'image': image,
        'category': category,
      };

  factory MedicineItem.fromJson(Map<String, dynamic> json) => MedicineItem(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
        name: json['name']?.toString() ?? '',
        generic: json['generic']?.toString() ?? '',
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
        stock: json['stock']?.toString() ?? 'صيدلية هوجاء',
        desc: json['desc']?.toString() ?? '',
        dosesPerDay: json['dosesPerDay'] ?? 2,
        timing: json['timing']?.toString() ?? 'بعد الأكل',
        image: json['image']?.toString(),
        category: json['category']?.toString() ?? 'أدوية',
      );
}

class ChatMessage {
  final String id;
  final String fromId;
  final String fromName;
  final String toId;
  final String text;
  final int timestamp;
  bool read;

  ChatMessage({
    required this.id,
    required this.fromId,
    required this.fromName,
    required this.toId,
    required this.text,
    required this.timestamp,
    this.read = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fromId': fromId,
        'fromName': fromName,
        'toId': toId,
        'text': text,
        'timestamp': timestamp,
        'read': read,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        id: json['id']?.toString() ?? '',
        fromId: json['fromId']?.toString() ?? '',
        fromName: json['fromName']?.toString() ?? '',
        toId: json['toId']?.toString() ?? '',
        text: json['text']?.toString() ?? '',
        timestamp: json['timestamp'] ?? DateTime.now().millisecondsSinceEpoch,
        read: json['read'] == true,
      );
}

class MedicationAlarm {
  final String drugName;
  final int dosesCount;
  final String timing;
  final List<String> times;

  MedicationAlarm({
    required this.drugName,
    required this.dosesCount,
    required this.timing,
    required this.times,
  });

  Map<String, dynamic> toJson() => {
        'drugName': drugName,
        'dosesCount': dosesCount,
        'timing': timing,
        'times': times,
      };

  factory MedicationAlarm.fromJson(Map<String, dynamic> json) => MedicationAlarm(
        drugName: json['drugName']?.toString() ?? '',
        dosesCount: json['dosesCount'] ?? 2,
        timing: json['timing']?.toString() ?? '',
        times: List<String>.from(json['times'] ?? []),
      );
}

class DonationItem {
  final String id;
  final String donorName;
  final String phone;
  final String medicineName;
  final String quantity;
  final String expiryDate;
  final String notes;

  DonationItem({
    required this.id,
    required this.donorName,
    required this.phone,
    required this.medicineName,
    required this.quantity,
    required this.expiryDate,
    this.notes = '',
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'donorName': donorName,
        'phone': phone,
        'medicineName': medicineName,
        'quantity': quantity,
        'expiryDate': expiryDate,
        'notes': notes,
      };

  factory DonationItem.fromJson(Map<String, dynamic> json) => DonationItem(
        id: json['id']?.toString() ?? '',
        donorName: json['donorName']?.toString() ?? '',
        phone: json['phone']?.toString() ?? '',
        medicineName: json['medicineName']?.toString() ?? '',
        quantity: json['quantity']?.toString() ?? '',
        expiryDate: json['expiryDate']?.toString() ?? '',
        notes: json['notes']?.toString() ?? '',
      );
}
