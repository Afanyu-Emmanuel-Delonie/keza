import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';

/// Section header + horizontal scrolling list.
/// Used by Destinations, Stays, and Things To Do sections in Explore.
class ExploreSectionRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> cards;
  final VoidCallback? onSeeAll;

  const ExploreSectionRow({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.cards,
    this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──
        Row(
            children: [
              Container(
                padding: EdgeInsets.all(7.w),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, size: 16.w, color: AppColors.primary),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textHeading,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (onSeeAll != null)
                GestureDetector(
                  onTap: onSeeAll,
                  child: Row(
                    children: [
                      Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 11.w,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        SizedBox(height: 14.h),

        // ── Horizontal card list ──
        SizedBox(
          height: 290.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: EdgeInsets.only(right: 6.w),
            children: cards,
          ),
        ),
      ],
    );
  }
}
