import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/theme/app_colors.dart';
import 'trip_builder_model.dart';

class TripBuilderPlacesStep extends StatefulWidget {
  final TripPrefs prefs;
  final List<ProposedPlace> places;
  final void Function(List<ProposedPlace>) onNext;

  const TripBuilderPlacesStep({
    super.key,
    required this.prefs,
    required this.places,
    required this.onNext,
  });

  @override
  State<TripBuilderPlacesStep> createState() => _TripBuilderPlacesStepState();
}

class _TripBuilderPlacesStepState extends State<TripBuilderPlacesStep> {
  final Set<String> _selected = {};
  String? _error;

  void _toggle(String id) => setState(() {
        _selected.contains(id) ? _selected.remove(id) : _selected.add(id);
        _error = null;
      });

  void _onNext() {
    if (_selected.isEmpty) {
      setState(() => _error = 'Please select at least one place to visit.');
      return;
    }
    final picked = widget.places.where((p) => _selected.contains(p.id)).toList();
    widget.onNext(picked);
  }

  String _fmt(DateTime d) {
    const m = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${d.day} ${m[d.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Header ──
        Container(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 14.h),
          color: AppColors.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Suggested Places',
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textHeading)),
              SizedBox(height: 4.h),
              Text(
                '${_fmt(widget.prefs.startDate)} → ${_fmt(widget.prefs.endDate)}  ·  '
                '${widget.prefs.days} days  ·  ${widget.prefs.people} ${widget.prefs.people == 1 ? 'person' : 'people'}  ·  '
                '\$${widget.prefs.budget.toStringAsFixed(0)} budget',
                style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
              ),
              SizedBox(height: 10.h),
              // Budget per person hint
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: AppColors.infoSoft,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 14.w,
                      color: AppColors.info,
                    ),
                    SizedBox(width: 6.w),
                    Expanded(
                      child: Text(
                        'Select the places you want to visit. AI will auto-book accommodation.',
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.info,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),

        // ── Places list ──
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
            itemCount: widget.places.length,
            itemBuilder: (_, i) => _PlaceCard(
              place: widget.places[i],
              selected: _selected.contains(widget.places[i].id),
              onTap: () => _toggle(widget.places[i].id),
            ),
          ),
        ),

        // ── Bottom bar ──
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
              if (_error != null) ...[
                Container(
                  padding: EdgeInsets.all(10.w),
                  margin: EdgeInsets.only(bottom: 10.h),
                  decoration: BoxDecoration(
                    color: AppColors.errorSoft,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline_rounded,
                          size: 14.w, color: AppColors.error),
                      SizedBox(width: 6.w),
                      Text(_error!,
                          style: TextStyle(
                              fontSize: 12.sp, color: AppColors.error)),
                    ],
                  ),
                ),
              ],
              Row(
                children: [
                  // Selected count badge
                  if (_selected.isNotEmpty)
                    Container(
                      margin: EdgeInsets.only(right: 12.w),
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        '${_selected.length} selected',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  Expanded(
                    child: GestureDetector(
                      onTap: _onNext,
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
                            Icon(Icons.auto_awesome_rounded,
                                color: Colors.amber, size: 16.w),
                            SizedBox(width: 8.w),
                            Text('Generate My Plan',
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

// ── Place card ────────────────────────────────────────────────────────────────
class _PlaceCard extends StatelessWidget {
  final ProposedPlace place;
  final bool selected;
  final VoidCallback onTap;

  const _PlaceCard(
      {required this.place, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
                color: selected
                    ? AppColors.primary.withOpacity(0.12)
                    : Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14.r),
                bottomLeft: Radius.circular(14.r),
              ),
              child: CachedNetworkImage(
                imageUrl: place.image,
                width: 90.w,
                height: 90.w,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: AppColors.shimmerBase),
                errorWidget: (_, __, ___) =>
                    Container(color: AppColors.shimmerBase),
              ),
            ),
            // Content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(place.name,
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textHeading)),
                        ),
                        // Category chip
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 7.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(place.category,
                              style: TextStyle(
                                  fontSize: 9.sp,
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 11.w, color: AppColors.textSecondary),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(place.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 11.sp,
                                  color: AppColors.textSecondary)),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Text(place.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textSecondary,
                            height: 1.4)),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            size: 11.w, color: AppColors.textSecondary),
                        SizedBox(width: 3.w),
                        Text(place.duration,
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.textSecondary)),
                        const Spacer(),
                        Text(
                          place.entryFee == 0
                              ? 'Free'
                              : '\$${place.entryFee.toStringAsFixed(0)}/person',
                          style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: place.entryFee == 0
                                  ? AppColors.success
                                  : AppColors.primary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Checkbox
            Padding(
              padding: EdgeInsets.only(right: 12.w),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : AppColors.surfaceBorder,
                    width: 2,
                  ),
                ),
                child: selected
                    ? Icon(Icons.check_rounded,
                        size: 14.w, color: Colors.white)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
