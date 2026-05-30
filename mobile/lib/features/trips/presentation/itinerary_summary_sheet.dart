import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/trips_provider.dart';

class ItinerarySummarySheet extends StatelessWidget {
  final List<TripItem> destinations;
  final Map<String, AccommodationBooking> bookings;
  final double totalCost;
  final VoidCallback onConfirm;
  final double serviceFee;
  final double grandTotal;
  final bool airportPickup;
  final bool tourGuide;
  final PaymentMethod paymentMethod;

  const ItinerarySummarySheet({
    super.key,
    required this.destinations,
    required this.bookings,
    required this.totalCost,
    required this.onConfirm,
    this.serviceFee = 0,
    this.grandTotal = 0,
    this.airportPickup = false,
    this.tourGuide = false,
    this.paymentMethod = PaymentMethod.payNow,
  });

  static Future<bool?> show(
    BuildContext context, {
    required List<TripItem> destinations,
    required Map<String, AccommodationBooking> bookings,
    required double totalCost,
    required VoidCallback onConfirm,
    double serviceFee = 0,
    double grandTotal = 0,
    bool airportPickup = false,
    bool tourGuide = false,
    PaymentMethod paymentMethod = PaymentMethod.payNow,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ItinerarySummarySheet(
        destinations: destinations,
        bookings: bookings,
        totalCost: totalCost,
        onConfirm: onConfirm,
        serviceFee: serviceFee,
        grandTotal: grandTotal,
        airportPickup: airportPickup,
        tourGuide: tourGuide,
        paymentMethod: paymentMethod,
      ),
    );
  }

