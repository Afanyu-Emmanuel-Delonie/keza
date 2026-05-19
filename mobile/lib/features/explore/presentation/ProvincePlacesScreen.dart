import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/animated_card_item.dart';
import '../../../shared/widgets/Categories.dart';
import '../../../shared/widgets/keza_app_bar.dart';
import '../../home_screen/presentation/DestinationDetails.dart';

class ProvincePlacesScreen extends StatelessWidget {
  final String provinceName;
  final List<Map<String, dynamic>> destinations;

  const ProvincePlacesScreen({
    super.key,
    required this.provinceName,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KezaAppBar(
        title: provinceName,
        subtitle: '${destinations.length} place${destinations.length != 1 ? 's' : ''}',
        showBack: true,
      ),
      body: destinations.isEmpty
          ? _EmptyState()
          : Column(
              children: [
                // ========== Categories ================================
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                  child: AnimatedCardItem(
                    index: 0,
                    child: CategoriesSection(
                      categories: AppConstants.categories,
                      onCategorySelected: (_) {},
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // ========== Destinations List ================================
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                    itemCount: destinations.length,
                    itemBuilder: (context, index) {
                      final dest = destinations[index];
                      return AnimatedCardItem(
                        index: index + 1,
                        child: _DestinationCard(
                          destination: dest,
                          onTap: () => Navigator.push(
                            context,
                            SmoothPageRoute(
                              page: DestinationDetails(
                                title: dest['name'] as String,
                                location: dest['location'] as String,
                                images: [dest['image'] as String],
                                price: dest['price'] as String?,
                                rating: dest['rating'] as String?,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

// ========== Destination Card ================================
class _DestinationCard extends StatelessWidget {
  final Map<String, dynamic> destination;
  final VoidCallback onTap;

  const _DestinationCard({required this.destination, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        height: 250.h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ========== Image ================================
              CachedNetworkImage(
                imageUrl: destination['image'] as String,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.shimmerBase,
                  child: Icon(Icons.broken_image,
                      size: 40.w, color: AppColors.textDisabled),
                ),
              ),

              // ========== Gradient Overlay ================================
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.15),
                      Colors.black.withOpacity(0.72),
                    ],
                  ),
                ),
              ),

              // ========== Top Row — rating + favourite ================================
              Positioned(
                top: 12.h,
                left: 12.w,
                right: 12.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star_rounded,
                              color: Colors.amber, size: 13.w),
                          SizedBox(width: 3.w),
                          Text(
                            destination['rating'] as String,
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
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.favorite_outline_rounded,
                            color: Colors.white, size: 16.w),
                      ),
                    ),
                  ],
                ),
              ),

              // ========== Bottom Row — info + arrow ================================
              Positioned(
                bottom: 12.h,
                left: 12.w,
                right: 12.w,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            destination['name'] as String,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.sp,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          // ========== Location + Price on one line ================================
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.location_on,
                                  size: 12.w, color: Colors.white70),
                              SizedBox(width: 2.w),
                              Flexible(
                                child: Text(
                                  destination['location'] as String,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 11.sp),
                                ),
                              ),
                              SizedBox(width: 6.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.85),
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  destination['price'] as String,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    // ========== Arrow — tilted 45° north-east ================================
                    CircleAvatar(
                      backgroundColor: AppColors.primary,
                      radius: 16.r,
                      child: Transform.rotate(
                        angle: -0.785398, // -45° = north-east
                        child: Icon(Icons.arrow_forward_rounded,
                            color: Colors.white, size: 16.w),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========== Empty State ================================
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.explore_off_outlined,
              size: 48.w, color: AppColors.textDisabled),
          SizedBox(height: 12.h),
          Text(
            'No places found',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textHeading,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'This province has no destinations yet.',
            style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
