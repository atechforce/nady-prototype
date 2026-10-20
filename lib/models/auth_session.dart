enum UserRole { patient, partner }

class DemoAccount {
  final String email;
  final String password;
  final String name;
  final UserRole role;

  const DemoAccount({
    required this.email,
    required this.password,
    required this.name,
    required this.role,
  });
}

class AuthSession {
  // Akun demo untuk prototype. Bukan autentikasi sungguhan.
  static const accounts = <DemoAccount>[
    DemoAccount(
      email: 'pasien@nady.app',
      password: 'nady123',
      name: 'Dylan',
      role: UserRole.patient,
    ),
    DemoAccount(
      email: 'partner@nady.app',
      password: 'nady123',
      name: 'Orang Terdekat',
      role: UserRole.partner,
    ),
  ];

  static UserRole? role;
  static String? name;

  static DemoAccount? demoFor(UserRole r) =>
      accounts.firstWhere((a) => a.role == r);

  static bool login(String email, String password, UserRole r) {
    final e = email.trim().toLowerCase();
    for (final a in accounts) {
      if (a.role == r && a.email == e && a.password == password) {
        role = a.role;
        name = a.name;
        return true;
      }
    }
    return false;
  }

  static void logout() {
    role = null;
    name = null;
  }
}