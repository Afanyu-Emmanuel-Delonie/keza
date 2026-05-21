import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class ProfilePageScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;

  const ProfilePageScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: EdgeInsets.only(left: 16.w, top: 8.h, bottom: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  size: 16.w, color: AppColors.textHeading),
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textHeading,
            ),
          ),
          centerTitle: true,
          actions: actions,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 40.h),
          child: child,
        ),
      ),
    );
  }
}