  String _fmt(DateTime d) {
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${m[d.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final byProvince = <String, List<TripItem>>{};
    for (final d in destinations) {
      byProvince.putIfAbsent(d.province, () => []).add(d);
    }
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return DraggableScrollableSheet(
      initialChildSize: 0.88,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceRaised,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            children: [
              // ── Handle + header (pinned) ──
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 12.h),
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBorder,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    Text('Your Itinerary',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textHeading,
                            letterSpacing: -0.3)),
                    SizedBox(height: 4.h),
                    Text('Review before booking',
                        style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),

              // ── Scrollable body ──
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 20.h),
                  children: [
                    // Province cards
                    ...byProvince.entries.map((entry) {
                      final province = entry.key;
                      final places = entry.value;
                      final booking = bookings[province];

                      return Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3)),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Province header
                            Padding(
                              padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 8.h),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(5.w),
                                    decoration: BoxDecoration(
                                      color: AppColors.primarySoft,
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                    child: Icon(Icons.location_on_rounded,
                                        size: 13.w, color: AppColors.primary),
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(province,
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textHeading)),
                                  ),
                                ],
                              ),
                            ),

                            // Destination chips
                            Padding(
                              padding: EdgeInsets.fromLTRB(14.w, 0, 14.w, 10.h),
                              child: Wrap(
                                spacing: 6.w,
                                runSpacing: 6.h,
                                children: places
                                    .map((p) => Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.w, vertical: 5.h),
                                          decoration: BoxDecoration(
                                            color: AppColors.primarySoft,
                                            borderRadius: BorderRadius.circular(8.r),
                                          ),
                                          child: Text(p.name,
                                              style: TextStyle(
                                                  fontSize: 11.sp,
                                                  color: AppColors.primaryDark,
                                                  fontWeight: FontWeight.w600)),
                                        ))
                                    .toList(),
                              ),
                            ),

                            // Accommodation row
                            if (booking != null) ...[
                              Divider(
                                  height: 1,
                                  color: AppColors.surfaceBorder,
                                  indent: 14.w,
                                  endIndent: 14.w),
                              Padding(
                                padding: EdgeInsets.fromLTRB(14.w, 10.h, 14.w, 12.h),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.r),
                                      child: CachedNetworkImage(
                                        imageUrl: booking.item.image,
                                        width: 44.w,
                                        height: 44.w,
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) =>
                                            Container(color: AppColors.shimmerBase),
                                        errorWidget: (_, __, ___) =>
                                            Container(color: AppColors.shimmerBase),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(booking.item.name,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.textHeading)),
                                          SizedBox(height: 2.h),
                                          Text(
                                              '${_fmt(booking.checkIn)} → ${_fmt(booking.checkOut)}  ·  ${booking.nights}n  ·  ${booking.guests} guest${booking.guests > 1 ? 's' : ''}',
                                              style: TextStyle(
                                                  fontSize: 10.sp,
                                                  color: AppColors.textSecondary)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                        '\$${booking.totalCost.toStringAsFixed(0)}',
                                        style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary)),
                                  ],
                                ),
                              ),
                            ] else ...[
                              Padding(
                                padding: EdgeInsets.fromLTRB(14.w, 6.h, 14.w, 12.h),
                                child: Row(
                                  children: [
                                    Icon(Icons.hotel_outlined,
                                        size: 13.w, color: AppColors.textDisabled),
                                    SizedBox(width: 6.w),
                                    Text('No accommodation selected',
                                        style: TextStyle(
                                            fontSize: 11.sp,
                                            color: AppColors.textDisabled)),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }),

                    // ── Cost breakdown ──
                    Container(
                      padding: EdgeInsets.all(14.w),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14.r),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 3)),
                        ],
                      ),
                      child: Column(
                        children: [
                          _CostRow(
                            label: 'Destinations',
                            amount: totalCost -
                                bookings.values.fold(0.0, (s, b) => s + b.totalCost),
                          ),
                          ...bookings.entries.map((e) => _CostRow(
                                label: e.value.item.name,
                                sublabel: '${e.value.nights}n · ${e.key}',
                                amount: e.value.totalCost,
                              )),
                          if (airportPickup)
                            const _CostRow(label: 'Airport Pickup', amount: 35),
                          if (tourGuide)
                            const _CostRow(label: 'Tour Guide', amount: 80),
                          Divider(height: 16.h, color: AppColors.surfaceBorder),
                          _CostRow(label: 'Subtotal', amount: totalCost),
                          _CostRow(label: 'Service fee (5%)', amount: serviceFee),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text('Grand Total',
                                  style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textHeading)),
                              const Spacer(),
                              Text('\$${grandTotal.toStringAsFixed(0)}',
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary)),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          // Payment method badge
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: paymentMethod == PaymentMethod.payNow
                                  ? AppColors.primarySoft
                                  : AppColors.warningSoft,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  paymentMethod == PaymentMethod.payNow
                                      ? Icons.credit_card_rounded
                                      : Icons.hotel_rounded,
                                  size: 14.w,
                                  color: paymentMethod == PaymentMethod.payNow
                                      ? AppColors.primary
                                      : AppColors.warning,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  paymentMethod == PaymentMethod.payNow
                                      ? 'Pay Now selected'
                                      : 'Pay on Arrival selected',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: paymentMethod == PaymentMethod.payNow
                                        ? AppColors.primary
                                        : AppColors.warning,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ── Confirm button (pinned at bottom) ──
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, bottomPad + 16.h),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [Color(0xFF007D3D), Color(0xFF00A651)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      paymentMethod == PaymentMethod.payOnArrival
                          ? 'Confirm Booking  ·  Pay on Arrival'
                          : 'Proceed to Pay  Ⓢ${grandTotal.toStringAsFixed(0)}',
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CostRow extends StatelessWidget {
  final String label;
  final String? sublabel;
  final double amount;

  const _CostRow({required this.label, required this.amount, this.sublabel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(fontSize: 12.sp, color: AppColors.textPrimary)),
                if (sublabel != null)
                  Text(sublabel!,
                      style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text('\$${amount.toStringAsFixed(0)}',
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textHeading)),
        ],
      ),
    );
  }
}
