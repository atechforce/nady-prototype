import 'package:flutter/material.dart';
import '../models/auth_session.dart';
import '../models/user_profile.dart';
import '../services/auth_service.dart';
import 'dashboard_screen.dart';
import 'partner_home_screen.dart';

class LoginScreen extends StatefulWidget {
  final UserRole role;
  const LoginScreen({super.key, required this.role});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hide = true;
  bool _googleLoading = false;
  String? _error;

  bool get _isPatient => widget.role == UserRole.patient;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _fillDemo() {
    final demo = AuthSession.demoFor(widget.role)!;
    setState(() {
      _email.text = demo.email;
      _password.text = demo.password;
      _error = null;
    });
  }

  void _enter() {
    final Widget next =
        _isPatient ? const DashboardScreen() : const PartnerHomeScreen();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => next),
      (route) => false,
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final ok = AuthSession.login(_email.text, _password.text, widget.role);
    if (!ok) {
      setState(() => _error = 'Email atau kata sandi salah untuk peran ini.');
      return;
    }
    _enter();
  }

  Future<void> _googleLogin() async {
    setState(() {
      _googleLoading = true;
      _error = null;
    });
    try {
      final user = await AuthService.signInWithGoogle();
      if (user == null) throw Exception('Akun Google tidak ditemukan');
      final name = user.displayName ?? user.email ?? 'Pengguna';
      final mail = user.email ?? '';
      AuthSession.loginExternal(
          r: widget.role, displayName: name, mail: mail);
      if (_isPatient) {
        UserProfile.current.name = name;
        if (mail.isNotEmpty) UserProfile.current.email = mail;
      }
      if (!mounted) return;
      _enter();
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = 'Login Google gagal atau dibatalkan: $e');
    } finally {
      if (mounted) setState(() => _googleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final demo = AuthSession.demoFor(widget.role)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(_isPatient ? 'Login Pasien' : 'Login Partner'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isPatient ? 'Masuk sebagai Pasien' : 'Masuk sebagai Partner',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _googleLoading ? null : _googleLogin,
                  icon: _googleLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.account_circle),
                  label: const Text('Lanjutkan dengan Google'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('atau', style: TextStyle(color: Colors.black54)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    labelText: 'Email', border: OutlineInputBorder()),
                validator: (v) => (v == null || !v.contains('@'))
                    ? 'Format email salah'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _password,
                obscureText: _hide,
                decoration: InputDecoration(
                  labelText: 'Kata sandi',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon:
                        Icon(_hide ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _hide = !_hide),
                  ),
                ),
                validator: (v) => (v == null || v.length < 6)
                    ? 'Kata sandi minimal 6 karakter'
                    : null,
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _submit,
                  child: const Text('Masuk'),
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.amber.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Akun demo (prototype)',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text('Email: ${demo.email}'),
                    Text('Kata sandi: ${demo.password}'),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: _fillDemo,
                      child: const Text('Isi otomatis'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}