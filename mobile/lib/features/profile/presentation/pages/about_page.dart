import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import 'profile_page_scaffold.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'About Keza',
      child: Column(
        children: [
          // ── Logo + version ──
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 32.h),
            decoration: BoxDecoration(
              gradient: AppColors.aiGradient,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              children: [
                Container(
                  width: 72.w,
                  height: 72.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.explore_rounded, color: Colors.white, size: 36.w),
                ),
                SizedBox(height: 14.h),
                Text(
                  'Keza Tour',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Version 1.0.0',
                  style: TextStyle(
                      fontSize: 12.sp, color: Colors.white.withOpacity(0.65)),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    'Discover Rwanda',
                    style: TextStyle(
                        fontSize: 11.sp,
                        color: Colors.white.withOpacity(0.85),
                        letterSpacing: 1.5),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // ── Mission ──
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CardTitle(icon: Icons.flag_outlined, label: 'Our Mission'),
                SizedBox(height: 10.h),
                Text(
                  'Keza is a smart hospitality and tourism platform transforming how people discover, experience, and explore Rwanda digitally. We connect travellers, hospitality providers, tour operators, and local experiences within one unified platform.',
                  style: TextStyle(
                      fontSize: 13.sp, color: AppColors.textSecondary, height: 1.65),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          // ── Key features ──
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CardTitle(icon: Icons.star_outline_rounded, label: 'Key Features'),
                SizedBox(height: 12.h),
                ...[
                  (Icons.hotel_rounded, 'Accommodation Discovery', 'Browse hotels, lodges & resorts across Rwanda'),
                  (Icons.auto_awesome_rounded, 'AI Trip Planner', 'Personalised itineraries powered by Keza AI'),
                  (Icons.explore_rounded, 'Tourism & Experiences', 'Guided tours, cultural experiences & attractions'),
                  (Icons.group_rounded, 'Group Travel', 'Plan and coordinate trips with friends & family'),
                ].map((f) => Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(7.w),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(f.$1, size: 15.w, color: AppColors.primary),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(f.$2,
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textHeading)),
                            Text(f.$3,
                                style: TextStyle(
                                    fontSize: 11.sp, color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          // ── Developer ──
          _Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _CardTitle(icon: Icons.code_rounded, label: 'Developer'),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Container(
                      width: 46.w,
                      height: 46.w,
                      decoration: BoxDecoration(
                        gradient: AppColors.aiGradient,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text('A',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textHeading),
                            children: const [
                              TextSpan(text: '<', style: TextStyle(color: Color(0xFF4ADE80))),
                              TextSpan(text: 'Afanyu'),
                              TextSpan(text: ' />', style: TextStyle(color: Color(0xFF4ADE80))),
                            ],
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text('Flutter Developer · Rwanda',
                            style: TextStyle(
                                fontSize: 12.sp, color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),

          // ── Legal links ──
          _Card(
            child: Column(
              children: [
                _LinkRow(icon: Icons.privacy_tip_outlined, label: 'Privacy Policy', onTap: () {}),
                Divider(height: 1, indent: 46.w, color: AppColors.surfaceBorder),
                _LinkRow(icon: Icons.description_outlined, label: 'Terms of Service', onTap: () {}),
                Divider(height: 1, indent: 46.w, color: AppColors.surfaceBorder),
                _LinkRow(icon: Icons.email_outlined, label: 'Contact: hello@kezatour.rw', onTap: () {}, isLast: true),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          Text(
            '© 2025 Keza Tour Ltd. All rights reserved.',
            style: TextStyle(fontSize: 11.sp, color: AppColors.textDisabled),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CardTitle extends StatelessWidget {
  final IconData icon;
  final String label;
  const _CardTitle({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16.w, color: AppColors.primary),
        SizedBox(width: 8.w),
        Text(label,
            style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textHeading)),
      ],
    );
  }
}

class _LinkRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isLast;

  const _LinkRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Icon(icon, size: 16.w, color: AppColors.textSecondary),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(label,
                  style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary)),
            ),
            Icon(Icons.chevron_right_rounded, size: 16.w, color: AppColors.textDisabled),
          ],
        ),
      ),
    );
  }
}
