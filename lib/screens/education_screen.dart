import 'package:flutter/material.dart';
import '../data/education_data.dart';
import '../models/education_material.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edukasi Anxiety')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: educationMaterials.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final m = educationMaterials[i];
          return Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: Icon(m.icon,
                  color: Theme.of(context).colorScheme.primary),
              title: Text(m.title,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(m.summary),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => EducationDetailScreen(material: m)),
              ),
            ),
          );
        },
      ),
    );
  }
}

class EducationDetailScreen extends StatelessWidget {
  final EducationMaterial material;
  const EducationDetailScreen({super.key, required this.material});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(material.category)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(material.title,
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(material.content,
                style: const TextStyle(fontSize: 16, height: 1.5)),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Materi ini bersifat informatif dan bukan pengganti '
                'tenaga profesional.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}