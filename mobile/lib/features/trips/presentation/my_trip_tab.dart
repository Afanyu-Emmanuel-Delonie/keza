import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/animated_card_item.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../Destinations/presentation/destination_details/destination_details_screen.dart';
import '../providers/trips_provider.dart';
import 'name_trip_sheet.dart';

class MyTripTab extends StatefulWidget {
  const MyTripTab({super.key});

  @override
  State<MyTripTab> createState() => _MyTripTabState();
}

class _MyTripTabState extends State<MyTripTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Future<void> _renameTrip(BuildContext context, TripsProvider provider) async {
    final name = await NameTripSheet.show(context);
    if (name != null && context.mounted) {
      provider.setTripGroupName(name);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<TripsProvider>(
      builder: (context, provider, _) {
        if (provider.addedTrips.isEmpty) {
          return const EmptyState(
            icon: Icons.luggage_outlined,
            message: 'Your trip is empty',
            sub: 'Explore Rwanda and tap "+ Add to Trip" to start building your itinerary',
          );
        }

        final grouped = provider.tripsByProvince;
        final provinces = grouped.keys.toList();
        final totalItems = provider.addedTrips.length;

        return Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 110.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Trip name header ──
                  _TripNameHeader(
                    name: provider.tripGroupName ?? 'My Rwanda Trip',
                    itemCount: totalItems,
                    onRename: () => _renameTrip(context, provider),
                  ),
                  SizedBox(height: 20.h),

                  // ── Items grouped by province ──
                  ...List.generate(provinces.length, (pi) {
                    final province = provinces[pi];
                    final trips = grouped[province]!;
                    return AnimatedCardItem(
                      index: pi,
                      child: _ProvinceGroup(
                        province: province,
                        trips: trips,
                        onItemTap: (trip) => Navigator.push(
                          context,
                          SmoothPageRoute(
                            page: DestinationDetails(
                              title: trip.name,
                              location: trip.location,
                              images: [trip.image],
                              price: trip.price,
                              rating: trip.rating,
                            ),
                          ),
                        ),
                        onRemove: (trip) {
                          HapticFeedback.lightImpact();
                          provider.toggleAddTrip(trip);
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),

            // ── Sticky Review & Book bar ──
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: _ReviewBookBar(
                itemCount: totalItems,
                onTap: () => context.push('/plan'),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Trip name header ──────────────────────────────────────────────────────────
class _TripNameHeader extends StatelessWidget {
  final String name;
  final int itemCount;
  final VoidCallback onRename;

  const _TripNameHeader({
    required this.name,
    required this.itemCount,
    required this.onRename,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(Icons.luggage_rounded, color: AppColors.primary, size: 20.w),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textHeading,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                '$itemCount place${itemCount == 1 ? '' : 's'} saved',
                style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onRename,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit_outlined, size: 13.w, color: AppColors.textSecondary),
                SizedBox(width: 4.w),
                Text(
                  'Rename',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── Province group ────────────────────────────────────────────────────────────
class _ProvinceGroup extends StatelessWidget {
  final String province;
  final List<TripItem> trips;
  final ValueChanged<TripItem> onItemTap;
  final ValueChanged<TripItem> onRemove;

  const _ProvinceGroup({
    required this.province,
    required this.trips,
    required this.onItemTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Province label
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(
            children: [
              Container(
                width: 3.w,
                height: 16.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                province,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 0.2,
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                '${trips.length} stop${trips.length == 1 ? '' : 's'}',
                style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),

        // Trip items — swipe left to remove
        ...trips.map((trip) => _SwipeToRemoveItem(
              trip: trip,
              onTap: () => onItemTap(trip),
              onRemove: () => onRemove(trip),
            )),

        SizedBox(height: 8.h),
        const Divider(color: AppColors.surfaceBorder, height: 1),
        SizedBox(height: 20.h),
      ],
    );
  }
}

// ── Swipe-to-remove trip item ─────────────────────────────────────────────────
class _SwipeToRemoveItem extends StatelessWidget {
  final TripItem trip;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _SwipeToRemoveItem({
    required this.trip,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(trip.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: AppColors.errorSoft,
          borderRadius: BorderRadius.circular(14.r),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 22.w),
            SizedBox(height: 2.h),
            Text(
              'Remove',
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.surfaceBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // Thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(10.r),
                child: CachedNetworkImage(
                  imageUrl: trip.image,
                  width: 60.w,
                  height: 60.w,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.shimmerBase,
                    child: Icon(Icons.image_outlined, size: 20.w, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      trip.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textHeading,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 11.w, color: AppColors.textSecondary),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            trip.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Text(
                          trip.price,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        if (trip.isAccommodation) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              'Stay',
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Swipe hint arrow
              Icon(Icons.chevron_left_rounded, size: 16.w, color: AppColors.textDisabled),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Review & Book sticky bar ──────────────────────────────────────────────────
class _ReviewBookBar extends StatelessWidget {
  final int itemCount;
  final VoidCallback onTap;

  const _ReviewBookBar({required this.itemCount, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h + bottomPad),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.surfaceBorder)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 52.h,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF007D3D), Color(0xFF00A651)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.32),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long_rounded, color: Colors.white, size: 18.w),
              SizedBox(width: 8.w),
              Text(
                'Review & Book  ·  $itemCount item${itemCount == 1 ? '' : 's'}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
