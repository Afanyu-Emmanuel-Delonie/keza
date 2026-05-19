import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../core/theme/app_colors.dart';

class DestinationCard extends StatelessWidget {
  final String groupTitle;
  final String nights;
  final String distance;
  final int activitiesCount;
  final String imageUrl;
  final List<String> placeNames;

  const DestinationCard({
    super.key,
    required this.groupTitle,
    required this.nights,
    required this.distance,
    required this.activitiesCount,
    required this.imageUrl,
    required this.placeNames,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero image with overlay ───────────────────────
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: imageUrl,
                  height: 170.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(height: 170.h, color: AppColors.shimmerBase),
                  errorWidget: (_, __, ___) => Container(
                    height: 170.h,
                    color: AppColors.shimmerBase,
                    child: Icon(Icons.landscape_outlined,
                        size: 40.w, color: AppColors.textDisabled),
                  ),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),
                ),
                // Activities badge
                Positioned(
                  top: 12.h,
                  right: 12.w,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '$activitiesCount activities',
                      style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),
                // Title + pills
                Positioned(
                  left: 14.w,
                  bottom: 14.h,
                  right: 14.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        groupTitle,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          _InfoPill(
                              icon: Icons.nights_stay_outlined, label: nights),
                          SizedBox(width: 8.w),
                          _InfoPill(
                              icon: Icons.near_me_outlined, label: distance),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // ── Place chips ───────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
            child: Wrap(
              spacing: 8.w,
              runSpacing: 6.h,
              children: placeNames.map((n) => _PlaceChip(name: n)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11.w, color: Colors.white),
          SizedBox(width: 4.w),
          Text(label,
              style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _PlaceChip extends StatelessWidget {
  final String name;
  const _PlaceChip({required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, size: 11.w, color: AppColors.primary),
          SizedBox(width: 4.w),
          Text(name,
              style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
