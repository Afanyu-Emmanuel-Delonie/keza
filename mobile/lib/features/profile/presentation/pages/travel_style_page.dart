import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import 'profile_page_scaffold.dart';

class TravelStylePage extends StatefulWidget {
  const TravelStylePage({super.key});

  @override
  State<TravelStylePage> createState() => _TravelStylePageState();
}

class _TravelStylePageState extends State<TravelStylePage> {
  String _selected = 'Solo';

  final _styles = [
    {
      'label': 'Solo',
      'sub': 'Travelling alone, full freedom',
      'icon': Icons.person_rounded,
    },
    {
      'label': 'Couple',
      'sub': 'Romantic getaways for two',
      'icon': Icons.favorite_rounded,
    },
    {
      'label': 'Family',
      'sub': 'Kid-friendly experiences',
      'icon': Icons.family_restroom_rounded,
    },
    {
      'label': 'Group',
      'sub': 'Travelling with friends or a crew',
      'icon': Icons.groups_rounded,
    },
    {
      'label': 'Business',
      'sub': 'Work trips with leisure time',
      'icon': Icons.business_center_rounded,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Travel Style',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How do you usually travel? This helps us tailor recommendations for you.',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary, height: 1.5),
          ),
          SizedBox(height: 24.h),
          ...(_styles.map((s) {
            final active = _selected == s['label'];
            return GestureDetector(
              onTap: () => setState(() => _selected = s['label'] as String),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                decoration: BoxDecoration(
                  color: active ? AppColors.primarySoft : Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: active ? AppColors.primary : AppColors.surfaceBorder,
                    width: active ? 1.5 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: active
                          ? AppColors.primary.withOpacity(0.1)
                          : Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44.w,
                      height: 44.w,
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : AppColors.surfaceRaised,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(s['icon'] as IconData,
                          size: 22.w,
                          color: active ? Colors.white : AppColors.textSecondary),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s['label'] as String,
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: active
                                      ? AppColors.primaryDark
                                      : AppColors.textHeading)),
                          SizedBox(height: 2.h),
                          Text(s['sub'] as String,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22.w,
                      height: 22.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: active ? AppColors.primary : Colors.transparent,
                        border: Border.all(
                          color: active ? AppColors.primary : AppColors.surfaceBorder,
                          width: 1.5,
                        ),
                      ),
                      child: Icon(Icons.check_rounded,
                          size: 12.w,
                          color: active ? Colors.white : Colors.transparent),
                    ),
                  ],
                ),
              ),
            );
          })),
          SizedBox(height: 24.h),
          _SaveButton(onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SaveButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 15.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        alignment: Alignment.center,
        child: Text('Save',
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }
}
