import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';

class AiIdleState extends StatelessWidget {
  final ValueChanged<String> onChipTap;
  const AiIdleState({super.key, required this.onChipTap});

  static const _suggestions = [
    ('🦍', 'Gorilla trekking in Musanze'),
    ('🏙️', 'Things to do in Kigali'),
    ('🌊', 'Lake Kivu experiences'),
    ('🌿', 'Eco lodges in Nyungwe'),
    ('🎒', 'Budget trips under \$200'),
    ('📅', '5-day Rwanda itinerary'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero banner
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: AppColors.aiGradient,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDarker.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text('POWERED BY AI',
                            style: TextStyle(
                                fontSize: 9.sp,
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5)),
                      ),
                      SizedBox(height: 10.h),
                      Text('Where do you\nwant to go?',
                          style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1.2,
                              letterSpacing: -0.5)),
                      SizedBox(height: 6.h),
                      Text('Describe your dream trip — AI finds destinations, then asks if you need a place to stay.',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white.withOpacity(0.75),
                              height: 1.5)),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Opacity(
                  opacity: 0.2,
                  child: SvgPicture.asset(
                    'assets/general/main-logo.svg',
                    width: 64.w,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 28.h),
          Text('Try asking',
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textHeading)),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _suggestions.map((s) {
              return GestureDetector(
                onTap: () => onChipTap(s.$2),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: AppColors.surfaceBorder),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 6,
                          offset: const Offset(0, 2)),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(s.$1, style: TextStyle(fontSize: 13.sp)),
                      SizedBox(width: 6.w),
                      Text(s.$2,
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
