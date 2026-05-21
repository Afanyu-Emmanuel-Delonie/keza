import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import 'trip_builder_model.dart';

class TripBuilderCheckoutStep extends StatelessWidget {
  final TripPlan plan;
  final VoidCallback onConfirm;

  const TripBuilderCheckoutStep({
    super.key,
    required this.plan,
    required this.onConfirm,
  });

  String _fmt(DateTime d) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${d.day} ${m[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final prefs = plan.prefs;
    final overBudget = plan.isOverBudget;

    // Collect all priced stops
    final stays = plan.days
        .expand((d) => d.stops)
        .where((s) => s.type == 'stay' && s.costPerPerson != null)
        .toList();
    final activities = plan.days
        .expand((d) => d.stops)
        .where((s) => s.type == 'destination' && s.costPerPerson != null && s.costPerPerson! > 0)
        .toList();

    final stayTotal = stays.fold(0.0, (sum, s) => sum + s.costPerPerson!);
    final actTotal = activities.fold(
        0.0, (sum, s) => sum + s.costPerPerson! * prefs.people);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
            children: [
              // ── Budget feasibility banner ──
              if (overBudget) ...[
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.errorSoft,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                        color: AppColors.error.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              size: 20.w, color: AppColors.error),
                          SizedBox(width: 8.w),
                          Text('Budget Exceeded',
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.error)),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Your estimated trip cost (\$${plan.estimatedCost.toStringAsFixed(0)}) '
                        'exceeds your budget (\$${prefs.budget.toStringAsFixed(0)}) '
                        'by \$${plan.overBy.toStringAsFixed(0)}.\n\n'
                        'You can still proceed, go back to remove stops, or adjust your budget.',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.error,
                            height: 1.5),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
              ],

              // ── Trip summary ──
              _Card(
                title: 'Trip Summary',
                child: Column(
                  children: [
                    _Row('Dates',
                        '${_fmt(prefs.startDate)} → ${_fmt(prefs.endDate)}'),
                    _Row('Duration', '${prefs.days} days'),
                    _Row('Travellers',
                        '${prefs.people} ${prefs.people == 1 ? 'person' : 'people'}'),
                    _Row('Interests', prefs.interests.join(', ')),
                  ],
                ),
              ),
              SizedBox(height: 14.h),

              // ── Accommodation breakdown ──
              if (stays.isNotEmpty) ...[
                _Card(
                  title: 'Accommodation (AI Booked)',
                  child: Column(
                    children: [
                      ...stays.map((s) => _Row(s.name,
                          '\$${s.costPerPerson!.toStringAsFixed(0)}/night')),
                      _Divider(),
                      _Row('Accommodation Total',
                          '\$${stayTotal.toStringAsFixed(0)}',
                          bold: true),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
              ],

              // ── Activities breakdown ──
              if (activities.isNotEmpty) ...[
                _Card(
                  title: 'Activities & Entry Fees',
                  child: Column(
                    children: [
                      ...activities.map((s) => _Row(
                            s.name,
                            '\$${(s.costPerPerson! * prefs.people).toStringAsFixed(0)} (${prefs.people}x)',
                          )),
                      _Divider(),
                      _Row('Activities Total',
                          '\$${actTotal.toStringAsFixed(0)}',
                          bold: true),
                    ],
                  ),
                ),
                SizedBox(height: 14.h),
              ],

              // ── Total ──
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: overBudget ? AppColors.errorSoft : AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                      color: overBudget
                          ? AppColors.error.withOpacity(0.3)
                          : AppColors.primary.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estimated Total',
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: overBudget
                                    ? AppColors.error
                                    : AppColors.primaryDark)),
                        Text(
                          '\$${plan.estimatedCost.toStringAsFixed(0)}',
                          style: TextStyle(
                              fontSize: 24.sp,
                              fontWeight: FontWeight.w800,
                              color: overBudget
                                  ? AppColors.error
                                  : AppColors.primary),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Your Budget',
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary)),
                        Text(
                          '\$${prefs.budget.toStringAsFixed(0)}',
                          style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textHeading),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 14.h),

              // ── Highlights ──
              if (plan.highlights.isNotEmpty) ...[
                _Card(
                  title: 'Highlights Included',
                  child: Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: plan.highlights.map((h) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle_rounded,
                                size: 12.w, color: AppColors.primary),
                            SizedBox(width: 5.w),
                            Text(h,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.primaryDark,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 14.h),
              ],

              // ── Disclaimer ──
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: AppColors.warningSoft,
                  borderRadius: BorderRadius.circular(12.r),
                  border:
                      Border.all(color: AppColors.warning.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 15.w, color: AppColors.warning),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        'Prices are estimates. Gorilla permits (\$1,500) must be booked directly with Rwanda Development Board. '
                        'Accommodation is subject to availability.',
                        style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.warning,
                            height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Confirm button ──
        Container(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w,
              MediaQuery.of(context).padding.bottom + 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.surfaceBorder)),
          ),
          child: GestureDetector(
            onTap: onConfirm,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                gradient: overBudget
                    ? const LinearGradient(
                        colors: [Color(0xFF8B0000), Color(0xFFD93025)])
                    : AppColors.aiGradient,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                      color: (overBudget ? AppColors.error : AppColors.primary)
                          .withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 5)),
                ],
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    overBudget
                        ? Icons.warning_amber_rounded
                        : Icons.bookmark_add_rounded,
                    color: Colors.amber,
                    size: 18.w,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    overBudget
                        ? 'Book Anyway (Over Budget)'
                        : 'Confirm & Book Trip',
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────
class _Card extends StatelessWidget {
  final String title;
  final Widget child;
  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textHeading)),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _Row(this.label, this.value, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13.sp, color: AppColors.textSecondary)),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight:
                        bold ? FontWeight.w700 : FontWeight.w600,
                    color: bold
                        ? AppColors.textHeading
                        : AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Divider(color: AppColors.surfaceBorder, height: 1),
      );
}
