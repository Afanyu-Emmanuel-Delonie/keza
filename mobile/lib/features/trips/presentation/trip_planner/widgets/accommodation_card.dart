import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/theme/app_colors.dart';

class AccommodationCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double stars;
  final String distanceFromActivities;
  final double pricePerNight;
  final bool selected;
  final VoidCallback onTap;

  const AccommodationCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.stars,
    required this.distanceFromActivities,
    required this.pricePerNight,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Hotel image ───────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.horizontal(left: Radius.circular(18.r)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 90.w,
                height: 90.w,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: AppColors.shimmerBase),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.shimmerBase,
                  child: Icon(Icons.hotel,
                      size: 28.w, color: AppColors.textDisabled),
                ),
              ),
            ),
            // ── Details ───────────────────────────────────
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textHeading,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    _StarRow(stars: stars),
                    SizedBox(height: 5.h),
                    Row(
                      children: [
                        Icon(Icons.directions_walk_rounded,
                            size: 12.w, color: AppColors.textSecondary),
                        SizedBox(width: 3.w),
                        Text(
                          distanceFromActivities,
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // ── Price + check ─────────────────────────────
            Padding(
              padding: EdgeInsets.only(right: 14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${pricePerNight.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '/ night',
                    style: TextStyle(
                        fontSize: 10.sp, color: AppColors.textSecondary),
                  ),
                  SizedBox(height: 8.h),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 22.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selected ? AppColors.primary : AppColors.surfaceBorder,
                    ),
                    child: selected
                        ? Icon(Icons.check_rounded,
                            size: 13.w, color: Colors.white)
                        : null,
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

class _StarRow extends StatelessWidget {
  final double stars;
  const _StarRow({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) {
        final filled = i < stars.floor();
        final half = !filled && i < stars;
        return Icon(
          half ? Icons.star_half_rounded : Icons.star_rounded,
          size: 13.w,
          color: filled || half
              ? const Color(0xFFFFC107)
              : AppColors.surfaceBorder,
        );
      }),
    );
  }
}
