import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FcmTestScreen extends StatefulWidget {
  const FcmTestScreen({super.key});

  @override
  State<FcmTestScreen> createState() => _FcmTestScreenState();
}

class _FcmTestScreenState extends State<FcmTestScreen> {
  String _status = 'Menyiapkan...';
  String? _token;
  final List<String> _received = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission();
      final token = await messaging.getToken();
      FirebaseMessaging.onMessage.listen((m) {
        if (!mounted) return;
        setState(() => _received.insert(
            0, '${m.notification?.title ?? '-'}: ${m.notification?.body ?? '-'}'));
      });
      if (!mounted) return;
      setState(() {
        _token = token;
        _status = 'Izin notifikasi: ${settings.authorizationStatus.name}';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _status = 'Gagal: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Uji FCM (eksperimen)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(_status),
          const SizedBox(height: 12),
          const Text('Token perangkat:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SelectableText(_token ?? 'Belum ada token'),
          if (_token != null)
            TextButton.icon(
              icon: const Icon(Icons.copy),
              label: const Text('Salin token'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: _token!));
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Token disalin')));
              },
            ),
          const Divider(height: 32),
          const Text('Pesan diterima (saat aplikasi terbuka):',
              style: TextStyle(fontWeight: FontWeight.bold)),
          for (final r in _received) Text('• $r'),
        ],
      ),
    );
  }
}