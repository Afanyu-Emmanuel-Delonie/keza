import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import 'trip_builder_model.dart';

class TripBuilderItineraryStep extends StatefulWidget {
  final TripPlan plan;
  final void Function(TripPlan) onCheckout;

  const TripBuilderItineraryStep({
    super.key,
    required this.plan,
    required this.onCheckout,
  });

  @override
  State<TripBuilderItineraryStep> createState() =>
      _TripBuilderItineraryStepState();
}

class _TripBuilderItineraryStepState extends State<TripBuilderItineraryStep> {
  late TripPlan _plan;

  @override
  void initState() {
    super.initState();
    _plan = widget.plan;
  }

  void _removeStop(int dayIndex, String stopId) {
    final days = List<ItineraryDay>.from(_plan.days);
    final day = days[dayIndex];
    final newStops =
        day.stops.where((s) => s.id != stopId).toList();
    days[dayIndex] = day.copyWith(stops: newStops);

    // Recalculate cost
    double newCost = 0;
    for (final d in days) {
      for (final s in d.stops) {
        if (s.costPerPerson != null) {
          newCost += s.type == 'stay'
              ? s.costPerPerson! // per room
              : s.costPerPerson! * _plan.prefs.people;
        }
      }
    }
    setState(() => _plan = _plan.copyWith(days: days, estimatedCost: newCost));
  }

