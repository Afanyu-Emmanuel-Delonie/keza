import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/animated_card_item.dart';
import '../providers/trips_provider.dart';

class BookedTab extends StatelessWidget {
  const BookedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TripsProvider>(
      builder: (context, provider, _) {
        if (provider.bookedTrips.isEmpty) {
          return _EmptyState(
            icon: Icons.confirmation_num_outlined,
            message: 'No bookings yet',
            sub: 'Your confirmed bookings will appear here',
          );
        }

        final upcoming = provider.bookedTrips
            .where((b) => b.status != BookingStatus.completed)
            .toList();
        final past = provider.bookedTrips
            .where((b) => b.status == BookingStatus.completed)
            .toList();

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (upcoming.isNotEmpty) ...[
                _SectionLabel(title: 'Upcoming', index: 0),
                SizedBox(height: 12.h),
                ...List.generate(
                  upcoming.length,
                  (i) => AnimatedCardItem(
                    index: i,
                    child: _BookingCard(booking: upcoming[i]),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
              if (past.isNotEmpty) ...[
                _SectionLabel(title: 'Past Trips', index: upcoming.length),
                SizedBox(height: 12.h),
                ...List.generate(
                  past.length,
                  (i) => AnimatedCardItem(
                    index: upcoming.length + i,
                    child: _BookingCard(booking: past[i]),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  final int index;
  const _SectionLabel({required this.title, required this.index});

  @override
  Widget build(BuildContext context) {
    return AnimatedCardItem(
      index: index,
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookedTrip booking;
  const _BookingCard({required this.booking});

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
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image + status badge ──────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16.r)),
                child: CachedNetworkImage(
                  imageUrl: booking.image,
                  width: double.infinity,
                  height: 140.h,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(color: AppColors.shimmerBase),
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.shimmerBase,
                    child: const Icon(Icons.broken_image,
                        size: 30, color: Colors.grey),
                  ),
                ),
              ),
              // dark overlay
              Positioned.fill(
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(16.r)),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.45),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12.h,
                right: 12.w,
                child: _StatusBadge(status: booking.status),
              ),
              Positioned(
                bottom: 12.h,
                left: 14.w,
                child: Text(
                  booking.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          // ── Details ───────────────────────────────────────────
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Column(
              children: [
                _InfoRow(
                  icon: Icons.location_on_outlined,
                  label: 'Location',
                  value: booking.location,
                ),
                SizedBox(height: 8.h),
                _InfoRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Travel Date',
                  value: booking.travelDate,
                ),
                SizedBox(height: 8.h),
                _InfoRow(
                  icon: Icons.receipt_long_outlined,
                  label: 'Booked On',
                  value: booking.bookingDate,
                ),
                SizedBox(height: 12.h),
                Divider(color: AppColors.surfaceBorder, height: 1),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Paid',
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textSecondary),
                        ),
                        Text(
                          booking.price,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    if (booking.status != BookingStatus.completed)
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: booking.status == BookingStatus.pending
                                ? AppColors.warningSoft
                                : AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Text(
                            booking.status == BookingStatus.pending
                                ? 'Complete Payment'
                                : 'View Details',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: booking.status == BookingStatus.pending
                                  ? AppColors.warning
                                  : AppColors.primary,
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
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14.w, color: AppColors.textSecondary),
        SizedBox(width: 6.w),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final BookingStatus status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = switch (status) {
      BookingStatus.pending => ('Pending Payment', AppColors.warningSoft, AppColors.warning),
      BookingStatus.confirmed => ('Confirmed', AppColors.successSoft, AppColors.success),
      BookingStatus.completed => ('Completed', AppColors.surfaceBorder, AppColors.textSecondary),
    };

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String sub;
  const _EmptyState(
      {required this.icon, required this.message, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56.w, color: AppColors.textDisabled),
            SizedBox(height: 16.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              sub,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
