import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/app_provider.dart';

class PatientMarketScreen extends StatelessWidget {
  final VoidCallback onOpenMessenger;
  const PatientMarketScreen({super.key, required this.onOpenMessenger});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HojaAppProvider>();
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('صيدليتك الذكية في هوجاء', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                TextField(decoration: const InputDecoration(hintText: 'ابحث عن الأدوية...', prefixIcon: Icon(Icons.search))),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const Text('الأدوية المتاحة', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        ...provider.medicines.map((med) => Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(med.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                        Text('${med.price} د.ل', style: const TextStyle(fontWeight: FontWeight.w900, color: HojaColors.primaryNavy)),
                      ],
                    ),
                    Text(med.desc, style: const TextStyle(fontSize: 12, color: HojaColors.lightTextMuted)),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: HojaColors.primaryNavy, foregroundColor: Colors.white),
                            onPressed: () {
                              provider.addToCart(med);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('أضيف ${med.name} للسلة')));
                            },
                            child: const Text('شراء'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: onOpenMessenger,
                            child: const Text('راسل المتجر'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }
}
