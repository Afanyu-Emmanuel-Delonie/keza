import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import 'trip_builder_model.dart';

class TripBuilderPrefsStep extends StatefulWidget {
  final void Function(TripPrefs) onNext;
  const TripBuilderPrefsStep({super.key, required this.onNext});

  @override
  State<TripBuilderPrefsStep> createState() => _TripBuilderPrefsStepState();
}

class _TripBuilderPrefsStepState extends State<TripBuilderPrefsStep> {
  DateTime? _startDate;
  DateTime? _endDate;
  final _budgetCtrl = TextEditingController();
  int _people = 2;
  final Set<String> _interests = {};
  String? _error;

  static const _interestOptions = [
    ('🦍', 'Wildlife'),
    ('🌿', 'Nature'),
    ('🏛️', 'Culture'),
    ('🧗', 'Adventure'),
    ('🏖️', 'Relaxation'),
  ];

  @override
  void dispose() {
    _budgetCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: AppColors.textHeading,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _error = null;
      });
    }
  }

  void _onNext() {
    // Validate
    if (_startDate == null || _endDate == null) {
      setState(() => _error = 'Please select your travel dates.');
      return;
    }
    final budgetVal = double.tryParse(_budgetCtrl.text.trim());
    if (budgetVal == null || budgetVal <= 0) {
      setState(() => _error = 'Please enter a valid budget amount.');
      return;
    }
    if (_interests.isEmpty) {
      setState(() => _error = 'Please select at least one interest.');
      return;
    }
    setState(() => _error = null);
    widget.onNext(TripPrefs(
      startDate: _startDate!,
      endDate: _endDate!,
      budget: budgetVal,
      people: _people,
      interests: _interests.toList(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero ──
          _HeroBanner(),
          SizedBox(height: 28.h),

          // ── Travel Dates ──
          _Label('Travel Dates'),
          SizedBox(height: 10.h),
          _DateRangeField(
            startDate: _startDate,
            endDate: _endDate,
            onTap: _pickDateRange,
          ),
          SizedBox(height: 22.h),

          // ── Budget ──
          _Label('Total Budget (USD)'),
          SizedBox(height: 4.h),
          Text('Enter your total budget for the entire trip',
              style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
          SizedBox(height: 10.h),
          _BudgetField(controller: _budgetCtrl),
          SizedBox(height: 22.h),

          // ── People ──
          _Label('Number of People'),
          SizedBox(height: 10.h),
          _PeopleCounter(
            value: _people,
            onChanged: (v) => setState(() => _people = v),
          ),
          SizedBox(height: 22.h),

          // ── Interests ──
          _Label('Interests'),
          SizedBox(height: 4.h),
          Text('Pick all that apply — AI will suggest matching places',
              style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _interestOptions.map((t) {
              final active = _interests.contains(t.$2);
              return GestureDetector(
                onTap: () => setState(() {
                  active ? _interests.remove(t.$2) : _interests.add(t.$2);
                  _error = null;
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                        color: active ? AppColors.primary : AppColors.surfaceBorder),
                    boxShadow: active
                        ? [BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2))]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(t.$1, style: TextStyle(fontSize: 16.sp)),
                      SizedBox(width: 7.w),
                      Text(t.$2,
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: active ? Colors.white : AppColors.textPrimary)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 24.h),

          // ── Error ──
          if (_error != null) ...[
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.errorSoft,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: AppColors.error.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline_rounded,
                      size: 16.w, color: AppColors.error),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(_error!,
                        style: TextStyle(
                            fontSize: 12.sp, color: AppColors.error)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
          ],

          // ── Next button ──
          GestureDetector(
            onTap: _onNext,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                gradient: AppColors.aiGradient,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 5)),
                ],
              ),
              alignment: Alignment.center,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome_rounded,
                      color: Colors.amber, size: 18.w),
                  SizedBox(width: 10.w),
                  Text('Find Matching Places',
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero banner ───────────────────────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
              color: AppColors.primaryDarker.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 6)),
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
                  child: Text('AI TRIP BUILDER',
                      style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5)),
                ),
                SizedBox(height: 10.h),
                Text('Plan your perfect\nRwanda trip',
                    style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2)),
                SizedBox(height: 6.h),
                Text('Tell us your dates, budget & interests — AI does the rest.',
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
            child: SvgPicture.asset('assets/general/main-logo.svg',
                width: 60.w,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          ),
        ],
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(text,
      style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textHeading));
}

