class EmergencyContact {
  final String name;
  final String relation;
  final String phone;
  // FCM device token milik kontak ini (opsional).
  // Jika diisi, notifikasi push akan dikirimkan ke perangkat kontak.
  final String? fcmToken;

  const EmergencyContact({
    required this.name,
    required this.relation,
    required this.phone,
    this.fcmToken,
  });

  // Disimpan di memori selama aplikasi berjalan (prototype).
  static final List<EmergencyContact> all = [];
}