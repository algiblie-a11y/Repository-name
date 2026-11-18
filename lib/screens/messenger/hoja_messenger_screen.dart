import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../models/hoja_models.dart';
import '../../providers/app_provider.dart';

class HojaMessengerScreen extends StatefulWidget {
  const HojaMessengerScreen({super.key});

  @override
  State<HojaMessengerScreen> createState() => _HojaMessengerScreenState();
}

class _HojaMessengerScreenState extends State<HojaMessengerScreen> {
  HojaUser? _activeChatUser;
  final _msgCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HojaAppProvider>();
    final doctors = provider.users.where((u) => u.role == UserRole.doctor).toList();

    if (_activeChatUser != null) {
      final meId = provider.currentUser?.id ?? 'guest';
      final thread = provider.messages.where((m) =>
          (m.fromId == meId && m.toId == _activeChatUser!.id) ||
          (m.fromId == _activeChatUser!.id && m.toId == meId)).toList();

      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: HojaColors.primarySoft,
            child: Row(
              children: [
                IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => setState(() => _activeChatUser = null)),
                Text(_activeChatUser!.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(14),
              itemCount: thread.length,
              itemBuilder: (_, i) => ListTile(title: Text(thread[i].text)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _msgCtrl, decoration: const InputDecoration(hintText: 'اكتب رسالة...'))),
                IconButton(
                  icon: const Icon(Icons.send, color: HojaColors.primaryNavy),
                  onPressed: () {
                    provider.sendMessage(_activeChatUser!.id, _msgCtrl.text);
                    _msgCtrl.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }

    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        const Text('محادثات الأطباء', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 10),
        ...doctors.map((doc) => Card(
              child: ListTile(
                title: Text(doc.name),
                subtitle: Text(doc.specialty),
                trailing: const Icon(Icons.chat, color: HojaColors.primaryNavy),
                onTap: () => setState(() => _activeChatUser = doc),
              ),
            )),
      ],
    );
  }
}
