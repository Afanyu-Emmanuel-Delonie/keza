import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';

enum _PayMethod { card, mobileMoney, bankTransfer }

class PaymentSheet extends StatefulWidget {
  final double total;

  const PaymentSheet({super.key, required this.total});

  static Future<bool?> show(BuildContext context, {required double total}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => PaymentSheet(total: total),
    );
  }

  @override
  State<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<PaymentSheet> {
  _PayMethod _selected = _PayMethod.card;

  void _checkout() {
    Navigator.pop(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _PaymentDetailsDialog(
        method: _selected,
        total: widget.total,
        onPaid: () {
          Navigator.pop(ctx);
          _showConfirmation();
        },
      ),
    );
  }

  void _showConfirmation() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => _ConfirmationDialog(
        onDone: () => Navigator.pop(ctx),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.surfaceBorder,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          Text('Payment Method',
              style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textHeading,
                  letterSpacing: -0.3)),
          SizedBox(height: 4.h),
          Text('Choose how you\'d like to pay',
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
          SizedBox(height: 20.h),

          _MethodTile(
            icon: Icons.credit_card_rounded,
            label: 'Credit / Debit Card',
            subtitle: 'Visa, Mastercard, Amex',
            selected: _selected == _PayMethod.card,
            onTap: () => setState(() => _selected = _PayMethod.card),
          ),
          SizedBox(height: 10.h),
          _MethodTile(
            icon: Icons.phone_android_rounded,
            label: 'Mobile Money',
            subtitle: 'MTN MoMo, Airtel Money',
            selected: _selected == _PayMethod.mobileMoney,
            onTap: () => setState(() => _selected = _PayMethod.mobileMoney),
          ),
          SizedBox(height: 10.h),
          _MethodTile(
            icon: Icons.account_balance_rounded,
            label: 'Bank Transfer',
            subtitle: 'Direct bank payment',
            selected: _selected == _PayMethod.bankTransfer,
            onTap: () => setState(() => _selected = _PayMethod.bankTransfer),
          ),

          SizedBox(height: 24.h),

          SizedBox(
            width: double.infinity,
            child: GestureDetector(
              onTap: _checkout,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF007D3D), Color(0xFF00A651)]),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.primary.withOpacity(0.35),
                        blurRadius: 14,
                        offset: const Offset(0, 6)),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  'Checkout  ·  \$${widget.total.toStringAsFixed(0)}',
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MethodTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _MethodTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySoft : AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.surfaceBorder,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(9.w),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : AppColors.background,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon,
                  size: 18.w,
                  color: selected ? Colors.white : AppColors.textSecondary),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textHeading)),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 11.sp, color: AppColors.textSecondary)),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primary : Colors.transparent,
                border: Border.all(
                    color: selected ? AppColors.primary : AppColors.surfaceBorder,
                    width: 1.5),
              ),
              child: selected
                  ? Icon(Icons.check_rounded, size: 12.w, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Payment details popup ────────────────────────────────────────────────────
class _PaymentDetailsDialog extends StatefulWidget {
  final _PayMethod method;
  final double total;
  final VoidCallback onPaid;

  const _PaymentDetailsDialog({
    required this.method,
    required this.total,
    required this.onPaid,
  });

  @override
  State<_PaymentDetailsDialog> createState() => _PaymentDetailsDialogState();
}

class _PaymentDetailsDialogState extends State<_PaymentDetailsDialog> {
  final _ctrl1 = TextEditingController();
  final _ctrl2 = TextEditingController();
  final _ctrl3 = TextEditingController();

  @override
  void dispose() {
    _ctrl1.dispose();
    _ctrl2.dispose();
    _ctrl3.dispose();
    super.dispose();
  }

  (String, String, String, String) get _fields {
    switch (widget.method) {
      case _PayMethod.card:
        return ('Card Number', 'MM / YY', 'CVV', '');
      case _PayMethod.mobileMoney:
        return ('Phone Number', 'Provider (MTN / Airtel)', '', '');
      case _PayMethod.bankTransfer:
        return ('Account Number', 'Bank Name', '', '');
    }
  }

  @override
  Widget build(BuildContext context) {
    final (f1, f2, f3, _) = _fields;
    final showThird = f3.isNotEmpty;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Enter Payment Details',
                style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeading)),
            SizedBox(height: 4.h),
            Text('\$${widget.total.toStringAsFixed(0)} due',
                style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600)),
            SizedBox(height: 16.h),
            _Field(label: f1, ctrl: _ctrl1),
            SizedBox(height: 10.h),
            _Field(label: f2, ctrl: _ctrl2),
            if (showThird) ...[
              SizedBox(height: 10.h),
              _Field(label: f3, ctrl: _ctrl3, obscure: true),
            ],
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel',
                        style: TextStyle(color: AppColors.textSecondary)),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: GestureDetector(
                    onTap: widget.onPaid,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                            colors: [Color(0xFF007D3D), Color(0xFF00A651)]),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      alignment: Alignment.center,
                      child: Text('Pay Now',
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final bool obscure;

  const _Field({required this.label, required this.ctrl, this.obscure = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColors.surfaceBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: AppColors.surfaceBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}

// ── Confirmation dialog ──────────────────────────────────────────────────────
class _ConfirmationDialog extends StatelessWidget {
  final VoidCallback onDone;
  const _ConfirmationDialog({required this.onDone});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                gradient: AppColors.aiGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_rounded, color: Colors.white, size: 32.w),
            ),
            SizedBox(height: 16.h),
            Text('Booking Confirmed!',
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeading)),
            SizedBox(height: 8.h),
            Text(
              'Your trip to Rwanda is booked.\nA confirmation will be sent to your email.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13.sp, color: AppColors.textSecondary, height: 1.5),
            ),
            SizedBox(height: 24.h),
            SizedBox(
              width: double.infinity,
              child: GestureDetector(
                onTap: onDone,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF007D3D), Color(0xFF00A651)]),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  alignment: Alignment.center,
                  child: Text('Done',
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
