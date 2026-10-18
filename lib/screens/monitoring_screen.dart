import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../models/emergency_contact.dart';
import 'contacts_screen.dart';

// Konstanta demo (dipercepat agar mudah didemonstrasikan).
const int kSessionLimitSeconds = 120; // mewakili batas 1 jam versi gratis
const int kAlertCountdownSeconds = 10; // mewakili jeda 30 detik
const int kCooldownSeconds = 15; // jeda sebelum peringatan baru
const double kThreshold = 70; // ambang skor kecemasan simulasi

class MonitoringScreen extends StatefulWidget {
  const MonitoringScreen({super.key});

  @override
  State<MonitoringScreen> createState() => _MonitoringScreenState();
}

class _MonitoringScreenState extends State<MonitoringScreen> {
  final _rand = Random();
  Timer? _timer;

  bool _active = false;
  bool _finished = false;
  String _endReason = '';

  int _elapsed = 0;
  double _score = 20;
  int _highStreak = 0;
  int _cooldown = 0;
  int? _countdown;

  final List<double> _scores = [];
  final List<String> _log = [];
  int _alerts = 0;
  int _falseAlarms = 0;
  int _sent = 0;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _fmt(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _addLog(String text) {
    _log.insert(0, '[${_fmt(_elapsed)}] $text');
  }

  void _start() {
    if (EmergencyContact.all.isEmpty) return;
    setState(() {
      _active = true;
      _finished = false;
      _elapsed = 0;
      _score = 20;
      _highStreak = 0;
      _cooldown = 0;
      _countdown = null;
      _scores.clear();
      _log.clear();
      _alerts = 0;
      _falseAlarms = 0;
      _sent = 0;
      _addLog('Sesi dimulai (simulasi).');
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _stop(String reason) {
    _timer?.cancel();
    setState(() {
      _active = false;
      _finished = true;
      _endReason = reason;
      _countdown = null;
    });
  }

  void _tick() {
    setState(() {
      _elapsed++;
      if (_cooldown > 0) _cooldown--;

      if (_countdown != null) {
        _countdown = _countdown! - 1;
        if (_countdown! <= 0) _sendNotification();
      } else if (_elapsed % 2 == 0) {
        // Skor simulasi: acak, cenderung kembali ke nilai rendah.
        _score += (25 - _score) * 0.1 + (_rand.nextDouble() * 16 - 8);
        _score = _score.clamp(5, 100).toDouble();
        _scores.add(_score);

        _highStreak = _score >= kThreshold ? _highStreak + 1 : 0;
        if (_highStreak >= 3 && _cooldown == 0) _triggerAlert();
      }
    });

    // Sesi gratis berakhir hanya jika tidak ada peringatan yang sedang berjalan.
    if (_elapsed >= kSessionLimitSeconds && _countdown == null) {
      _stop('Batas versi gratis tercapai');
    }
  }

  void _simulateSpike() {
    if (_countdown != null || _cooldown > 0) return;
    setState(() {
      _score = 88;
      _scores.add(_score);
      _addLog('Lonjakan kecemasan disimulasikan (skor 88).');
      _triggerAlert();
    });
  }

  void _triggerAlert() {
    _alerts++;
    _countdown = kAlertCountdownSeconds;
    _addLog('Skor tinggi terdeteksi. Hitung mundur dimulai.');
  }

  void _cancelAlert() {
    setState(() {
      _countdown = null;
      _falseAlarms++;
      _score = 30;
      _highStreak = 0;
      _cooldown = kCooldownSeconds;
      _addLog('Pengguna membatalkan: dicatat sebagai alarm palsu.');
    });
  }

  void _sendNotification() {
    final name = _userName();
    for (final c in EmergencyContact.all) {
      _addLog('[SIMULASI] Notifikasi ke ${c.name} (${c.relation}): '
          '"$name menunjukkan tanda kecemasan. Mohon dihubungi."');
    }
    _sent += EmergencyContact.all.length;
    _countdown = null;
    _highStreak = 0;
    _cooldown = kCooldownSeconds;
  }

  String _userName() => 'Pengguna NaDy';

  Color _scoreColor() {
    if (_score >= kThreshold) return Colors.red;
    if (_score >= 50) return Colors.orange;
    return Colors.green;
  }

  Widget _banner() => Container(
        width: double.infinity,
        color: Colors.amber.shade50,
        padding: const EdgeInsets.all(8),
        child: const Text(
          'Simulasi prototype: skor acak, bukan deteksi AI atau diagnosis medis.',
          style: TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      );

  Widget _card({required Widget child, Color? color}) => Card(
        elevation: 0,
        color: color ?? Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      );

  Widget _logCard() {
    if (_log.isEmpty) return const SizedBox.shrink();
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Catatan kejadian',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          for (final l in _log.take(12))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(l, style: const TextStyle(fontSize: 12)),
            ),
        ],
      ),
    );
  }

  Widget _idleView() {
    final hasContacts = EmergencyContact.all.isNotEmpty;
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Mulai sesi pemantauan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Versi gratis dibatasi 1 jam per sesi '
              '(dipercepat jadi ${_fmt(kSessionLimitSeconds)} untuk demo).'),
          const SizedBox(height: 12),
          if (!hasContacts) ...[
            const Text(
              'Belum ada kontak darurat. Tambahkan minimal 1 kontak '
              'sebelum memulai sesi.',
              style: TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.contacts),
                label: const Text('Tambah kontak darurat'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactsScreen()),
                ).then((_) => setState(() {})),
              ),
            ),
          ] else ...[
            Text('Kontak darurat: ${EmergencyContact.all.length} orang'),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.play_arrow),
                label: const Text('Mulai sesi'),
                onPressed: _start,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _activeView() {
    final remaining = kSessionLimitSeconds - _elapsed;
    return Column(
      children: [
        _card(
          child: Column(
            children: [
              const Text('Pemantauan aktif (simulasi)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Sisa waktu: ${_fmt(remaining < 0 ? 0 : remaining)}'),
              const SizedBox(height: 16),
              Text(_score.toStringAsFixed(0),
                  style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      color: _scoreColor())),
              const Text('Skor kecemasan simulasi (0-100)'),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: _score / 100,
                minHeight: 10,
                color: _scoreColor(),
                borderRadius: BorderRadius.circular(8),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_countdown != null)
          _card(
            color: Colors.red.shade50,
            child: Column(
              children: [
                const Text(
                  'Kami mendeteksi tanda kecemasan (simulasi).',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text('Notifikasi ke orang terdekat dikirim dalam '
                    '$_countdown detik.'),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _cancelAlert,
                    child: const Text('Saya baik-baik saja'),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.warning_amber),
                label: const Text('Simulasikan lonjakan'),
                onPressed: _simulateSpike,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton.tonalIcon(
                icon: const Icon(Icons.stop),
                label: const Text('Akhiri sesi'),
                onPressed: () => _stop('Sesi diakhiri pengguna'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _logCard(),
      ],
    );
  }

  Widget _finishedView() {
    final avg = _scores.isEmpty
        ? 0
        : _scores.reduce((a, b) => a + b) / _scores.length;
    final max = _scores.isEmpty ? 0 : _scores.reduce(math_max);
    return Column(
      children: [
        _card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Hasil sesi (simulasi)',
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(_endReason,
                  style: const TextStyle(color: Colors.black54)),
              const Divider(height: 24),
              Text('Durasi: ${_fmt(_elapsed)}'),
              Text('Skor rata-rata: ${avg.toStringAsFixed(0)}'),
              Text('Skor tertinggi: ${max.toStringAsFixed(0)}'),
              Text('Peringatan muncul: $_alerts'),
              Text('Dibatalkan pengguna (alarm palsu): $_falseAlarms'),
              Text('Notifikasi simulasi terkirim: $_sent'),
              const SizedBox(height: 12),
              const Text(
                'Hasil ini hanya simulasi dan bukan diagnosis medis. '
                'Jika kamu merasa tidak baik-baik saja, hubungi orang '
                'terdekat atau tenaga profesional.',
                style: TextStyle(fontSize: 12),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.refresh),
                  label: const Text('Mulai sesi baru'),
                  onPressed: _start,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _logCard(),
      ],
    );
  }

  double math_max(double a, double b) => a > b ? a : b;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_active,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _active) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Akhiri sesi dulu sebelum kembali.')));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Sesi Monitoring')),
        body: Column(
          children: [
            _banner(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (_active)
                    _activeView()
                  else if (_finished)
                    _finishedView()
                  else
                    _idleView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}