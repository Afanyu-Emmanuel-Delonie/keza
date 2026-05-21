import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import 'profile_page_scaffold.dart';

class InterestsPage extends StatefulWidget {
  const InterestsPage({super.key});

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  final _interests = [
    {'icon': Icons.park_outlined, 'label': 'Nature'},
    {'icon': Icons.pets_outlined, 'label': 'Wildlife'},
    {'icon': Icons.terrain_outlined, 'label': 'Hiking'},
    {'icon': Icons.camera_alt_outlined, 'label': 'Photography'},
    {'icon': Icons.museum_outlined, 'label': 'Culture'},
    {'icon': Icons.history_edu_outlined, 'label': 'History'},
    {'icon': Icons.restaurant_outlined, 'label': 'Food'},
    {'icon': Icons.beach_access_outlined, 'label': 'Relaxation'},
    {'icon': Icons.directions_bike_outlined, 'label': 'Adventure'},
    {'icon': Icons.water_outlined, 'label': 'Water Sports'},
    {'icon': Icons.nightlife_outlined, 'label': 'Nightlife'},
    {'icon': Icons.shopping_bag_outlined, 'label': 'Shopping'},
  ];

  final Set<String> _selected = {'Nature', 'Wildlife'};

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Interests',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What do you love to do when travelling?',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary, height: 1.5),
          ),
          SizedBox(height: 24.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: _interests.map((item) {
              final label = item['label'] as String;
              final icon = item['icon'] as IconData;
              final active = _selected.contains(label);
              return GestureDetector(
                onTap: () => setState(() {
                  active ? _selected.remove(label) : _selected.add(label);
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: active ? AppColors.primary : AppColors.surfaceBorder,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: active
                            ? AppColors.primary.withOpacity(0.2)
                            : Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon,
                          size: 16.w,
                          color: active ? Colors.white : AppColors.primary),
                      SizedBox(width: 6.w),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: active ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 32.h),
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
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text('Save Preferences',
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }
}
