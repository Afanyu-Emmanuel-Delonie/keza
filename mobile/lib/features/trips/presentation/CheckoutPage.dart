import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';

class CheckoutPage extends StatefulWidget {
  final String title;
  final String location;
  final String price;
  final String? heroImage;

  const CheckoutPage({
    required this.title,
    required this.location,
    required this.price,
    this.heroImage,
    super.key,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _adults = 1;
  int _children = 0;
  int _rooms = 1;
  bool _addingGuests = false;

  int get _nights =>
      (_checkIn != null && _checkOut != null)
          ? _checkOut!.difference(_checkIn!).inDays.clamp(1, 365)
          : 1;

  double get _pricePerNight =>
      double.tryParse(widget.price.replaceAll(RegExp(r'[^\d.]'), '')) ?? 120;

  double get _total => _pricePerNight * _nights * _rooms;

  Future<void> _pickDate(bool isCheckIn) async {
    final now = DateTime.now();
    final first = isCheckIn ? now : (_checkIn ?? now).add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: first,
      firstDate: first,
      lastDate: now.add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isCheckIn) {
        _checkIn = picked;
        if (_checkOut != null && !_checkOut!.isAfter(picked)) _checkOut = null;
      } else {
        _checkOut = picked;
      }
    });
  }

  String _fmt(DateTime? d) =>
      d == null ? 'Select' : '${d.day} ${_month(d.month)} ${d.year}';

  String _month(int m) => const [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ][m];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              size: 18.w, color: AppColors.textHeading),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          'Checkout',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textHeading,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  // ── Property card ──────────────────────────────
                  _PropertyCard(
                    title: widget.title,
                    location: widget.location,
                    price: widget.price,
                    heroImage: widget.heroImage,
                  ),
                  SizedBox(height: 24.h),
                  // ── Dates ─────────────────────────────────────
                  _SectionLabel('Stay Dates'),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: _DateTile(
                          label: 'Check-in',
                          value: _fmt(_checkIn),
                          icon: Icons.login_rounded,
                          onTap: () => _pickDate(true),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _DateTile(
                          label: 'Check-out',
                          value: _fmt(_checkOut),
                          icon: Icons.logout_rounded,
                          onTap: () => _pickDate(false),
                        ),
                      ),
                    ],
                  ),
                  if (_checkIn != null && _checkOut != null) ...[
                    SizedBox(height: 8.h),
                    Center(
                      child: Text(
                        '$_nights night${_nights > 1 ? 's' : ''}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  SizedBox(height: 24.h),
                  // ── Rooms ─────────────────────────────────────
                  _SectionLabel('Rooms'),
                  SizedBox(height: 10.h),
                  _CounterTile(
                    icon: Icons.bed_outlined,
                    label: 'Rooms',
                    subtitle: 'Number of rooms needed',
                    value: _rooms,
                    onChanged: (v) => setState(() => _rooms = v),
                    min: 1,
                    max: 10,
                  ),
                  SizedBox(height: 24.h),
                  // ── Guests ────────────────────────────────────
                  _SectionLabel('Guests'),
                  SizedBox(height: 10.h),
                  GestureDetector(
                    onTap: () => setState(() => _addingGuests = !_addingGuests),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: _addingGuests
                              ? AppColors.primary
                              : AppColors.surfaceBorder,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.people_outline,
                              color: AppColors.primary, size: 20.w),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              '$_adults adult${_adults > 1 ? 's' : ''}'
                              '${_children > 0 ? ', $_children child${_children > 1 ? 'ren' : ''}' : ''}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(
                            _addingGuests
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: AppColors.textSecondary,
                            size: 20.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_addingGuests) ...[
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: AppColors.surfaceBorder),
                      ),
                      child: Column(
                        children: [
                          _CounterTile(
                            icon: Icons.person_outline,
                            label: 'Adults',
                            subtitle: 'Age 13+',
                            value: _adults,
                            onChanged: (v) => setState(() => _adults = v),
                            min: 1,
                            max: 20,
                          ),
                          Divider(
                              height: 20.h, color: AppColors.surfaceBorder),
                          _CounterTile(
                            icon: Icons.child_care_outlined,
                            label: 'Children',
                            subtitle: 'Age 2–12',
                            value: _children,
                            onChanged: (v) => setState(() => _children = v),
                            min: 0,
                            max: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 24.h),
                  // ── Price breakdown ───────────────────────────
                  _SectionLabel('Price Summary'),
                  SizedBox(height: 10.h),
                  _PriceSummary(
                    pricePerNight: _pricePerNight,
                    nights: _nights,
                    rooms: _rooms,
                    total: _total,
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
          // ── Floating confirm bar ───────────────────────────────
          _ConfirmBar(total: _total, onConfirm: () {}),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textHeading,
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final String title;
  final String location;
  final String price;
  final String? heroImage;

  const _PropertyCard({
    required this.title,
    required this.location,
    required this.price,
    this.heroImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              width: 70.w,
              height: 70.w,
              color: AppColors.shimmerBase,
              child: heroImage != null
                  ? Image.network(heroImage!, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                            Icons.hotel,
                            color: AppColors.primary,
                            size: 30.w,
                          ))
                  : Icon(Icons.hotel, color: AppColors.primary, size: 30.w),
            ),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeading,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        size: 13.w, color: AppColors.primary),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Text(
                        location,
                        style: TextStyle(
                            fontSize: 12.sp, color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  '$price / night',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  const _DateTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value != 'Select';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.surfaceBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon,
                    size: 14.w,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary),
                SizedBox(width: 6.w),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? AppColors.textHeading
                    : AppColors.textDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CounterTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  const _CounterTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    required this.min,
    required this.max,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20.w),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
              Text(subtitle,
                  style: TextStyle(
                      fontSize: 11.sp, color: AppColors.textSecondary)),
            ],
          ),
        ),
        _CounterControl(
          value: value,
          min: min,
          max: max,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _CounterControl extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _CounterControl({
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleBtn(
          icon: Icons.remove,
          enabled: value > min,
          onTap: () => onChanged(value - 1),
        ),
        SizedBox(width: 14.w),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textHeading,
          ),
        ),
        SizedBox(width: 14.w),
        _CircleBtn(
          icon: Icons.add,
          enabled: value < max,
          onTap: () => onChanged(value + 1),
        ),
      ],
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _CircleBtn(
      {required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled ? AppColors.primarySoft : AppColors.surfaceBorder,
        ),
        child: Icon(
          icon,
          size: 16.w,
          color: enabled ? AppColors.primary : AppColors.textDisabled,
        ),
      ),
    );
  }
}

