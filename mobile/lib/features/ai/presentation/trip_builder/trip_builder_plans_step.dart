import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import 'trip_builder_model.dart';

class TripBuilderPlansStep extends StatelessWidget {
  final List<TripPlan> plans;
  final TripPrefs prefs;
  final void Function(TripPlan) onSelect;

  const TripBuilderPlansStep({
    super.key,
    required this.plans,
    required this.prefs,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      children: [
        // Header
        Text('3 plans generated for you',
            style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textHeading)),
        SizedBox(height: 4.h),
        Text(
            '${prefs.days} days · ${prefs.people} ${prefs.people == 1 ? 'person' : 'people'} · \$${prefs.budget.toStringAsFixed(0)} budget',
            style:
                TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
        SizedBox(height: 20.h),

        ...plans.map((plan) => _PlanCard(plan: plan, onSelect: onSelect)),
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  final TripPlan plan;
  final void Function(TripPlan) onSelect;
  const _PlanCard({required this.plan, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    const planColor = AppColors.primary;

    return GestureDetector(
      onTap: () => onSelect(plan),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 14,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coloured header
            Container(
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: planColor,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44.w,
                    height: 44.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(Icons.route_rounded, color: Colors.white, size: 22.w),
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('AI GENERATED PLAN',
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: Colors.white.withOpacity(0.7),
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1)),
                        Text('${plan.days.length}-Day Itinerary',
                            style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w800,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                        '\$${plan.estimatedCost.toStringAsFixed(0)}',
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white)),
                  ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.days.map((d) => d.province).toSet().join(' → '),
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary)),
                  SizedBox(height: 12.h),

                  // Highlights
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: plan.highlights.map((h) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(h,
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.primaryDark,
                                fontWeight: FontWeight.w600)),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 14.h),

                  // Select button
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 13.h),
                    decoration: BoxDecoration(
                      color: planColor,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('View Full Itinerary',
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        SizedBox(width: 8.w),
                        Icon(Icons.arrow_forward_rounded,
                            color: Colors.white, size: 16.w),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
