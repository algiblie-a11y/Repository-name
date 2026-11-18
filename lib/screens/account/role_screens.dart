import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_provider.dart';
import '../welcome/welcome_screen.dart';

class StudentPortalScreen extends StatelessWidget {
  const StudentPortalScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('ملتقى الطلاب'));
}

class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final p = context.watch<HojaAppProvider>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('أرباح المندوب: ${p.driverEarnings} د.ل', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ElevatedButton(onPressed: p.confirmDeliveryOtp, child: const Text('تأكيد تسليم الطلبية')),
      ],
    );
  }
}

class PharmacyB2BScreen extends StatelessWidget {
  const PharmacyB2BScreen({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text('إدارة الصيدلية B2B'));
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final p = context.watch<HojaAppProvider>();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('اسم المستخدم: ${p.currentUser?.name ?? "زائر"}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
          onPressed: () async {
            await p.logout();
            if (!context.mounted) return;
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const WelcomeScreen()), (_) => false);
          },
          child: const Text('تسجيل الخروج'),
        ),
      ],
    );
  }
}