class _PriceSummary extends StatelessWidget {
  final double pricePerNight;
  final int nights;
  final int rooms;
  final double total;

  const _PriceSummary({
    required this.pricePerNight,
    required this.nights,
    required this.rooms,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        children: [
          _PriceRow(
            label:
                '\$${pricePerNight.toStringAsFixed(0)} × $nights night${nights > 1 ? 's' : ''}',
            value: '\$${(pricePerNight * nights).toStringAsFixed(0)}',
          ),
          if (rooms > 1) ...[
            SizedBox(height: 8.h),
            _PriceRow(
              label: '× $rooms rooms',
              value: '\$${total.toStringAsFixed(0)}',
            ),
          ],
          SizedBox(height: 8.h),
          _PriceRow(
            label: 'Taxes & fees',
            value: 'Included',
            valueColor: AppColors.textSecondary,
          ),
          Divider(height: 20.h, color: AppColors.surfaceBorder),
          _PriceRow(
            label: 'Total',
            value: '\$${total.toStringAsFixed(0)}',
            bold: true,
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final Color? valueColor;

  const _PriceRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontSize: bold ? 15.sp : 13.sp,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: valueColor ?? (bold ? AppColors.textHeading : AppColors.textSecondary),
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: bold ? 15.sp : 13.sp,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: bold ? AppColors.textHeading : AppColors.textSecondary,
            )),
        Text(value, style: style),
      ],
    );
  }
}

class _ConfirmBar extends StatelessWidget {
  final double total;
  final VoidCallback onConfirm;

  const _ConfirmBar({required this.total, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total',
                  style: TextStyle(
                      fontSize: 11.sp, color: Colors.white.withOpacity(0.75))),
              Text(
                '\$${total.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: GestureDetector(
              onTap: onConfirm,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  'Confirm Booking',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
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
