import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/storage/safe_storage.dart';
import 'core/theme/app_theme.dart';
import 'providers/app_provider.dart';
import 'screens/main_shell.dart';
import 'screens/welcome/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SafeStorage.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => HojaAppProvider(),
      child: const HojaHealthSuiteApp(),
    ),
  );
}

class HojaHealthSuiteApp extends StatelessWidget {
  const HojaHealthSuiteApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HojaAppProvider>();
    return MaterialApp(
      title: 'تطبيق هوجاء الطبي - Hoja Health Suite',
      debugShowCheckedModeBanner: false,
      themeMode: provider.themeMode,
      theme: HojaTheme.light(),
      darkTheme: HojaTheme.dark(),
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: provider.currentUser != null ? const MainShell() : const WelcomeScreen(),
    );
  }
}
