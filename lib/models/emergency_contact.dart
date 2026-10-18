class EmergencyContact {
  final String name;
  final String relation;
  final String phone;

  const EmergencyContact({
    required this.name,
    required this.relation,
    required this.phone,
  });

  // Disimpan di memori selama aplikasi berjalan (prototype).
  static final List<EmergencyContact> all = [];
}