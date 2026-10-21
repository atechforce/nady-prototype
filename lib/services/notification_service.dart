import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/emergency_contact.dart';
import '../models/user_profile.dart';

/// Service untuk mengirim push notification FCM ke kontak darurat
/// yang sudah memiliki FCM token terdaftar.
///
/// Catatan prototype:
/// Pengiriman dilakukan langsung dari client ke FCM Legacy HTTP API menggunakan
/// server key. Untuk produksi, sebaiknya gunakan backend server agar server key
/// tidak tersimpan di client.
class NotificationService {
  // Ganti dengan Server Key dari Firebase Console → Project Settings → Cloud Messaging.
  static const String _serverKey = '697761364862';

  static const String _fcmUrl =
      'https://fcm.googleapis.com/fcm/send';

  /// Mengirim notifikasi ke semua kontak darurat yang memiliki FCM token.
  /// Mengembalikan jumlah notifikasi yang berhasil dikirim.
  static Future<int> sendAnxietyAlert() async {
    final userName = UserProfile.current.name;
    final targets = EmergencyContact.all
        .where((c) => c.fcmToken != null && c.fcmToken!.trim().isNotEmpty)
        .toList();

    if (targets.isEmpty) return 0;

    int successCount = 0;
    for (final contact in targets) {
      final sent = await _sendToToken(
        token: contact.fcmToken!,
        title: 'Peringatan dari NaDy 🔔',
        body: '$userName menunjukkan tanda kecemasan. '
            'Mohon hubungi ${userName.split(' ').first} segera.',
      );
      if (sent) successCount++;
    }
    return successCount;
  }

  static Future<bool> _sendToToken({
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(_fcmUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$_serverKey',
        },
        body: jsonEncode({
          'to': token,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': {
            'type': 'anxiety_alert',
          },
        }),
      );
      if (response.statusCode == 200) {
        debugPrint('[NotificationService] Berhasil dikirim ke $token');
        return true;
      } else {
        debugPrint(
            '[NotificationService] Gagal ($token): ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      debugPrint('[NotificationService] Error ($token): $e');
      return false;
    }
  }
}
