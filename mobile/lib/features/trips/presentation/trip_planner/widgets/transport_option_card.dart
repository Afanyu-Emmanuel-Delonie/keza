import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class TransportOptionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const TransportOptionCard({
    super.key,
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 14.w),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.surfaceBorder,
            width: 1.5,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withOpacity(0.2)
                    : AppColors.primarySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24.w,
                color: selected ? Colors.white : AppColors.primary,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : AppColors.textHeading,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.sp,
                color: selected
                    ? Colors.white.withOpacity(0.75)
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
