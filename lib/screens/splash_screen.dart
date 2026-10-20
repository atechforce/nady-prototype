import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/nady_logo.dart';
import 'role_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _intro;
  late final AnimationController _pulse;
  late final AnimationController _exit;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _tagFade;
  late final Animation<Offset> _exitSlide;
  late final Animation<double> _exitFade;

  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    // Tulisan dan lingkaran keluar sebelum hati terbang.
    _exit = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _logoScale = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.0, 0.45, curve: Curves.elasticOut),
    );
    _logoFade = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
    );
    final textCurve = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.35, 0.65, curve: Curves.easeOutCubic),
    );
    _textFade = textCurve;
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(textCurve);
    _tagFade = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.6, 0.85, curve: Curves.easeOut),
    );

    final exitCurve = CurvedAnimation(parent: _exit, curve: Curves.easeInCubic);
    _exitSlide = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.3, 0), // geser ke kanan
    ).animate(exitCurve);
    _exitFade = Tween<double>(begin: 1, end: 0).animate(exitCurve);

    _intro.forward().whenComplete(() async {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted || _navigated) return;
      await _exit.forward();
      _goNext();
    });
  }

  void _goNext() {
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 900),
        pageBuilder: (_, __, ___) => const RoleSelectionScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _intro.dispose();
    _pulse.dispose();
    _exit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _goNext, // ketuk layar untuk melewati intro
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFDCEBF8), Color(0xFFF5F9FC)],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Lingkaran napas (memudar saat keluar).
                    FadeTransition(
                      opacity: _exitFade,
                      child: AnimatedBuilder(
                        animation: _pulse,
                        builder: (_, __) => CustomPaint(
                          size: const Size(280, 280),
                          painter: _RipplePainter(_pulse.value, color.primary),
                        ),
                      ),
                    ),
                    // Logo hati: muncul membal, berdenyut, lalu terbang (Hero).
                    FadeTransition(
                      opacity: _logoFade,
                      child: ScaleTransition(
                        scale: _logoScale,
                        child: AnimatedBuilder(
                          animation: _pulse,
                          builder: (_, child) => Transform.scale(
                            scale: 1 +
                                0.05 * math.sin(_pulse.value * 2 * math.pi),
                            child: child,
                          ),
                          child: const Hero(
                            tag: 'nady-logo',
                            child: SizedBox(
                              width: 104,
                              height: 104,
                              child: NadyLogo(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Tulisan: geser ke kanan lalu hilang saat keluar.
              SlideTransition(
                position: _exitSlide,
                child: FadeTransition(
                  opacity: _exitFade,
                  child: Column(
                    children: [
                      SlideTransition(
                        position: _textSlide,
                        child: FadeTransition(
                          opacity: _textFade,
                          child: Text(
                            'NaDy',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                              color: color.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      FadeTransition(
                        opacity: _tagFade,
                        child: const Text(
                          'Pendamping untuk kecemasan',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double t;
  final Color color;
  _RipplePainter(this.t, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < 3; i++) {
      final p = (t + i / 3) % 1.0;
      final radius = 56 + 84 * p;
      final alpha = (1 - p) * 0.28;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..color = color.withValues(alpha: alpha);
      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RipplePainter old) => old.t != t;
}