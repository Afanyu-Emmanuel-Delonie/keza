import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/trip_snackbar.dart';
import '../../../trips/providers/trips_provider.dart';
import '../../../trips/presentation/booking_form_sheet.dart';
import 'ai_result_model.dart';

class AiResultCard extends StatelessWidget {
  final AiResult result;
  const AiResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Consumer<TripsProvider>(
      builder: (context, provider, _) {
        final item = result.toTripItem();
        final isAccom = result.type == ResultType.accommodation;
        final booked = isAccom && provider.isAccommodationSelected(item.id);
        final added = !isAccom && provider.isAdded(item.id);

        return Container(
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 14,
                  offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image ──
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: result.image,
                      height: 170.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(height: 170.h, color: AppColors.shimmerBase),
                      errorWidget: (_, __, ___) =>
                          Container(height: 170.h, color: AppColors.shimmerBase),
                    ),
                    // type badge
                    Positioned(
                      top: 12.h,
                      left: 12.w,
                      child: _Pill(
                        icon: isAccom ? Icons.hotel_rounded : Icons.explore_rounded,
                        label: isAccom ? 'Stay' : 'Destination',
                        dark: true,
                      ),
                    ),
                    // AI tag
                    if (result.tag != null)
                      Positioned(
                        top: 12.h,
                        right: 12.w,
                        child: _Pill(
                          icon: Icons.auto_awesome_rounded,
                          label: result.tag!,
                          gradient: AppColors.aiGradient,
                        ),
                      ),
                  ],
                ),
              ),

              // ── Body ──
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(result.name,
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textHeading)),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 12.w, color: AppColors.textSecondary),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(result.location,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary)),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: Colors.amber, size: 14.w),
                        SizedBox(width: 3.w),
                        Text(result.rating,
                            style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textHeading)),
                        SizedBox(width: 4.w),
                        Text('(${result.reviews})',
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.textSecondary)),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(result.price,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary)),
                            Text(result.priceLabel,
                                style: TextStyle(
                                    fontSize: 10.sp,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    // ── CTA button ──
                    GestureDetector(
                      onTap: () => _onTap(context, provider, item, booked, added),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 13.h),
                        decoration: BoxDecoration(
                          color: (booked || added)
                              ? AppColors.errorSoft
                              : AppColors.primary,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: (booked || added)
                              ? null
                              : [
                                  BoxShadow(
                                      color: AppColors.primary.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3))
                                ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              (booked || added)
                                  ? Icons.close_rounded
                                  : Icons.check_rounded,
                              color: (booked || added)
                                  ? AppColors.error
                                  : Colors.white,
                              size: 16.w,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              _btnLabel(isAccom, booked, added),
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: (booked || added)
                                      ? AppColors.error
                                      : Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _btnLabel(bool isAccom, bool booked, bool added) {
    if (isAccom) return booked ? 'Cancel Booking' : 'Book This Stay';
    return added ? 'Remove from Trip' : 'Add to Trip';
  }

  Future<void> _onTap(BuildContext context, TripsProvider provider,
      tripItem, bool booked, bool added) async {
    final isAccom = result.type == ResultType.accommodation;
    if (isAccom) {
      if (booked) {
        provider.cancelAccommodationBooking(tripItem.province);
      } else {
        final booking = await BookingFormSheet.show(context, tripItem);
        if (booking != null) {
          provider.confirmAccommodationBooking(booking);
          if (context.mounted) {
            showTopSnackbar(context, '${result.name} booked!',
                icon: Icons.hotel_rounded);
          }
        }
      }
    } else {
      if (added) {
        provider.removeFromTrip(tripItem.id);
      } else {
        provider.toggleAddTrip(tripItem);
        if (context.mounted) {
          showAddedToTripSnackbar(context, result.name);
        }
      }
    }
  }
}

// ── Pill badge ────────────────────────────────────────────────────────────────
class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool dark;
  final Gradient? gradient;

  const _Pill({
    required this.icon,
    required this.label,
    this.dark = false,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: dark ? Colors.black.withOpacity(0.5) : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.w, color: Colors.white),
          SizedBox(width: 4.w),
          Text(label,
              style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
