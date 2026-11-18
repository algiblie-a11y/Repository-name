import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_provider.dart';

class HealthServicesScreen extends StatelessWidget {
  const HealthServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final alarms = context.watch<HojaAppProvider>().alarms;
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('الخدمات الصحية ومنبهات الجرعات', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          ),
        ),
        const SizedBox(height: 12),
        const Text('منبهات الأدوية المفعلة', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        const SizedBox(height: 8),
        if (alarms.isEmpty)
          const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('لا توجد منبهات مفعلة. عند شراء دواء سيتم جدولته تلقائياً.')))
        else
          ...alarms.map((a) => Card(child: ListTile(title: Text(a.drugName), subtitle: Text('المواعيد: ${a.times.join(" - ")}')))),
      ],
    );
  }
}
