import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import 'ai_result_model.dart';
import 'ai_result_card.dart';

class AiResultsState extends StatefulWidget {
  final String summary;
  final List<AiResult> destinations;

  const AiResultsState({
    super.key,
    required this.summary,
    required this.destinations,
  });

  @override
  State<AiResultsState> createState() => _AiResultsStateState();
}

class _AiResultsStateState extends State<AiResultsState> {
  // null = not asked yet, false = declined, true = showing
  bool? _showAccommodation;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
      children: [
        // ── AI summary row ──
        _AiSummaryRow(summary: widget.summary),
        SizedBox(height: 16.h),

        // ── Destination results ──
        ...widget.destinations.map((d) => AiResultCard(result: d)),

        // ── Accommodation CTA ──
        if (_showAccommodation == null) ...[
          SizedBox(height: 8.h),
          _AccommodationCtaBanner(
            onYes: () => setState(() => _showAccommodation = true),
            onNo: () => setState(() => _showAccommodation = false),
          ),
        ],

        // ── Accommodation results ──
        if (_showAccommodation == true) ...[
          SizedBox(height: 8.h),
          _AccommodationHeader(),
          SizedBox(height: 12.h),
          ...kAccommodationResults.map((a) => AiResultCard(result: a)),
        ],

        // ── Declined message ──
        if (_showAccommodation == false) ...[
          SizedBox(height: 8.h),
          _DeclinedBanner(
            onUndo: () => setState(() => _showAccommodation = null),
          ),
        ],
      ],
    );
  }
}

// ── AI summary row ────────────────────────────────────────────────────────────
class _AiSummaryRow extends StatelessWidget {
  final String summary;
  const _AiSummaryRow({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30.w,
          height: 30.w,
          decoration: const BoxDecoration(
            gradient: AppColors.aiGradient,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: SvgPicture.asset(
              'assets/general/main-logo.svg',
              width: 15.w,
              colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(14.r),
                bottomLeft: Radius.circular(14.r),
                bottomRight: Radius.circular(14.r),
              ),
            ),
            child: Text(
              summary,
              style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.primaryDark,
                  height: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Accommodation CTA banner ──────────────────────────────────────────────────
class _AccommodationCtaBanner extends StatelessWidget {
  final VoidCallback onYes;
  final VoidCallback onNo;
  const _AccommodationCtaBanner({required this.onYes, required this.onNo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.surfaceBorder),
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
          Row(
            children: [
              Container(
                width: 30.w,
                height: 30.w,
                decoration: const BoxDecoration(
                  gradient: AppColors.aiGradient,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.hotel_rounded, color: Colors.white, size: 15.w),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Text(
                  'Would you like to see accommodation options for these destinations?',
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textPrimary,
                      height: 1.4,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onYes,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 11.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10.r),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 3)),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_rounded, color: Colors.white, size: 15.w),
                        SizedBox(width: 6.w),
                        Text('Yes, show stays',
                            style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: GestureDetector(
                  onTap: onNo,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 11.h),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.surfaceBorder),
                    ),
                    alignment: Alignment.center,
                    child: Text('No thanks',
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Accommodation section header ──────────────────────────────────────────────
class _AccommodationHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30.w,
          height: 30.w,
          decoration: const BoxDecoration(
            gradient: AppColors.aiGradient,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.hotel_rounded, color: Colors.white, size: 15.w),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(14.r),
                bottomLeft: Radius.circular(14.r),
                bottomRight: Radius.circular(14.r),
              ),
            ),
            child: Text(
              'Here are the best stays near your selected destinations.',
              style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.primaryDark,
                  height: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Declined banner ───────────────────────────────────────────────────────────
class _DeclinedBanner extends StatelessWidget {
  final VoidCallback onUndo;
  const _DeclinedBanner({required this.onUndo});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded,
              size: 16.w, color: AppColors.textSecondary),
          SizedBox(width: 8.w),
          Expanded(
            child: Text('No problem! You can always add stays later.',
                style: TextStyle(
                    fontSize: 12.sp, color: AppColors.textSecondary)),
          ),
          GestureDetector(
            onTap: onUndo,
            child: Text('Show anyway',
                style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
