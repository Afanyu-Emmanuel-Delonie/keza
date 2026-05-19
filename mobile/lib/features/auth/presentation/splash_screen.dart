import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // ── Main sequence controller ──
  late final AnimationController _seq;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _wordFade;
  late final Animation<Offset> _wordSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<Offset> _subtitleSlide;
  late final Animation<double> _creditFade;

  // ── Pulse ring ──
  late final AnimationController _pulse;
  late final Animation<double> _pulseScale;
  late final Animation<double> _pulseOpacity;

  // ── Shimmer sweep across wordmark ──
  late final AnimationController _shimmer;
  late final Animation<double> _shimmerPos;

  // ── Rotating orbit dots ──
  late final AnimationController _orbit;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    // ── Sequence ──
    _seq = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));

    _logoScale = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _seq, curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack)),
    );
    _logoFade = CurvedAnimation(
      parent: _seq,
      curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
    );
    _wordFade = CurvedAnimation(
      parent: _seq,
      curve: const Interval(0.38, 0.62, curve: Curves.easeIn),
    );
    _wordSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(parent: _seq, curve: const Interval(0.38, 0.62, curve: Curves.easeOutCubic)),
    );
    _subtitleFade = CurvedAnimation(
      parent: _seq,
      curve: const Interval(0.55, 0.75, curve: Curves.easeIn),
    );
    _subtitleSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _seq, curve: const Interval(0.55, 0.75, curve: Curves.easeOutCubic)),
    );
    _creditFade = CurvedAnimation(
      parent: _seq,
      curve: const Interval(0.78, 1.0, curve: Curves.easeIn),
    );

    // ── Pulse ring — starts after logo appears ──
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))
      ..repeat();
    _pulseScale = Tween<double>(begin: 0.85, end: 1.6).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeOut),
    );
    _pulseOpacity = Tween<double>(begin: 0.45, end: 0.0).animate(
      CurvedAnimation(parent: _pulse, curve: Curves.easeOut),
    );

    // ── Shimmer — fires once after wordmark is visible ──
    _shimmer = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _shimmerPos = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shimmer, curve: Curves.easeInOut),
    );

    // ── Orbit dots ──
    _orbit = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000))
      ..repeat();

    _seq.forward();

    // Trigger shimmer once wordmark is fully visible
    Future.delayed(const Duration(milliseconds: 1300), () {
      if (mounted) _shimmer.forward();
    });

    Future.delayed(const Duration(milliseconds: 3000), () {
      if (mounted) context.go('/');
    });
  }

  @override
  void dispose() {
    _seq.dispose();
    _pulse.dispose();
    _shimmer.dispose();
    _orbit.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDarker,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
        child: Stack(
          children: [
            // ── Orbit dots ──
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _orbit,
                builder: (_, __) => CustomPaint(
                  painter: _OrbitPainter(_orbit.value),
                ),
              ),
            ),

            // ── Pulse ring behind logo ──
            Center(
              child: AnimatedBuilder(
                animation: _pulse,
                builder: (_, __) => Opacity(
                  opacity: _pulseOpacity.value,
                  child: Transform.scale(
                    scale: _pulseScale.value,
                    child: Container(
                      width: 130.w,
                      height: 130.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Static radial glow ──
            Center(
              child: Container(
                width: 260.w,
                height: 260.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // ── Logo ──
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ScaleTransition(
                    scale: _logoScale,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: SvgPicture.asset(
                        'assets/general/main-logo.svg',
                        height: 88.h,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 22.h),

                  // ── Wordmark with shimmer ──
                  SlideTransition(
                    position: _wordSlide,
                    child: FadeTransition(
                      opacity: _wordFade,
                      child: AnimatedBuilder(
                        animation: _shimmerPos,
                        builder: (_, child) => ShaderMask(
                          blendMode: BlendMode.srcATop,
                          shaderCallback: (bounds) => LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [
                              (_shimmerPos.value - 0.3).clamp(0.0, 1.0),
                              _shimmerPos.value.clamp(0.0, 1.0),
                              (_shimmerPos.value + 0.3).clamp(0.0, 1.0),
                            ],
                            colors: const [
                              Colors.white,
                              Color(0xFFCCFFDD),
                              Colors.white,
                            ],
                          ).createShader(bounds),
                          child: child!,
                        ),
                        child: Text(
                          'Keza',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 44.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 8.h),

                  // ── Subtitle ──
                  SlideTransition(
                    position: _subtitleSlide,
                    child: FadeTransition(
                      opacity: _subtitleFade,
                      child: Text(
                        'DISCOVER RWANDA',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.55),
                          fontSize: 11.sp,
                          letterSpacing: 4.0,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Developer credit ──
            Positioned(
              bottom: 36.h,
              left: 0,
              right: 0,
              child: FadeTransition(
                opacity: _creditFade,
                child: Column(
                  children: [
                    Text(
                      'developed by',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 10.sp,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    RichText(
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.7),
                          letterSpacing: 0.3,
                        ),
                        children: const [
                          TextSpan(text: '<', style: TextStyle(color: Color(0xFF4ADE80))),
                          TextSpan(text: 'Afanyu'),
                          TextSpan(text: ' />', style: TextStyle(color: Color(0xFF4ADE80))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Floating orbit dots painter ──
class _OrbitPainter extends CustomPainter {
  final double t;
  _OrbitPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    const dots = [
      _Dot(radius: 110, size: 3.5, speed: 1.0, offset: 0.0, opacity: 0.25),
      _Dot(radius: 145, size: 2.5, speed: 0.65, offset: 0.33, opacity: 0.18),
      _Dot(radius: 175, size: 2.0, speed: 0.45, offset: 0.66, opacity: 0.12),
      _Dot(radius: 95,  size: 2.0, speed: 1.3,  offset: 0.5,  opacity: 0.20),
    ];

    for (final d in dots) {
      final angle = 2 * math.pi * ((t * d.speed + d.offset) % 1.0);
      final dx = cx + d.radius * math.cos(angle);
      final dy = cy + d.radius * math.sin(angle);
      canvas.drawCircle(
        Offset(dx, dy),
        d.size,
        Paint()..color = AppColors.primary.withOpacity(d.opacity),
      );
    }
  }

  @override
  bool shouldRepaint(_OrbitPainter old) => old.t != t;
}

class _Dot {
  final double radius;
  final double size;
  final double speed;
  final double offset;
  final double opacity;
  const _Dot({
    required this.radius,
    required this.size,
    required this.speed,
    required this.offset,
    required this.opacity,
  });
}
