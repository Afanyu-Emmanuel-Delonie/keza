import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/trips_provider.dart';

class BookingFormSheet extends StatefulWidget {
  final TripItem item;

  const BookingFormSheet({super.key, required this.item});

  /// Returns an [AccommodationBooking] or null if dismissed.
  static Future<AccommodationBooking?> show(BuildContext context, TripItem item) {
    return showModalBottomSheet<AccommodationBooking>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BookingFormSheet(item: item),
    );
  }

  @override
  State<BookingFormSheet> createState() => _BookingFormSheetState();
}

class _BookingFormSheetState extends State<BookingFormSheet> {
  DateTime? _checkIn;
  DateTime? _checkOut;
  int _guests = 1;
  String _roomType = 'Standard';
  final _notesCtrl = TextEditingController();

  static const _roomTypes = ['Standard', 'Deluxe', 'Suite', 'Family Room'];

  Future<void> _pickDate(bool isCheckIn) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn
          ? now.add(const Duration(days: 1))
          : (_checkIn?.add(const Duration(days: 1)) ?? now.add(const Duration(days: 2))),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            surface: Colors.white,
            onSurface: AppColors.textHeading,
          ),
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

  int get _nights =>
      (_checkIn != null && _checkOut != null) ? _checkOut!.difference(_checkIn!).inDays : 0;

  String _fmt(DateTime d) {
    const m = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${d.day} ${m[d.month - 1]} ${d.year}';
  }

  double get _pricePerNight {
    final raw = widget.item.price.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(raw) ?? 0;
  }

  void _confirm() {
    Navigator.pop(
      context,
      AccommodationBooking(
        item: widget.item,
        checkIn: _checkIn!,
        checkOut: _checkOut!,
        guests: _guests,
        roomType: _roomType,
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      ),
    );
  }

  void _aiAssist() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                gradient: AppColors.aiGradient,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 16.w),
            ),
            SizedBox(width: 10.w),
            Text('AI Booking Assistant',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Keza AI will fill in the best dates, room type, and preferences for ${widget.item.name} based on your trip.\n\nNote: AI cannot process payment — you\'ll review and confirm before checkout.',
          style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Simulate AI pre-fill
              final now = DateTime.now();
              final booking = AccommodationBooking(
                item: widget.item,
                checkIn: now.add(const Duration(days: 7)),
                checkOut: now.add(const Duration(days: 10)),
                guests: 2,
                roomType: 'Deluxe',
                notes: 'AI suggested: quiet room, high floor preferred.',
              );
              Navigator.pop(context, booking);
            },
            child: Text('Let AI Book',
                style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canConfirm = _checkIn != null && _checkOut != null;
    final totalCost = _pricePerNight * _nights;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceRaised,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 32.h),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
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

              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.item.name,
                            style: TextStyle(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textHeading)),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 11.w, color: AppColors.textSecondary),
                            SizedBox(width: 2.w),
                            Text(widget.item.location,
                                style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                            SizedBox(width: 8.w),
                            Text(widget.item.price,
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // AI assist button
                  GestureDetector(
                    onTap: _aiAssist,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        gradient: AppColors.aiGradient,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 13.w),
                          SizedBox(width: 5.w),
                          Text('AI Assist',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // Dates
              Row(
                children: [
                  Expanded(
                    child: _DateTile(
                      label: 'Check-in',
                      value: _checkIn != null ? _fmt(_checkIn!) : null,
                      onTap: () => _pickDate(true),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _DateTile(
                      label: 'Check-out',
                      value: _checkOut != null ? _fmt(_checkOut!) : null,
                      onTap: () => _pickDate(false),
                    ),
                  ),
                ],
              ),

              if (_nights > 0) ...[
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text('$_nights night${_nights > 1 ? 's' : ''}',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
                    const Spacer(),
                    Text('\$${totalCost.toStringAsFixed(0)} total',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textHeading,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],

              SizedBox(height: 16.h),

              // Guests
              Text('Guests',
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHeading)),
              SizedBox(height: 8.h),
              Row(
                children: [
                  _CounterBtn(
                      icon: Icons.remove,
                      onTap: () {
                        if (_guests > 1) setState(() => _guests--);
                      }),
                  SizedBox(width: 16.w),
                  Text('$_guests',
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textHeading)),
                  SizedBox(width: 16.w),
                  _CounterBtn(
                      icon: Icons.add,
                      onTap: () {
                        if (_guests < 10) setState(() => _guests++);
                      }),
                ],
              ),

              SizedBox(height: 16.h),

              // Room type
              Text('Room Type',
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHeading)),
              SizedBox(height: 8.h),
              SizedBox(
                height: 36.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _roomTypes.length,
                  separatorBuilder: (_, __) => SizedBox(width: 8.w),
                  itemBuilder: (_, i) {
                    final selected = _roomTypes[i] == _roomType;
                    return GestureDetector(
                      onTap: () => setState(() => _roomType = _roomTypes[i]),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                        decoration: BoxDecoration(
                          color: selected ? AppColors.primary : AppColors.surface,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              color: selected ? AppColors.primary : AppColors.surfaceBorder),
                        ),
                        alignment: Alignment.center,
                        child: Text(_roomTypes[i],
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: selected ? Colors.white : AppColors.textPrimary,
                            )),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 16.h),

              // Special requests
              Text('Special Requests (optional)',
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHeading)),
              SizedBox(height: 8.h),
              TextField(
                controller: _notesCtrl,
                maxLines: 2,
                style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'e.g. early check-in, ground floor...',
                  hintStyle: TextStyle(fontSize: 12.sp, color: AppColors.textDisabled),
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.surfaceBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(color: AppColors.surfaceBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Confirm button
              SizedBox(
                width: double.infinity,
                child: GestureDetector(
                  onTap: canConfirm ? _confirm : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    decoration: BoxDecoration(
                      gradient: canConfirm
                          ? const LinearGradient(
                              colors: [Color(0xFF007D3D), Color(0xFF00A651)])
                          : null,
                      color: canConfirm ? null : AppColors.surfaceBorder,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Confirm Stay',
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: canConfirm ? Colors.white : AppColors.textDisabled,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback onTap;
  const _DateTile({required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasVal = value != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
              color: hasVal ? AppColors.primary : AppColors.surfaceBorder,
              width: hasVal ? 1.5 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary)),
            SizedBox(height: 3.h),
            Text(value ?? 'Select',
                style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: hasVal ? AppColors.textHeading : AppColors.textDisabled)),
          ],
        ),
      ),
    );
  }
}

class _CounterBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CounterBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: Icon(icon, size: 16.w, color: AppColors.textPrimary),
      ),
    );
  }
}