  @override
  Widget build(BuildContext context) {
    final overBudget = _plan.isOverBudget;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
            children: [
              // ── Budget status banner ──
              _BudgetBanner(plan: _plan),
              SizedBox(height: 16.h),

              // ── Accommodation note ──
              if (_plan.accommodationNote != null) ...[
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.hotel_rounded,
                          size: 16.w, color: AppColors.primary),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(_plan.accommodationNote!,
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.primaryDark,
                                height: 1.4)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
              ],

              // ── Customise hint ──
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.infoSoft,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.edit_note_rounded,
                        size: 16.w, color: AppColors.info),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                          'Swipe left on any stop to remove it from your plan.',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.info,
                              height: 1.4)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // ── Day cards ──
              ..._plan.days.asMap().entries.map(
                    (e) => _DayCard(
                      dayIndex: e.key,
                      day: e.value,
                      onRemoveStop: _removeStop,
                    ),
                  ),
            ],
          ),
        ),

        // ── Bottom checkout bar ──
        Container(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w,
              MediaQuery.of(context).padding.bottom + 12.h),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.surfaceBorder)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (overBudget) ...[
                Container(
                  padding: EdgeInsets.all(10.w),
                  margin: EdgeInsets.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.errorSoft,
                    borderRadius: BorderRadius.circular(10.r),
                    border:
                        Border.all(color: AppColors.error.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          size: 16.w, color: AppColors.error),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          'Over budget by \$${_plan.overBy.toStringAsFixed(0)}. '
                          'Remove some stops or increase your budget.',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: AppColors.error,
                              height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              Row(
                children: [
                  // Cost summary
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Estimated Total',
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textSecondary)),
                      Text(
                        '\$${_plan.estimatedCost.toStringAsFixed(0)}',
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                            color: overBudget
                                ? AppColors.error
                                : AppColors.primary),
                      ),
                    ],
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => widget.onCheckout(_plan),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        decoration: BoxDecoration(
                          gradient: AppColors.aiGradient,
                          borderRadius: BorderRadius.circular(14.r),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.primary.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4)),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.shopping_bag_rounded,
                                color: Colors.amber, size: 16.w),
                            SizedBox(width: 8.w),
                            Text('Proceed to Checkout',
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Budget banner ─────────────────────────────────────────────────────────────
class _BudgetBanner extends StatelessWidget {
  final TripPlan plan;
  const _BudgetBanner({required this.plan});

  @override
  Widget build(BuildContext context) {
    final over = plan.isOverBudget;
    final pct = (plan.estimatedCost / plan.prefs.budget * 100).clamp(0, 200);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: over ? AppColors.errorSoft : AppColors.primarySoft,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
            color: over
                ? AppColors.error.withOpacity(0.3)
                : AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                over
                    ? Icons.warning_amber_rounded
                    : Icons.check_circle_rounded,
                size: 18.w,
                color: over ? AppColors.error : AppColors.primary,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  over
                      ? 'Over budget by \$${plan.overBy.toStringAsFixed(0)}'
                      : 'Within budget ✓',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: over ? AppColors.error : AppColors.primary),
                ),
              ),
              Text(
                '\$${plan.estimatedCost.toStringAsFixed(0)} / \$${plan.prefs.budget.toStringAsFixed(0)}',
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: over ? AppColors.error : AppColors.primaryDark),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: (pct / 100).clamp(0.0, 1.0),
              minHeight: 6.h,
              backgroundColor: over
                  ? AppColors.error.withOpacity(0.15)
                  : AppColors.primary.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation(
                  over ? AppColors.error : AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Day card ──────────────────────────────────────────────────────────────────
class _DayCard extends StatefulWidget {
  final int dayIndex;
  final ItineraryDay day;
  final void Function(int dayIndex, String stopId) onRemoveStop;

  const _DayCard({
    required this.dayIndex,
    required this.day,
    required this.onRemoveStop,
  });

  @override
  State<_DayCard> createState() => _DayCardState();
}

class _DayCardState extends State<_DayCard> {
  bool _expanded = true;

  String _fmt(DateTime d) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${d.day} ${m[d.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
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
        children: [
          // Header
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.all(14.w),
              child: Row(
                children: [
                  Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    alignment: Alignment.center,
                    child: Text('D${widget.day.day}',
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary)),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.day.title,
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textHeading)),
                        Row(
                          children: [
                            Text(widget.day.province,
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppColors.textSecondary)),
                            Text('  ·  ${_fmt(widget.day.date)}',
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    size: 20.w,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),

          // Stops
          if (_expanded)
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 14.h),
              child: Column(
                children: widget.day.stops
                    .asMap()
                    .entries
                    .map((e) => _StopRow(
                          stop: e.value,
                          isLast: e.key == widget.day.stops.length - 1,
                          onRemove: e.value.type != 'transport'
                              ? () => widget.onRemoveStop(
                                  widget.dayIndex, e.value.id)
                              : null,
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Stop row with swipe-to-remove ─────────────────────────────────────────────
class _StopRow extends StatelessWidget {
  final TripStop stop;
  final bool isLast;
  final VoidCallback? onRemove;

  const _StopRow(
      {required this.stop, required this.isLast, this.onRemove});

  Color get _color {
    switch (stop.type) {
      case 'stay':
        return AppColors.primary;
      case 'transport':
        return AppColors.textSecondary;
      default:
        return AppColors.info;
    }
  }

  IconData get _icon {
    switch (stop.type) {
      case 'stay':
        return Icons.hotel_rounded;
      case 'transport':
        return Icons.directions_car_rounded;
      default:
        return Icons.place_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final row = IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline
          Column(
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: _color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(_icon, size: 14.w, color: _color),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: AppColors.surfaceBorder,
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12.w),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 14.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stop.name,
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textHeading)),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 10.w,
                                color: AppColors.textSecondary),
                            SizedBox(width: 2.w),
                            Flexible(
                              child: Text(stop.location,
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      color: AppColors.textSecondary)),
                            ),
                            if (stop.costPerPerson != null &&
                                stop.costPerPerson! > 0) ...[
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySoft,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(stop.priceLabel,
                                    style: TextStyle(
                                        fontSize: 10.sp,
                                        color: AppColors.primaryDark,
                                        fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ],
                        ),
                        if (stop.note != null) ...[
                          SizedBox(height: 4.h),
                          Text(stop.note!,
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.textSecondary,
                                  height: 1.4,
                                  fontStyle: FontStyle.italic)),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Thumbnail
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: CachedNetworkImage(
                      imageUrl: stop.image,
                      width: 50.w,
                      height: 50.w,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: AppColors.shimmerBase),
                      errorWidget: (_, __, ___) =>
                          Container(color: AppColors.shimmerBase),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (onRemove == null) return row;

    return Dismissible(
      key: Key(stop.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 12.w, bottom: isLast ? 0 : 14.h),
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.errorSoft,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(Icons.delete_outline_rounded,
              size: 18.w, color: AppColors.error),
        ),
      ),
      onDismissed: (_) => onRemove!(),
      child: row,
    );
  }
}
