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
        decoration: BoxDecoration(
          color: AppColors.surface,
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
            // ========== Hero Image ================================
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: destination['image'] as String,
                    width: double.infinity,
                    height: 180.h,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(
                      height: 180.h,
                      color: AppColors.shimmerBase,
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 180.h,
                      color: AppColors.shimmerBase,
                      child: Icon(Icons.broken_image,
                          color: AppColors.textDisabled, size: 40.w),
                    ),
                  ),
                  // price badge overlay
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDarker,
                        borderRadius: BorderRadius.circular(20.r),
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
                  ),
                ],
              ),
            ),

            // ========== Info ================================
            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          destination['name'] as String,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textHeading,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      // ========== Rating Badge ================================
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded,
                                color: Colors.amber, size: 13.w),
                            SizedBox(width: 3.w),
                            Text(
                              destination['rating'] as String,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 13.w, color: AppColors.primary),
                      SizedBox(width: 3.w),
                      Text(
                        destination['location'] as String,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // ========== CTA Row ================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'View Details',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(6.w),
                        decoration: BoxDecoration(
                          color: AppColors.primarySoft,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(Icons.arrow_forward_rounded,
                            size: 14.w, color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
