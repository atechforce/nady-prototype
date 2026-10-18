import 'package:flutter/material.dart';
import '../models/user_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _age;
  late final TextEditingController _email;
  late final TextEditingController _history;

  @override
  void initState() {
    super.initState();
    final p = UserProfile.current;
    _name = TextEditingController(text: p.name);
    _age = TextEditingController(text: p.age);
    _email = TextEditingController(text: p.email);
    _history = TextEditingController(text: p.medicalHistory);
  }

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    _email.dispose();
    _history.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    UserProfile.current
      ..name = _name.text.trim()
      ..age = _age.text.trim()
      ..email = _email.text.trim()
      ..medicalHistory = _history.text.trim();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil disimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                child: Icon(Icons.person, size: 40),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(
                    labelText: 'Nama', border: OutlineInputBorder()),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _age,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    labelText: 'Usia', border: OutlineInputBorder()),
                validator: (v) =>
                    (v == null || int.tryParse(v) == null) ? 'Isi usia dengan angka' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: 'Email', border: OutlineInputBorder()),
                validator: (v) =>
                    (v == null || !v.contains('@')) ? 'Format email salah' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _history,
                maxLines: 3,
                decoration: const InputDecoration(
                    labelText: 'Riwayat kondisi (opsional)',
                    border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _save,
                  icon: const Icon(Icons.save),
                  label: const Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}