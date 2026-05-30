import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/destination_details_model.dart';

class DestinationBookingBox extends StatelessWidget {
  final List<AvailableSpot> spots;
  final VoidCallback onSeeAll;

  const DestinationBookingBox({
    super.key,
    required this.spots,
    required this.onSeeAll,
  });

  // Group spots by date (year+month+day key)
  Map<String, List<AvailableSpot>> _groupByDay() {
    final map = <String, List<AvailableSpot>>{};
    for (final s in spots) {
      final key = '${s.date.year}-${s.date.month}-${s.date.day}';
      (map[key] ??= []).add(s);
    }
    return map;
  }

  String _getTomorrowsDate(){
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    return 'Tomorrow - ${months[tomorrow.month - 1]} ${tomorrow.day}';
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByDay();
    // Show only first 3 spots as preview
    final preview = spots.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header ──
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reserve a Spot',
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textHeading,
                letterSpacing: -0.2,
              ),
            ),

            Text(
              _getTomorrowsDate()
            )
          ],
        ),
        SizedBox(height: 14.h),


        ...preview.map((spot) {
          final key = '${spot.date.year}-${spot.date.month}-${spot.date.day}';
          final slotsOnDay = grouped[key]?.length ?? 1;
          return _SpotCard(spot: spot, totalSlotsOnDay: slotsOnDay);
        }),

        SizedBox(height: 10.h),


        GestureDetector(
          onTap: onSeeAll,
          child: Container(
            height: 40.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(100.r),
              border: Border.all(color: AppColors.textHeading, width: 1),
            ),
            alignment: Alignment.center,
            child:Text(
              'See all Dates',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textHeading,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Spot card ─────────────────────────────────────────────────────────────────
class _SpotCard extends StatelessWidget {
  final AvailableSpot spot;
  final int totalSlotsOnDay;

  const _SpotCard({required this.spot, required this.totalSlotsOnDay});

  String _fmtDate(DateTime d) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[d.weekday - 1]}, ${d.day} ${months[d.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final isLow = spot.spotsLeft <= 3;

    return Container(
      width: 320,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top row: date + badges ──
          Text(
            'All Inclusive safari tour with boats included',
            softWrap: true,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textHeading,
            ),
          ),

          SizedBox(height: 10.h),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Time
              Icon(Icons.access_time_rounded,
                  size: 16.w, color: AppColors.textSecondary),
              SizedBox(width: 4.w),
              Text(
                '2 time slots available',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),


          SizedBox(height: 35.h,),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$120',
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textHeading,
                ),
              ),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: isLow ? AppColors.error : AppColors.primary,
                  borderRadius: BorderRadius.circular(100.r),
                ),
                child: Text(
                  'Check Availability',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              )
            ]
          )
        ],
      ),
    );
  }
}
