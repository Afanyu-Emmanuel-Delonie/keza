import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/trips_provider.dart';

final Map<String, List<Map<String, dynamic>>> _stayOptions = {
  'Northern Province': [
    {'name': 'Luxury Green Villa', 'location': 'Musanze', 'price': 120.0, 'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=400&fit=crop'},
    {'name': 'Gorilla Nest Lodge', 'location': 'Kinigi', 'price': 200.0, 'image': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=400&fit=crop'},
  ],
  'Eastern Province': [
    {'name': 'Akagera Game Lodge', 'location': 'Kayonza', 'price': 95.0, 'image': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?q=80&w=400&fit=crop'},
  ],
  'Kigali City': [
    {'name': 'Kigali Serena Hotel', 'location': 'Kigali CBD', 'price': 180.0, 'image': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?q=80&w=400&fit=crop'},
    {'name': 'Radisson Blu', 'location': 'Kigali CBD', 'price': 160.0, 'image': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?q=80&w=400&fit=crop'},
  ],
  'Western Province': [
    {'name': 'Lake Kivu Serena', 'location': 'Rubavu', 'price': 150.0, 'image': 'https://images.unsplash.com/photo-1540541338287-41700207dee6?q=80&w=400&fit=crop'},
  ],
};

const double _guideFee = 50.0;

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final Map<String, Map<String, dynamic>> _selectedStays = {};
  bool _wantsGuide = false;

  double _total(List<TripItem> trips) {
    final dest = trips.fold(0.0, (sum, t) {
      final raw = t.price.replaceAll(r'$', '').replaceAll(',', '');
      return sum + (double.tryParse(raw) ?? 0.0);
    });
    final stays = _selectedStays.values.fold(0.0, (s, m) => s + (m['price'] as double));
    return dest + stays + (_wantsGuide ? _guideFee : 0.0);
  }

  void _pickStay(TripItem trip) {
    final options = _stayOptions[trip.province] ?? [];
    if (options.isEmpty) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (_) => StatefulBuilder(builder: (ctx, setSheet) {
        final current = _selectedStays[trip.id];
        return Container(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 32.h),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceBorder,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text('Where will you stay?',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.textHeading)),
              SizedBox(height: 4.h),
              Text('Near ${trip.location}',
                  style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
              SizedBox(height: 20.h),
              ...options.map((opt) {
                final picked = current?['name'] == opt['name'];
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedStays[trip.id] = Map<String, dynamic>.from(opt));
                    Navigator.pop(ctx);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: picked ? AppColors.primary : Colors.transparent,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: CachedNetworkImage(
                            imageUrl: opt['image'] as String,
                            width: 60.w, height: 60.w, fit: BoxFit.cover,
                            placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                            errorWidget: (_, __, ___) => Container(color: AppColors.shimmerBase),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(opt['name'] as String,
                                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textHeading)),
                              SizedBox(height: 4.h),
                              Text(opt['location'] as String,
                                  style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('\$${(opt['price'] as double).toStringAsFixed(0)}',
                                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            Text('per night',
                                style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary)),
                          ],
                        ),
                        if (picked) ...[
                          SizedBox(width: 10.w),
                          Icon(Icons.check_circle, size: 20.w, color: AppColors.primary),
                        ],
                      ],
                    ),
                  ),
                );
              }),
              if (current != null)
                Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() => _selectedStays.remove(trip.id));
                      Navigator.pop(ctx);
                    },
                    child: Text('Remove stay',
                        style: TextStyle(fontSize: 13.sp, color: AppColors.error, fontWeight: FontWeight.w600)),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  void _confirmPayment(BuildContext context, double total) {
    String? method;
    final methods = [
      {'id': 'momo', 'label': 'MTN Mobile Money', 'icon': Icons.phone_android},
      {'id': 'airtel', 'label': 'Airtel Money', 'icon': Icons.phone_android},
      {'id': 'card', 'label': 'Credit / Debit Card', 'icon': Icons.credit_card},
      {'id': 'cash', 'label': 'Pay on Arrival', 'icon': Icons.payments_outlined},
    ];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
      builder: (_) => StatefulBuilder(builder: (ctx, setSheet) {
        return Container(
          padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 36.h),
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceBorder,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text('How would you like to pay?',
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.textHeading)),
              SizedBox(height: 4.h),
              Text('Total to pay: \$${total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 14.sp, color: AppColors.primary, fontWeight: FontWeight.w600)),
              SizedBox(height: 24.h),
              ...methods.map((m) {
                final selected = method == m['id'];
                return GestureDetector(
                  onTap: () => setSheet(() => method = m['id'] as String),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.only(bottom: 12.h),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: selected ? AppColors.primary : Colors.transparent,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(m['icon'] as IconData,
                            size: 22.w,
                            color: selected ? AppColors.primary : AppColors.textSecondary),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Text(m['label'] as String,
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  color: AppColors.textHeading,
                                  fontWeight: selected ? FontWeight.bold : FontWeight.w500)),
                        ),
                        if (selected)
                          Icon(Icons.check_circle, size: 20.w, color: AppColors.primary),
                      ],
                    ),
                  ),
                );
              }),
              SizedBox(height: 12.h),
              GestureDetector(
                onTap: method == null ? null : () {
                  Navigator.pop(ctx);
                  _showSuccessDialog();
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  decoration: BoxDecoration(
                    color: method != null ? AppColors.primary : AppColors.textDisabled,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: method != null ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      )
                    ] : null,
                  ),
                  alignment: Alignment.center,
                  child: Text('Confirm Booking',
                      style: TextStyle(
                          color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle_rounded, size: 60.w, color: AppColors.primary),
              ),
              SizedBox(height: 20.h),
              Text('Booking Successful!',
                  style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: AppColors.textHeading)),
              SizedBox(height: 8.h),
              Text(
                'Your trip has been successfully booked. You can view your itinerary in your profile.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary, height: 1.5),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx); // Close dialog
                    context.go('/'); // Back to home
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                    elevation: 0,
                  ),
                  child: Text('Great!', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trips = context.watch<TripsProvider>().selectedTrips;
    final total = _total(trips);
    final top = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // ── Header ──────────────────────────────────────────
            Container(
              color: AppColors.background,
              padding: EdgeInsets.only(top: top + 10.h, left: 8.w, right: 20.w, bottom: 12.h),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    iconSize: 20.w,
                    color: AppColors.textHeading,
                  ),
                  Text('Checkout',
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textHeading)),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 120.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Destinations ───────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Your destinations',
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textHeading)),
                        Text('${trips.length} items',
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    ...trips.map((t) => _DestRow(
                          trip: t,
                          stay: _selectedStays[t.id],
                          hasOptions: (_stayOptions[t.province] ?? []).isNotEmpty,
                          onPickStay: () => _pickStay(t),
                        )),

                    SizedBox(height: 24.h),

                    // ── Tour guide ─────────────────────────────
                    Text('Additional Services',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textHeading)),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: AppColors.primarySoft,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Icon(Icons.hiking, size: 22.w, color: AppColors.primary),
                          ),
                          SizedBox(width: 14.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Local Tour Guide',
                                    style: TextStyle(
                                        fontSize: 15.sp, fontWeight: FontWeight.bold, color: AppColors.textHeading)),
                                SizedBox(height: 2.h),
                                Text('\$${_guideFee.toStringAsFixed(0)} · Expert guidance',
                                    style: TextStyle(
                                        fontSize: 12.sp, color: AppColors.textSecondary)),
                              ],
                            ),
                          ),
                          Switch.adaptive(
                            value: _wantsGuide,
                            onChanged: (v) => setState(() => _wantsGuide = v),
                            activeColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // ── Price Summary ──────────────────────────
                    Text('Price Summary',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textHeading)),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        children: [
                          _PriceRow(label: 'Destinations', value: '\$${trips.fold(0.0, (s, t) => s + (double.tryParse(t.price.replaceAll(r"$", "")) ?? 0)).toStringAsFixed(0)}'),
                          if (_selectedStays.isNotEmpty)
                            _PriceRow(label: 'Accommodations', value: '\$${_selectedStays.values.fold(0.0, (s, m) => s + (m['price'] as double)).toStringAsFixed(0)}'),
                          if (_wantsGuide)
                            _PriceRow(label: 'Tour Guide', value: '\$${_guideFee.toStringAsFixed(0)}'),
                          Divider(height: 24.h, color: AppColors.surfaceBorder),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Amount',
                                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.textHeading)),
                              Text('\$${total.toStringAsFixed(2)}',
                                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: AppColors.primary)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // ── Confirm button ───────────────────────────────────
        bottomNavigationBar: Container(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: GestureDetector(
            onTap: () => _confirmPayment(context, total),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text('Book My Trip Now',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;

  const _PriceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
          Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textHeading)),
        ],
      ),
    );
  }
}

