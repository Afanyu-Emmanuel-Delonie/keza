import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';

/// A tall card used in horizontal lists across Explore sections.
/// Shows image, category badge, like button, name, location, price.
class ExploreItemCard extends StatelessWidget {
  final String id;
  final String name;
  final String location;
  final String image;
  final String price;
  final String rating;
  final String categoryLabel;
  final bool isLiked;
  final bool isAdded;
  final VoidCallback onTap;
  final VoidCallback onLike;
  final VoidCallback onAddToTrip;

  const ExploreItemCard({
    super.key,
    required this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.price,
    required this.rating,
    required this.categoryLabel,
    required this.isLiked,
    required this.isAdded,
    required this.onTap,
    required this.onLike,
    required this.onAddToTrip,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 250.w,
        margin: EdgeInsets.only(right: 14.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: AppColors.shimmerBase,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.09),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // ── Background image ──
              CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                errorWidget: (_, __, ___) => Container(color: AppColors.shimmerBase),
              ),

              // ── Gradient overlay ──
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.06),
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                    stops: const [0.0, 0.35, 1.0],
                  ),
                ),
              ),

              // ── Top row: category badge + like button ──
              Positioned(
                top: 12.h,
                left: 12.w,
                right: 12.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.40),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Text(
                        categoryLabel,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onLike,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 32.w,
                        height: 32.w,
                        decoration: BoxDecoration(
                          color: isLiked
                              ? AppColors.error.withOpacity(0.88)
                              : Colors.black.withOpacity(0.35),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                          color: Colors.white,
                          size: 15.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Bottom: rating, name, location, price + add button ──
              Positioned(
                bottom: 12.h,
                left: 12.w,
                right: 12.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Rating
                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: Colors.amber, size: 12.w),
                        SizedBox(width: 3.w),
                        Text(
                          rating,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // Name
                    Text(
                      name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14.sp,
                        height: 1.25,
                      ),
                    ),
                    SizedBox(height: 6.h),

                    // Location + price row
                    Row(
                      children: [
                        Icon(Icons.location_on_rounded, size: 11.w, color: Colors.white70),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(
                            location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white70, fontSize: 10.sp),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                          decoration: BoxDecoration(
                            color: price == 'Free'
                                ? AppColors.success.withOpacity(0.85)
                                : AppColors.primary.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            price,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
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
