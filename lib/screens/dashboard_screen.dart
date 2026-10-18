import 'package:flutter/material.dart';
import '../widgets/feature_card.dart';
import 'chatbot_screen.dart';
import 'contacts_screen.dart';
import 'education_screen.dart';
import 'profile_screen.dart';
import 'monitoring_screen.dart';
import 'fcm_test_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _go(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final items = <(IconData, String, String, Widget)>[
    (Icons.person, 'Profil', 'Data pengguna', const ProfileScreen()),
    (Icons.menu_book, 'Edukasi', 'Materi anxiety', const EducationScreen()),
    (Icons.chat_bubble, 'Chatbot', 'Tanya NaDy (demo)',
        const ChatbotScreen()),
    (Icons.contacts, 'Kontak Darurat', 'Orang terdekat',
        const ContactsScreen()),
    (Icons.monitor_heart, 'Sesi Monitoring', 'Simulasi sesi',
        const MonitoringScreen()),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('NaDy',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active_outlined),
            onPressed: () => _go(context, const FcmTestScreen()),
    ),
  ],
),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Halo! Bagaimana kabarmu hari ini?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            const Text(
              'Prototype pendamping anxiety. Bukan alat diagnosis medis.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.05,
                children: [
                  for (final item in items)
                    FeatureCard(
                      icon: item.$1,
                      title: item.$2,
                      subtitle: item.$3,
                      onTap: () => _go(context, item.$4),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}