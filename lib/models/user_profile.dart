class UserProfile {
  String name;
  String age;
  String email;
  String medicalHistory;

  UserProfile({
    required this.name,
    required this.age,
    required this.email,
    required this.medicalHistory,
  });

  // Data disimpan di memori selama aplikasi berjalan (prototype).
  static UserProfile current = UserProfile(
    name: 'Dylan',
    age: '20',
    email: 'dylan@example.com',
    medicalHistory: 'Belum ada catatan',
  );
}