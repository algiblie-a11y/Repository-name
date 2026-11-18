import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/app_provider.dart';
import '../widgets/hoja_logo_widget.dart';
import 'account/role_screens.dart';
import 'messenger/hoja_messenger_screen.dart';
import 'news/news_and_admin_screens.dart';
import 'patient/patient_market_screen.dart';
import 'services/health_services_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HojaAppProvider>();
    final user = provider.currentUser;

    final screens = [
      PatientMarketScreen(onOpenMessenger: () => setState(() => _currentIndex = 2)),
      const HealthServicesScreen(),
      const HojaMessengerScreen(),
      const StudentPortalScreen(),
      const DeliveryScreen(),
      const PharmacyB2BScreen(),
      const MedicalNewsScreen(),
      const AccountScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const HojaLogoWidget(size: 38),
            const SizedBox(width: 8),
            Text('هوجاء - ${user?.name ?? "زائر"}'),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.brightness_6), onPressed: provider.toggleTheme),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (i) => setState(() => _currentIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.storefront), label: 'الزبون'),
          NavigationDestination(icon: Icon(Icons.health_and_safety), label: 'الخدمات'),
          NavigationDestination(icon: Icon(Icons.chat), label: 'المحادثات'),
          NavigationDestination(icon: Icon(Icons.school), label: 'الطلاب'),
          NavigationDestination(icon: Icon(Icons.delivery_dining), label: 'المندوب'),
          NavigationDestination(icon: Icon(Icons.local_pharmacy), label: 'الصيدلية'),
          NavigationDestination(icon: Icon(Icons.newspaper), label: 'الأخبار'),
          NavigationDestination(icon: Icon(Icons.person), label: 'الحساب'),
        ],
      ),
    );
  }
}
