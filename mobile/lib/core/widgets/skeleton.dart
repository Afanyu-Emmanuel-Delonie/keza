import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

// ── Shimmer base widget ───────────────────────────────────────────────────────
class _Shimmer extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const _Shimmer({
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _anim = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius.r),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [
              (_anim.value - 0.5).clamp(0.0, 1.0),
              _anim.value.clamp(0.0, 1.0),
              (_anim.value + 0.5).clamp(0.0, 1.0),
            ],
            colors: const [
              AppColors.shimmerBase,
              AppColors.shimmerHighlight,
              AppColors.shimmerBase,
            ],
          ),
        ),
      ),
    );
  }
}

// ── Public skeleton box ───────────────────────────────────────────────────────
class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) =>
      _Shimmer(width: width, height: height, radius: radius);
}

// ── Full home skeleton ────────────────────────────────────────────────────────
class HomeSkeletonScreen extends StatelessWidget {
  const HomeSkeletonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header row ──
              Row(
                children: [
                  SkeletonBox(width: 44.w, height: 44.w, radius: 22),
                  SizedBox(width: 10.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(width: 80.w, height: 10.h),
                      SizedBox(height: 6.h),
                      SkeletonBox(width: 130.w, height: 13.h),
                    ],
                  ),
                  const Spacer(),
                  SkeletonBox(width: 36.w, height: 36.w, radius: 18),
                ],
              ),
              SizedBox(height: 20.h),

              // ── Search bar ──
              SkeletonBox(width: double.infinity, height: 48.h, radius: 14),
              SizedBox(height: 20.h),

              // ── AI card ──
              SkeletonBox(width: double.infinity, height: 90.h, radius: 16),
              SizedBox(height: 24.h),

              // ── Category chips ──
              Row(
                children: List.generate(4, (i) => Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: SkeletonBox(width: 72.w, height: 34.h, radius: 20),
                )),
              ),
              SizedBox(height: 24.h),

              // ── Section title ──
              SkeletonBox(width: 120.w, height: 16.h),
              SizedBox(height: 12.h),

              // ── Horizontal destination cards ──
              SizedBox(
                height: 240.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (_, i) => Padding(
                    padding: EdgeInsets.only(right: 15.w),
                    child: SkeletonBox(width: 220.w, height: 240.h, radius: 20),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              // ── Section title ──
              SkeletonBox(width: 100.w, height: 16.h),
              SizedBox(height: 12.h),

              // ── Stay list items ──
              ...List.generate(3, (i) => Padding(
                padding: EdgeInsets.only(bottom: 12.h),
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      SkeletonBox(width: 80.w, height: 80.w, radius: 12),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SkeletonBox(width: 140.w, height: 13.h),
                            SizedBox(height: 8.h),
                            SkeletonBox(width: 100.w, height: 10.h),
                            SizedBox(height: 8.h),
                            SkeletonBox(width: 60.w, height: 10.h),
                            SizedBox(height: 8.h),
                            SkeletonBox(width: 80.w, height: 12.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
