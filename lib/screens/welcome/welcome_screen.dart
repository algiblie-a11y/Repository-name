import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_provider.dart';
import '../../widgets/hoja_logo_widget.dart';
import '../auth/register_screen.dart';
import '../main_shell.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String _mode = 'choice';
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  void _handleLogin() async {
    final provider = context.read<HojaAppProvider>();
    final error = await provider.login(_userCtrl.text, _passCtrl.text);
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 460),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? HojaColors.darkBgCard : HojaColors.lightBgCard,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: HojaColors.primaryNavy, width: 1.5),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const HojaLogoWidget(size: 130, isCircle: true),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: HojaColors.primarySoft,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: HojaColors.primaryNavy),
                    ),
                    child: const Text(
                      'أهلاً وسهلاً بك',
                      style: TextStyle(color: HojaColors.primaryNavy, fontWeight: FontWeight.w800, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
                      children: const [
                        TextSpan(text: 'مرحباً بك في '),
                        TextSpan(text: 'هوجـاء', style: TextStyle(color: HojaColors.primaryNavy)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'الرعاية الصحية المتكاملة، صيدليتك الفورية، والاستشارات الطبية المباشرة',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: HojaColors.lightTextMuted),
                  ),
                  const SizedBox(height: 24),
                  if (_mode == 'choice') ...[
                    _choiceButton(
                      icon: Icons.menu_book_rounded,
                      title: 'أنا أعرف أقرأ وأكتب',
                      subtitle: 'الدخول بالطريقة العادية',
                      onTap: () => setState(() => _mode = 'login'),
                    ),
                    const SizedBox(height: 12),
                    _choiceButton(
                      icon: Icons.hearing_rounded,
                      title: 'لا أستطيع القراءة أو الكتابة',
                      subtitle: 'مساعدة صوتية خطوة بخطوة',
                      onTap: () {},
                    ),
                  ] else ...[
                    TextField(controller: _userCtrl, decoration: const InputDecoration(labelText: 'اسم المستخدم أو رقم الهاتف', prefixIcon: Icon(Icons.person_outline))),
                    const SizedBox(height: 12),
                    TextField(controller: _passCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'كلمة المرور', prefixIcon: Icon(Icons.lock_outline))),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(backgroundColor: HojaColors.primaryNavy, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15)),
                      icon: const Icon(Icons.login_rounded),
                      label: const Text('دخول إلى هوجاء', style: TextStyle(fontWeight: FontWeight.w900)),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen()));
                      },
                      child: const Text('إنشاء حساب جديد'),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<HojaAppProvider>().enterAsGuest();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainShell()));
                      },
                      child: const Text('دخول سريع كزائر'),
                    ),
                    OutlinedButton(onPressed: () => setState(() => _mode = 'choice'), child: const Text('الرجوع')),
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _choiceButton({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: HojaColors.primaryNavy, width: 1.5),
        ),
        child: Row(
          children: [
            Container(width: 46, height: 46, decoration: BoxDecoration(color: HojaColors.primaryNavy, borderRadius: BorderRadius.circular(14)), child: Icon(icon, color: Colors.white)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)), Text(subtitle, style: const TextStyle(fontSize: 12, color: HojaColors.lightTextMuted))])),
            const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: HojaColors.primaryNavy),
          ],
        ),
      ),
    );
  }
}
