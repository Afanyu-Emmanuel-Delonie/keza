import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';

class SocialAuthRow extends StatelessWidget {
  final VoidCallback onGoogle;
  final VoidCallback onFacebook;
  final VoidCallback onApple;

  const SocialAuthRow({
    super.key,
    required this.onGoogle,
    required this.onFacebook,
    required this.onApple,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialCircle(
          svgAsset: 'assets/icons/google.svg',
          bgColor: Colors.white,
          borderColor: AppColors.surfaceBorder,
          onTap: onGoogle,
        ),
        SizedBox(width: 16.w),
        _SocialCircle(
          svgAsset: 'assets/icons/facebook.svg',
          bgColor: const Color(0xFF1877F2),
          onTap: onFacebook,
        ),
        SizedBox(width: 16.w),
        _SocialCircle(
          svgAsset: 'assets/icons/apple.svg',
          bgColor: Colors.black,
          onTap: onApple,
        ),
      ],
    );
  }
}

class _SocialCircle extends StatelessWidget {
  final String svgAsset;
  final Color bgColor;
  final Color? borderColor;
  final VoidCallback onTap;

  const _SocialCircle({
    required this.svgAsset,
    required this.bgColor,
    required this.onTap,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.09),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: SvgPicture.asset(
            svgAsset,
            width: 24.w,
            height: 24.w,
          ),
        ),
      ),
    );
  }
}
