import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/trips_provider.dart';
import 'booking_form_sheet.dart';
import 'itinerary_summary_sheet.dart';
import 'payment_sheet.dart';

// ── Static accommodation data grouped by province ────────────────────────────
// isAvailable: false means rooms are sold out
const _kAccommodations = {
  'Kigali City': [
    {
      'name': 'Kigali Serena Hotel',
      'location': 'Kiyovu, Kigali',
      'price': '\$180/night',
      'rating': '4.9',
      'available': 'true',
      'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=400&fit=crop',
    },
    {
      'name': 'Radisson Blu Kigali',
      'location': 'Gasabo, Kigali',
      'price': '\$150/night',
      'rating': '4.7',
      'available': 'false',
      'image': 'https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=400&fit=crop',
    },
    {
      'name': 'Nyandungu Eco Lodge',
      'location': 'Nyarugunga, Kigali',
      'price': '\$95/night',
      'rating': '4.5',
      'available': 'true',
      'image': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=400&fit=crop',
    },
  ],
  'Northern Province': [
    {
      'name': 'Gorilla Nest Lodge',
      'location': 'Kinigi, Musanze',
      'price': '\$200/night',
      'rating': '4.9',
      'available': 'true',
      'image': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=400&fit=crop',
    },
    {
      'name': 'Luxury Green Villa',
      'location': 'Musanze',
      'price': '\$120/night',
      'rating': '4.8',
      'available': 'false',
      'image': 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?q=80&w=400&fit=crop',
    },
  ],
  'Eastern Province': [
    {
      'name': 'Akagera Game Lodge',
      'location': 'Kayonza',
      'price': '\$95/night',
      'rating': '4.6',
      'available': 'true',
      'image': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?q=80&w=400&fit=crop',
    },
  ],
  'Western Province': [
    {
      'name': 'Lake Kivu Serena',
      'location': 'Rubavu',
      'price': '\$150/night',
      'rating': '4.8',
      'available': 'true',
      'image': 'https://images.unsplash.com/photo-1540541338287-41700207dee6?q=80&w=400&fit=crop',
    },
  ],
  'Southern Province': [
    {
      'name': 'Huye Mountain Hotel',
      'location': 'Huye',
      'price': '\$80/night',
      'rating': '4.4',
      'available': 'true',
      'image': 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?q=80&w=400&fit=crop',
    },
  ],
};

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  DateTime? _arrivalDate;
  String _selectedProvince = 'Kigali City';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
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
    if (picked != null) setState(() => _arrivalDate = picked);
  }

  void _openItinerary(BuildContext context) {
    final provider = context.read<TripsProvider>();
    ItinerarySummarySheet.show(
      context,
      destinations: provider.addedTrips,
      bookings: provider.allBookings,
      totalCost: provider.totalAccommodationCost + provider.totalTripCost,
      serviceFee: provider.serviceFee,
      grandTotal: provider.grandTotal,
      onConfirm: () => PaymentSheet.show(
        context,
        total: provider.grandTotal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TripsProvider>();
    final trips = provider.addedTrips;
    final top = MediaQuery.of(context).padding.top;
    final hasBookings = provider.allBookings.isNotEmpty;

    // Provinces that have trips added, always include Kigali City first
    final tripProvinces = trips.map((t) => t.province).toSet();
    final allProvinces = {'Kigali City', ...tripProvinces}.toList();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // ── Header ──
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
                  Text(
                    'Plan My Trip',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHeading,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 40.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Places to Visit card ──
                    _PlacesCard(trips: trips),
                    SizedBox(height: 20.h),

                    // ── Arrival date ──
                    _ArrivalDateCard(date: _arrivalDate, onTap: _pickDate),

                    // ── Accommodations (shown after date is picked) ──
                    if (_arrivalDate != null) ...[
                      SizedBox(height: 28.h),

                      // ── Confirmed stays section ──
                      _ConfirmedStaysSection(
                        provinces: allProvinces,
                        onEdit: (province) => setState(() => _selectedProvince = province),
                      ),

                                      SizedBox(height: 24.h),
                      Text(
                        'Where to Stay',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textHeading,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Select a city to browse options',
                        style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                      ),
                      SizedBox(height: 14.h),

                      // ── Province selector row ──
                      SizedBox(
                        height: 34.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: allProvinces.length,
                          separatorBuilder: (_, __) => SizedBox(width: 8.w),
                          itemBuilder: (_, i) {
                            final p = allProvinces[i];
                            final active = p == _selectedProvince;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedProvince = p),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 180),
                                padding: EdgeInsets.symmetric(horizontal: 14.w),
                                decoration: BoxDecoration(
                                  color: active ? AppColors.primary : AppColors.surface,
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: active ? AppColors.primary : AppColors.surfaceBorder,
                                  ),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  p == 'Kigali City' ? 'Kigali' : p.replaceAll(' Province', ''),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: active ? Colors.white : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // ── Horizontal card row for selected province ──
                      Builder(builder: (context) {
                        final options = _kAccommodations[_selectedProvince] ?? [];
                        if (options.isEmpty) return const SizedBox.shrink();
                        return _AccommodationRow(
                          province: _selectedProvince,
                          isArrival: _selectedProvince == 'Kigali City',
                          options: options,
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ),

            // ── Bottom checkout bar (visible once at least one accommodation is booked) ──
            if (hasBookings)
              _CheckoutFooter(
                total: provider.totalAccommodationCost + provider.totalTripCost,
                onTap: () => _openItinerary(context),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Places to Visit expandable card ─────────────────────────────────────────
class _PlacesCard extends StatefulWidget {
  final List<TripItem> trips;
  const _PlacesCard({required this.trips});

  @override
  State<_PlacesCard> createState() => _PlacesCardState();
}

class _PlacesCardState extends State<_PlacesCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late final AnimationController _ctrl;
  late final Animation<double> _rotate;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _rotate = Tween<double>(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  // Group trips by province, Kigali first
  Map<String, List<TripItem>> get _grouped {
    final map = <String, List<TripItem>>{};
    for (final t in widget.trips) {
      map.putIfAbsent(t.province, () => []).add(t);
    }
    // Sort so Kigali City is first
    final sorted = <String, List<TripItem>>{};
    if (map.containsKey('Kigali City')) sorted['Kigali City'] = map['Kigali City']!;
    for (final k in map.keys) {
      if (k != 'Kigali City') sorted[k] = map[k]!;
    }
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _grouped;
    final totalCount = widget.trips.length;
    final allImages = widget.trips.map((t) => t.image).toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          // ── Header ──
          GestureDetector(
            onTap: _toggle,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(7.w),
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(Icons.map_outlined, size: 16.w, color: AppColors.primary),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Places to Visit',
                            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textHeading)),
                        Text('$totalCount destination${totalCount == 1 ? '' : 's'}',
                            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  RotationTransition(
                    turns: _rotate,
                    child: Icon(Icons.keyboard_arrow_down_rounded, size: 22.w, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),

          // ── Collapsed: thumbnail strip ──
          if (!_expanded && allImages.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 14.h),
              child: Row(
                children: allImages.take(4).toList().asMap().entries.map((e) {
                  final i = e.key;
                  final isOverflow = i == 3 && allImages.length > 4;
                  return Container(
                    margin: EdgeInsets.only(right: 6.w),
                    width: 52.w,
                    height: 52.w,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: e.value,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                            errorWidget: (_, __, ___) => Container(color: AppColors.shimmerBase),
                          ),
                          if (isOverflow)
                            Container(
                              color: Colors.black.withOpacity(0.5),
                              alignment: Alignment.center,
                              child: Text('+${allImages.length - 3}',
                                  style: TextStyle(color: Colors.white, fontSize: 13.sp, fontWeight: FontWeight.bold)),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // ── Expanded: grouped by province ──
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _expanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: grouped.isEmpty
                ? Padding(
                    padding: EdgeInsets.only(bottom: 16.h),
                    child: Text('No destinations added yet',
                        style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                  )
                : Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: grouped.entries.map((entry) {
                        final province = entry.key;
                        final items = entry.value;
                        final isKigali = province == 'Kigali City';
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 12.h),
                            Row(
                              children: [
                                Text(
                                  province,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                if (isKigali) ...[
                                  SizedBox(width: 6.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.primarySoft,
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Text('Arrival',
                                        style: TextStyle(fontSize: 9.sp, color: AppColors.primary, fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 8.h),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8.w,
                                mainAxisSpacing: 8.w,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (_, i) {
                                final t = items[i];
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(12.r),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl: t.image,
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                                        errorWidget: (_, __, ___) => Container(color: AppColors.shimmerBase),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [Colors.transparent, Colors.black.withOpacity(0.65)],
                                            stops: const [0.5, 1.0],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 6.h, left: 6.w, right: 6.w,
                                        child: Text(t.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.w600)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ── Arrival date card ────────────────────────────────────────────────────────
class _ArrivalDateCard extends StatelessWidget {
  final DateTime? date;
  final VoidCallback onTap;
  const _ArrivalDateCard({required this.date, required this.onTap});

  String get _label {
    if (date == null) return 'Select your arrival date';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date!.day} ${months[date!.month - 1]} ${date!.year}';
  }

  @override
  Widget build(BuildContext context) {
    final hasDate = date != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: hasDate ? AppColors.primary : AppColors.surfaceBorder,
            width: hasDate ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(9.w),
              decoration: BoxDecoration(
                color: hasDate ? AppColors.primarySoft : AppColors.background,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.calendar_today_rounded, size: 16.w,
                  color: hasDate ? AppColors.primary : AppColors.textSecondary),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Arrival Date', style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                  SizedBox(height: 2.h),
                  Text(_label,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: hasDate ? AppColors.textHeading : AppColors.textDisabled,
                      )),
                ],
              ),
            ),
            Icon(
              hasDate ? Icons.edit_calendar_rounded : Icons.chevron_right_rounded,
              size: 18.w,
              color: hasDate ? AppColors.primary : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Confirmed stays section ──────────────────────────────────────────────────
class _ConfirmedStaysSection extends StatelessWidget {
  final List<String> provinces;
  final void Function(String province) onEdit;

  const _ConfirmedStaysSection({required this.provinces, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Consumer<TripsProvider>(
      builder: (context, provider, _) {
        final bookings = provider.allBookings;
        if (bookings.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Confirmed Stays',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.textHeading),
            ),
            SizedBox(height: 12.h),
            ...bookings.values.map((b) {
              final nights = b.nights;
              final total = b.totalCost;
              return Container(
                margin: EdgeInsets.only(bottom: 10.h),
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: AppColors.primary.withOpacity(0.25)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3)),
                  ],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.r),
                      child: CachedNetworkImage(
                        imageUrl: b.item.image,
                        width: 56.w,
                        height: 56.w,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                        errorWidget: (_, __, ___) => Container(color: AppColors.shimmerBase),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(b.item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: AppColors.textHeading)),
                          SizedBox(height: 3.h),
                          Text(b.item.province,
                              style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primarySoft,
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                                child: Text(
                                  '$nights night${nights == 1 ? '' : 's'}',
                                  style: TextStyle(fontSize: 10.sp, color: AppColors.primary, fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '\$${total.toStringAsFixed(0)}',
                                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    GestureDetector(
                      onTap: () {
                        provider.cancelAccommodationBooking(b.item.province);
                        onEdit(b.item.province);
                      },
                      child: Container(
                        padding: EdgeInsets.all(7.w),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(Icons.edit_outlined, size: 15.w, color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: 8.h),
          ],
        );
      },
    );
  }
}

// ── Horizontal accommodation row for a province ──────────────────────────────
class _AccommodationRow extends StatelessWidget {
  final String province;
  final bool isArrival;
  final List<Map<String, String>> options;

  const _AccommodationRow({
    required this.province,
    required this.isArrival,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<TripsProvider>(
      builder: (context, provider, _) {
        final selected = provider.selectedAccommodationForProvince(province);
        return SizedBox(
          height: 220.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: options.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (_, i) {
              final opt = options[i];
              final id = '${province}_${opt['name']}';
              final item = TripItem(
                id: id,
                name: opt['name']!,
                location: opt['location']!,
                province: province,
                image: opt['image']!,
                price: opt['price']!,
                rating: opt['rating']!,
                isAccommodation: true,
              );
              return _AccommodationCard(
                option: opt,
                item: item,
                isSelected: selected?.id == id,
                isLiked: provider.isAccommodationLiked(id),
                onLike: () => provider.toggleLikeAccommodation(item),
                onSelect: () => provider.toggleSelectAccommodation(item),
              );
            },
          ),
        );
      },
    );
  }
}

// ── Checkout footer bar ─────────────────────────────────────────────────────
class _CheckoutFooter extends StatelessWidget {
  final double total;
  final VoidCallback onTap;

  const _CheckoutFooter({required this.total, required this.onTap});

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
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total',
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
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
          Expanded(
            child: GestureDetector(
              onTap: onTap,
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
                  'Review Itinerary',
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

// ── Single accommodation card (vertical layout for horizontal list) ──────────
class _AccommodationCard extends StatelessWidget {
  final Map<String, String> option;
  final TripItem item;
  final bool isSelected;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onSelect;

  const _AccommodationCard({
    required this.option,
    required this.item,
    required this.isSelected,
    required this.isLiked,
    required this.onLike,
    required this.onSelect,
  });

  bool get _available => option['available'] != 'false';

  Future<void> _openBookingForm(BuildContext context) async {
    if (!_available) return;
    final provider = context.read<TripsProvider>();
    final booking = await BookingFormSheet.show(context, item);
    if (booking != null) provider.confirmAccommodationBooking(booking);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openBookingForm(context),
      child: Opacity(
        opacity: _available ? 1.0 : 0.5,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 160.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isSelected ? AppColors.primary.withOpacity(0.12) : Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image ──
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.r),
                      topRight: Radius.circular(16.r),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: option['image']!,
                      width: 160.w,
                      height: 100.h,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                      errorWidget: (_, __, ___) => Container(color: AppColors.shimmerBase),
                    ),
                  ),
                  // ── Unavailable badge ──
                  if (!_available)
                    Positioned(
                      top: 8.h,
                      left: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.65),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'Unavailable',
                          style: TextStyle(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  // ── Heart button ──
                  Positioned(
                    top: 8.h,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: onLike,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                          color: isLiked ? AppColors.errorSoft : Colors.white.withOpacity(0.85),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                          size: 13.w,
                          color: isLiked ? AppColors.error : AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // ── Info ──
              Padding(
                padding: EdgeInsets.fromLTRB(10.w, 8.h, 10.w, 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(option['name']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: AppColors.textHeading)),
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 10.w, color: AppColors.textSecondary),
                        SizedBox(width: 2.w),
                        Expanded(
                          child: Text(option['location']!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary)),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, color: Colors.amber, size: 11.w),
                        SizedBox(width: 2.w),
                        Text(option['rating']!,
                            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.textHeading)),
                        const Spacer(),
                        Text(option['price']!,
                            style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    // ── Book button ──
                    GestureDetector(
                      onTap: _available
                          ? (isSelected ? onSelect : () => _openBookingForm(context))
                          : null,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 7.h),
                        decoration: BoxDecoration(
                          color: !_available
                              ? AppColors.surfaceBorder
                              : isSelected
                                  ? AppColors.errorSoft
                                  : AppColors.primary,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          !_available ? 'Unavailable' : isSelected ? 'Cancel' : '+ Book Stay',
                          style: TextStyle(
                            color: !_available
                                ? AppColors.textDisabled
                                : isSelected
                                    ? AppColors.error
                                    : Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
