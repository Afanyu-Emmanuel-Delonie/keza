import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/trip_snackbar.dart';
import '../../../core/widgets/animated_card_item.dart';
import '../providers/trips_provider.dart';

class FavouritesTab extends StatefulWidget {
  const FavouritesTab({super.key});

  @override
  State<FavouritesTab> createState() => _FavouritesTabState();
}

class _FavouritesTabState extends State<FavouritesTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<TripsProvider>(
      builder: (context, provider, _) {
        final trips = provider.favourites.where((f) => !f.isAccommodation).toList();
        final stays = provider.favourites.where((f) => f.isAccommodation).toList();

        if (provider.favourites.isEmpty) {
          return _EmptyState(
            icon: Icons.favorite_outline_rounded,
            message: 'No favourites yet',
            sub: 'Tap the heart on any destination or stay to save it here',
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (trips.isNotEmpty) ...[
                _SectionLabel(title: 'Saved Destinations', index: 0),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 230.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: trips.length,
                    itemBuilder: (context, i) => AnimatedCardItem(
                      index: i,
                      child: _FavTripCard(
                        item: trips[i],
                        onUnfavourite: () => provider.toggleFavourite(trips[i]),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
              ],
              if (stays.isNotEmpty) ...[
                _SectionLabel(title: 'Saved Stays', index: 1),
                SizedBox(height: 12.h),
                SizedBox(
                  height: 230.h,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    itemCount: stays.length,
                    itemBuilder: (context, i) => AnimatedCardItem(
                      index: i,
                      child: _FavTripCard(
                        item: stays[i],
                        onUnfavourite: () => provider.toggleFavourite(stays[i]),
                      ),
                    ),
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
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
        ),
      ),
    );
  }
}

class _FavTripCard extends StatelessWidget {
  final TripItem item;
  final VoidCallback onUnfavourite;
  const _FavTripCard({required this.item, required this.onUnfavourite});

  @override
  Widget build(BuildContext context) {
    return Consumer<TripsProvider>(
      builder: (context, provider, _) {
        final added = provider.isAdded(item.id);
        return Container(
          margin: EdgeInsets.only(right: 12.w),
          width: 250.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: item.image,
                  width: 250.w,
                  height: 230.h,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                  errorWidget: (_, __, ___) => Container(
                    color: AppColors.shimmerBase,
                    child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.15),
                        Colors.black.withOpacity(0.70),
                      ],
                    ),
                  ),
                ),
                // top row: rating + unfavourite
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  right: 12.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 13.w),
                            SizedBox(width: 3.w),
                            Text(
                              item.rating,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: onUnfavourite,
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.favorite_rounded,
                              color: AppColors.error, size: 16.w),
                        ),
                      ),
                    ],
                  ),
                ),
                // bottom info + add to trip
                Positioned(
                  bottom: 12.h,
                  left: 12.w,
                  right: 12.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (item.isAccommodation)
                        Container(
                          margin: EdgeInsets.only(bottom: 4.h),
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text('Stay',
                              style: TextStyle(color: Colors.white, fontSize: 9.sp)),
                        ),
                      Text(
                        item.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 12.w, color: Colors.white70),
                          SizedBox(width: 2.w),
                          Expanded(
                            child: Text(
                              item.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      // Add to Trip button
                      GestureDetector(
                        onTap: () {
                          if (!added) showAddedToTripSnackbar(context, item.name);
                          provider.toggleAddTrip(item);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                          decoration: BoxDecoration(
                            color: added
                                ? Colors.white.withOpacity(0.2)
                                : AppColors.primary,
                            borderRadius: BorderRadius.circular(20.r),
                            border: added
                                ? Border.all(color: Colors.white54, width: 1)
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                added ? Icons.check_rounded : Icons.add_rounded,
                                color: Colors.white,
                                size: 14.w,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                added ? 'Added to Trip' : 'Add to Trip',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
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
          ),
        );
      },
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
                  fontSize: 13.sp, color: AppColors.textSecondary, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