class _DestRow extends StatelessWidget {
  final TripItem trip;
  final Map<String, dynamic>? stay;
  final bool hasOptions;
  final VoidCallback onPickStay;

  const _DestRow({
    required this.trip,
    required this.stay,
    required this.hasOptions,
    required this.onPickStay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CachedNetworkImage(
                    imageUrl: trip.image,
                    width: 56.w, height: 56.w, fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                    errorWidget: (_, __, ___) => Container(color: AppColors.shimmerBase, child: Icon(Icons.image, color: Colors.grey, size: 20.w)),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trip.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textHeading)),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 12.w, color: AppColors.primary),
                          SizedBox(width: 4.w),
                          Text(trip.location,
                              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                        ],
                      ),
                    ],
                  ),
                ),
                Text(trip.price,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary)),
              ],
            ),
          ),
          if (hasOptions) ...[
            Divider(height: 1, color: AppColors.surfaceBorder, indent: 12.w, endIndent: 12.w),
            GestureDetector(
              onTap: onPickStay,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                color: Colors.transparent,
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: stay != null ? AppColors.primarySoft : AppColors.background,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.hotel_rounded,
                          size: 14.w,
                          color: stay != null ? AppColors.primary : AppColors.textSecondary),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stay != null ? stay!['name'] as String : 'Add accommodation',
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: stay != null ? AppColors.textHeading : AppColors.textSecondary,
                              fontWeight: stay != null ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                          if (stay != null)
                            Text('\$${(stay!['price'] as double).toStringAsFixed(0)}/night · ${stay!['location']}',
                                style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    if (stay == null)
                      Text('Pick hotel',
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600)),
                    SizedBox(width: 4.w),
                    Icon(Icons.chevron_right_rounded, size: 18.w, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
