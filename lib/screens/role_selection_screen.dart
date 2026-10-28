import 'package:flutter/material.dart';
import '../models/auth_session.dart';
import 'login_screen.dart';
import '../widgets/nady_logo.dart';
import '../services/auth_service.dart';

/// Keluar dari akun dan kembali ke pemilihan peran.
void logoutToRoleSelection(BuildContext context) {
  AuthSession.logout();
  AuthService.signOut();
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => const RoleSelectionScreen()),
    (route) => false,
  );
}

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  void _open(BuildContext context, UserRole role) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen(role: role)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              const Hero(
                tag: 'nady-logo',
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: NadyLogo(),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Selamat datang di NaDy',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              const Text(
                'Pendamping untuk kecemasan. Pilih peranmu untuk melanjutkan.',
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 28),
              _RoleCard(
                icon: Icons.person,
                title: 'Masuk sebagai Pasien',
                subtitle:
                    'Gunakan edukasi, chatbot, kontak darurat, dan sesi monitoring.',
                onTap: () => _open(context, UserRole.patient),
              ),
              const SizedBox(height: 14),
              _RoleCard(
                icon: Icons.volunteer_activism,
                title: 'Masuk sebagai Partner',
                subtitle:
                    'Orang terdekat yang menerima peringatan dan membantu pasien.',
                onTap: () => _open(context, UserRole.partner),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Prototype: login memakai akun demo lokal. '
                  'NaDy bukan alat diagnosis medis.',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: color.primaryContainer,
                child: Icon(icon, color: color.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(subtitle,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
