import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _ctrl = PageController();
  int _page = 0;

  static const _pages = [
    _OPage(
      asset: 'assets/general/gorilla.png',
      overlayColors: [Color(0xFF001A0D), Color(0xFF004B24)],
      accentColor: Color(0xFF004B24),
      icon: Icons.park_rounded,
      tag: 'WILDLIFE',
      title: 'Trek with\nMountain Gorillas',
      body: 'Come face to face with the world\'s most majestic primates in the misty forests of Volcanoes National Park.',
    ),
    _OPage(
      asset: 'assets/general/kcc.png',
      overlayColors: [Color(0xFF0D0D1A), Color(0xFF1A1A4B)],
      accentColor: Color(0xFF1A1A4B),
      icon: Icons.location_city_rounded,
      tag: 'CULTURE',
      title: 'Discover\nKigali City',
      body: 'Explore one of Africa\'s cleanest and most vibrant capitals  rich in history, culture, and modern energy.',
    ),
    _OPage(
      asset: 'assets/general/lake_kivu.png',
      overlayColors: [Color(0xFF001A2E), Color(0xFF003D5C)],
      accentColor: Color(0xFF003D5C),
      icon: Icons.water_rounded,
      tag: 'NATURE',
      title: 'Relax on\nLake Kivu',
      body: 'Unwind on the shores of one of Africa\'s Great Lakes boat tours, sunset views, and lakeside luxury await.',
    ),
  ];

  bool get _isLast => _page == _pages.length - 1;

  void _next() {
    if (!_isLast) {
      _ctrl.nextPage(duration: const Duration(milliseconds: 420), curve: Curves.easeOutCubic);
    } else {
      _finish();
    }
  }

  void _finish() async {
    await context.read<AuthProvider>().markOnboardingSeen();
    if (mounted) context.go('/');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    final top = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // ── Pages ──
            PageView.builder(
              controller: _ctrl,
              onPageChanged: (i) => setState(() => _page = i),
              itemCount: _pages.length,
              itemBuilder: (_, i) => _OnboardingPage(page: _pages[i]),
            ),

            // ── Skip — top right ──
            if (!_isLast)
              Positioned(
                top: top + 12.h,
                right: 24.w,
                child: GestureDetector(
                  onTap: _finish,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                    ),
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              ),

            // ── Bottom bar: dots left + button right ──
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(28.w, 32.h, 28.w, bottom + 32.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // ── Dots ──
                    Row(
                      children: List.generate(_pages.length, (i) {
                        final active = i == _page;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          margin: EdgeInsets.only(right: 6.w),
                          width: active ? 22.w : 6.w,
                          height: 6.w,
                          decoration: BoxDecoration(
                            color: active ? Colors.white : Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                        );
                      }),
                    ),

                    const Spacer(),

                    // ── Next / Get Started button ──
                    GestureDetector(
                      onTap: _next,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutCubic,
                        padding: EdgeInsets.symmetric(
                          horizontal: _isLast ? 28.w : 20.w,
                          vertical: 14.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 250),
                              child: Text(
                                _isLast ? 'Get Started' : 'Next',
                                key: ValueKey(_isLast),
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: _pages[_page].accentColor,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: 26.w,
                              height: 26.w,
                              decoration: BoxDecoration(
                                color: _pages[_page].accentColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _isLast ? Icons.check_rounded : Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 14.w,
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
          ],
        ),
      ),
    );
  }
}

// ── Data model ────────────────────────────────────────────────────────────────
class _OPage {
  final String asset;
  final List<Color> overlayColors;
  final Color accentColor;
  final IconData icon;
  final String tag;
  final String title;
  final String body;

  const _OPage({
    required this.asset,
    required this.overlayColors,
    required this.accentColor,
    required this.icon,
    required this.tag,
    required this.title,
    required this.body,
  });
}

// ── Single page ───────────────────────────────────────────────────────────────
class _OnboardingPage extends StatelessWidget {
  final _OPage page;
  const _OnboardingPage({required this.page});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(page.asset, fit: BoxFit.cover),

        // top vignette
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [Colors.black.withOpacity(0.5), Colors.transparent],
            ),
          ),
        ),

        // bottom colour gradient
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                page.overlayColors[0].withOpacity(0.5),
                page.overlayColors[1].withOpacity(0.93),
                page.overlayColors[1],
              ],
              stops: const [0.38, 0.58, 0.76, 1.0],
            ),
          ),
        ),

        // content
        Positioned(
          left: 28.w,
          right: 28.w,
          bottom: 160.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // tag chip
              Container(
                padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: page.accentColor.withOpacity(0.45)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(page.icon, size: 11.w, color: page.accentColor),
                    SizedBox(width: 5.w),
                    Text(
                      page.tag,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: page.accentColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),
              Text(
                page.title,
                style: TextStyle(
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.12,
                  letterSpacing: -0.8,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                page.body,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white.withOpacity(0.78),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
