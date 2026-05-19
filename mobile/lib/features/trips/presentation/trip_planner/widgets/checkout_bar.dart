import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class CheckoutBar extends StatelessWidget {
  final double total;
  final VoidCallback onCheckout;

  const CheckoutBar({
    super.key,
    required this.total,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 14.h, 20.w, 28.h),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Total ─────────────────────────────────────────
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: TextStyle(
                    fontSize: 11.sp, color: AppColors.textSecondary),
              ),
              SizedBox(height: 2.h),
              Text(
                '\$${total.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textHeading,
                ),
              ),
            ],
          ),
          SizedBox(width: 20.w),
          // ── CTA ───────────────────────────────────────────
          Expanded(
            child: GestureDetector(
              onTap: onCheckout,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF007D3D), Color(0xFF00A651)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'Continue To Checkout',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