// ── Date range field ──────────────────────────────────────────────────────────
class _DateRangeField extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final VoidCallback onTap;

  const _DateRangeField(
      {required this.startDate, required this.endDate, required this.onTap});

  String _fmt(DateTime d) =>
      '${d.day} ${_months[d.month - 1]} ${d.year}';

  static const _months = [
    'Jan','Feb','Mar','Apr','May','Jun',
    'Jul','Aug','Sep','Oct','Nov','Dec'
  ];

  @override
  Widget build(BuildContext context) {
    final hasRange = startDate != null && endDate != null;
    final days = hasRange
        ? endDate!.difference(startDate!).inDays
        : 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
              color: hasRange ? AppColors.primary : AppColors.surfaceBorder),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: hasRange ? AppColors.primarySoft : AppColors.surfaceBorder,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.calendar_month_rounded,
                  size: 20.w,
                  color: hasRange ? AppColors.primary : AppColors.textSecondary),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: hasRange
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Departure',
                                      style: TextStyle(
                                          fontSize: 10.sp,
                                          color: AppColors.textSecondary)),
                                  Text(_fmt(startDate!),
                                      style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textHeading)),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_rounded,
                                size: 14.w, color: AppColors.textSecondary),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Return',
                                      style: TextStyle(
                                          fontSize: 10.sp,
                                          color: AppColors.textSecondary)),
                                  Text(_fmt(endDate!),
                                      style: TextStyle(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textHeading)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text('$days ${days == 1 ? 'day' : 'days'}',
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    )
                  : Text('Tap to select travel dates',
                      style: TextStyle(
                          fontSize: 13.sp, color: AppColors.textSecondary)),
            ),
            Icon(Icons.chevron_right_rounded,
                size: 20.w, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}


class _BudgetField extends StatelessWidget {
  final TextEditingController controller;
  const _BudgetField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Matching background, border, and shadows exactly with travel/people fields
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.surfaceBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ],
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textHeading,
        ),
        decoration: InputDecoration(
          hintText: '0.00',
          hintStyle: TextStyle(
            fontSize: 16.sp,
            color: AppColors.textDisabled,
            fontWeight: FontWeight.w400,
          ),

          // Using InputBorder.none to let the outer Container handle the structural framing
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 14.h),

          // ── Prefix Container ($) ──
          prefixIcon: Container(
            margin: EdgeInsets.only(right: 14.w),
            width: 52.w,
            height: 52.h,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(13.r), // Curves inside the container frame cleanly
                bottomLeft: Radius.circular(13.r),
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '\$',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.primary,
              ),
            ),
          ),
          prefixIconConstraints: BoxConstraints(
            minWidth: 52.w,
            minHeight: 52.h,
          ),

          // ── Suffix Content (USD) ──
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 16.w), // Matches the 16.w horizontal frame paddings
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'USD',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          suffixIconConstraints: BoxConstraints(
            minWidth: 40.w,
          ),
        ),
      ),
    );
  }
}
// ── People counter ────────────────────────────────────────────────────────────
class _PeopleCounter extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;
  const _PeopleCounter({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.people_rounded, size: 20.w, color: AppColors.primary),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
                '$value ${value == 1 ? 'person' : 'people'}',
                style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textHeading)),
          ),
          _Btn(
            icon: Icons.remove_rounded,
            onTap: value > 1 ? () => onChanged(value - 1) : null,
          ),
          SizedBox(width: 20.w),
          _Btn(
            icon: Icons.add_rounded,
            onTap: value < 20 ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _Btn extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  const _Btn({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final on = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
          color: on ? AppColors.primarySoft : AppColors.surfaceBorder,
          shape: BoxShape.circle,
        ),
        child: Icon(icon,
            size: 18.w,
            color: on ? AppColors.primary : AppColors.textDisabled),
      ),
    );
  }
}
