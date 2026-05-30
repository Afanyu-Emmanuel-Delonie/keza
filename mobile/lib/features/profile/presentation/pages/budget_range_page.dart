import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import 'profile_page_scaffold.dart';

class BudgetRangePage extends StatefulWidget {
  const BudgetRangePage({super.key});

  @override
  State<BudgetRangePage> createState() => _BudgetRangePageState();
}

class _BudgetRangePageState extends State<BudgetRangePage> {
  RangeValues _range = const RangeValues(100, 500);

  final _presets = [
    {'label': 'Budget', 'sub': 'Under \$100/day', 'min': 0.0, 'max': 100.0},
    {'label': 'Mid-range', 'sub': '\$100 – \$500/day', 'min': 100.0, 'max': 500.0},
    {'label': 'Luxury', 'sub': '\$500 – \$1000/day', 'min': 500.0, 'max': 1000.0},
    {'label': 'Ultra Luxury', 'sub': 'Above \$1000/day', 'min': 1000.0, 'max': 2000.0},
  ];

  String? _selectedPreset = 'Mid-range';

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Budget Range',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Set your daily travel budget to get personalised recommendations.',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary, height: 1.5),
          ),
          SizedBox(height: 24.h),

          // Preset cards
          ...(_presets.map((p) {
            final active = _selectedPreset == p['label'];
            return GestureDetector(
              onTap: () => setState(() {
                _selectedPreset = p['label'] as String;
                _range = RangeValues(p['min'] as double, p['max'] as double);
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(bottom: 10.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: active ? AppColors.primarySoft : Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: active ? AppColors.primary : AppColors.surfaceBorder,
                    width: active ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 36.w,
                      height: 36.w,
                      decoration: BoxDecoration(
                        color: active ? AppColors.primary : AppColors.surfaceRaised,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.attach_money_rounded,
                          size: 18.w,
                          color: active ? Colors.white : AppColors.textSecondary),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(p['label'] as String,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: active
                                      ? AppColors.primaryDark
                                      : AppColors.textHeading)),
                          Text(p['sub'] as String,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    if (active)
                      Icon(Icons.check_circle_rounded,
                          color: AppColors.primary, size: 20.w),
                  ],
                ),
              ),
            );
          })),

          SizedBox(height: 24.h),
          Text('Custom Range',
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary)),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _RangeChip(label: '\$${_range.start.toInt()}'),
              _RangeChip(label: '\$${_range.end.toInt()}'),
            ],
          ),
          RangeSlider(
            values: _range,
            min: 0,
            max: 2000,
            divisions: 40,
            activeColor: AppColors.primary,
            inactiveColor: AppColors.surfaceBorder,
            onChanged: (v) => setState(() {
              _range = v;
              _selectedPreset = null;
            }),
          ),
          SizedBox(height: 32.h),
          _SaveButton(onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}

class _RangeChip extends StatelessWidget {
  final String label;
  const _RangeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark)),
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
