import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

void showAddedToTripSnackbar(BuildContext context, String name) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.primaryDarker,
      margin: EdgeInsets.fromLTRB(16.w, 60.h, 16.w, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      duration: const Duration(seconds: 2),
      content: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
            child: Icon(Icons.check_rounded, color: Colors.white, size: 14.w),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              '$name added to your trip',
              style: TextStyle(color: Colors.white, fontSize: 13.sp),
            ),
          ),
        ],
      ),
    ),
  );
}

void showTopSnackbar(BuildContext context, String message, {IconData icon = Icons.info_outline_rounded, Color color = AppColors.primaryDarker}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: color,
      margin: EdgeInsets.fromLTRB(16.w, 60.h, 16.w, 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      duration: const Duration(seconds: 2),
      content: Row(
        children: [
          Icon(icon, color: Colors.white, size: 16.w),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(message, style: TextStyle(color: Colors.white, fontSize: 13.sp)),
          ),
        ],
      ),
    ),
  );
}
