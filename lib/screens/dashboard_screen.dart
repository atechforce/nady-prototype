import 'package:flutter/material.dart';
import '../widgets/feature_card.dart';
import 'placeholder_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  void _open(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PlaceholderScreen(title: title)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.person, 'Profil', 'Data pengguna'),
      (Icons.menu_book, 'Edukasi', 'Materi anxiety'),
      (Icons.chat_bubble, 'Chatbot', 'Tanya NaDy (demo)'),
      (Icons.contacts, 'Kontak Darurat', 'Orang terdekat'),
      (Icons.monitor_heart, 'Sesi Monitoring', 'Simulasi sesi'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('NaDy',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
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
                      onTap: () => _open(context, item.$2),
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