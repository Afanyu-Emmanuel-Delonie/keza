import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';

class PricingSection extends StatelessWidget {
  final double accommodation;
  final double transport;
  final double activities;
  final double serviceFee;

  const PricingSection({
    super.key,
    required this.accommodation,
    required this.transport,
    required this.activities,
    required this.serviceFee,
  });

  double get _total => accommodation + transport + activities + serviceFee;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trip Summary',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textHeading,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: 14.h),
        Container(
          padding: EdgeInsets.all(20.w),
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
            children: [
              _PriceRow(
                icon: Icons.hotel_rounded,
                label: 'Accommodation',
                value: accommodation,
              ),
              _Divider(),
              _PriceRow(
                icon: Icons.directions_car_rounded,
                label: 'Transport',
                value: transport,
              ),
              _Divider(),
              _PriceRow(
                icon: Icons.local_activity_rounded,
                label: 'Activities',
                value: activities,
              ),
              _Divider(),
              _PriceRow(
                icon: Icons.receipt_long_rounded,
                label: 'Service Fee',
                value: serviceFee,
              ),
              SizedBox(height: 16.h),
              // ── Total ──────────────────────────────────
              Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF004B24), Color(0xFF00A651)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Trip Cost',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'All inclusive',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '\$${_total.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final double value;

  const _PriceRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(7.w),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 15.w, color: AppColors.primary),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 14.sp, color: AppColors.textPrimary),
            ),
          ),
          Text(
            value > 0 ? '\$${value.toStringAsFixed(0)}' : 'Free',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: value > 0 ? AppColors.textHeading : AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: AppColors.surfaceBorder);
  }
}
