import 'package:flutter/material.dart';
import '../models/emergency_contact.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({super.key});

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  void _showAddDialog() {
    final formKey = GlobalKey<FormState>();
    final name = TextEditingController();
    final relation = TextEditingController();
    final phone = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Kontak'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
              ),
              TextFormField(
                controller: relation,
                decoration: const InputDecoration(
                    labelText: 'Hubungan (orang tua, sahabat, dll.)'),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Hubungan wajib diisi'
                    : null,
              ),
              TextFormField(
                controller: phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Nomor HP'),
                validator: (v) {
                  final value = v?.trim() ?? '';
                  if (value.length < 8 ||
                      !RegExp(r'^[0-9+]+$').hasMatch(value)) {
                    return 'Nomor HP tidak valid';
                  }
                  final exists = EmergencyContact.all
                      .any((c) => c.phone == value);
                  if (exists) return 'Nomor sudah terdaftar';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal')),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              setState(() {
                EmergencyContact.all.add(EmergencyContact(
                  name: name.text.trim(),
                  relation: relation.text.trim(),
                  phone: phone.text.trim(),
                ));
              });
              Navigator.pop(ctx);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _delete(int index) {
    final c = EmergencyContact.all[index];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus kontak?'),
        content: Text('${c.name} akan dihapus dari daftar.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal')),
          FilledButton(
            onPressed: () {
              setState(() => EmergencyContact.all.removeAt(index));
              Navigator.pop(ctx);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final contacts = EmergencyContact.all;
    return Scaffold(
      appBar: AppBar(title: const Text('Kontak Darurat')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
      body: contacts.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Belum ada kontak darurat.\nKetuk "Tambah" untuk mendaftarkan orang terdekat.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: contacts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final c = contacts[i];
                return Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: ListTile(
                    leading: CircleAvatar(
                        child: Text(c.name[0].toUpperCase())),
                    title: Text(c.name,
                        style:
                            const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('${c.relation} • ${c.phone}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _delete(i),
                    ),
                  ),
                );
              },
            ),
    );
  }
}