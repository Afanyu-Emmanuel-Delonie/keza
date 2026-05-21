import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/trip_snackbar.dart';
import '../../../core/widgets/animated_card_item.dart';
import '../providers/trips_provider.dart';
import '../../home_screen/presentation/DestinationDetails.dart';

const _kMaxAvatars = 3;
const _kAvatarSize = 36.0;
const _kAvatarOverlap = 22.0;

class MyTripTab extends StatefulWidget {
  const MyTripTab({super.key});

  @override
  State<MyTripTab> createState() => _MyTripTabState();
}

class _MyTripTabState extends State<MyTripTab>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {

  late final AnimationController _barCtrl;
  late final AnimationController _pillCtrl;

  late final Animation<double> _barSlide;
  late final Animation<double> _barFade;
  late final Animation<double> _leftSlide;
  late final Animation<double> _rightSlide;
  late final Animation<double> _labelFade;

  int _prevCount = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    _barCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 380));
    _barSlide = CurvedAnimation(parent: _barCtrl, curve: Curves.easeOutCubic);
    _barFade  = CurvedAnimation(parent: _barCtrl, curve: Curves.easeIn);

    _pillCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 480));
    _leftSlide  = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _pillCtrl, curve: Curves.easeOutBack),
    );
    _rightSlide = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _pillCtrl, curve: Curves.easeOutBack),
    );
    _labelFade = CurvedAnimation(parent: _pillCtrl, curve: const Interval(0.4, 1.0, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _barCtrl.dispose();
    _pillCtrl.dispose();
    super.dispose();
  }

  void _onCountChanged(int newCount) {
    if (newCount > 0 && _prevCount == 0) {
      HapticFeedback.mediumImpact();
      _barCtrl.forward();
      _pillCtrl.forward();
    } else if (newCount == 0 && _prevCount > 0) {
      _barCtrl.reverse();
      _pillCtrl.reverse();
    } else if (newCount > _prevCount) {
      HapticFeedback.lightImpact();
      _pillCtrl.forward(from: 0.65);
    }
    _prevCount = newCount;
  }

  void _bookWithAI(BuildContext context, List<TripItem> selected) {
    final provider = context.read<TripsProvider>();
    final now = DateTime.now();
    final provinces = selected.map((t) => t.province).toSet();
    for (final province in provinces) {
      final item = TripItem(
        id: 'ai_accom_${province.replaceAll(' ', '_').toLowerCase()}',
        name: 'AI Selected Stay · $province',
        location: province,
        province: province,
        image: selected.firstWhere((t) => t.province == province).image,
        price: '\$120/night',
        rating: '4.7',
        isAccommodation: true,
      );
      provider.confirmAccommodationBooking(AccommodationBooking(
        item: item,
        checkIn: now.add(const Duration(days: 7)),
        checkOut: now.add(const Duration(days: 10)),
        guests: 2,
        roomType: 'Deluxe',
        notes: 'AI suggested booking',
      ));
    }
    showTopSnackbar(
      context,
      'AI booked stays for ${provinces.length} destination${provinces.length > 1 ? 's' : ''}!',
      icon: Icons.auto_awesome_rounded,
    );
    context.push('/plan');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<TripsProvider>(
      builder: (context, provider, _) {
        final count    = provider.selectedTrips.length;
        final selected = provider.selectedTrips;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (count != _prevCount) _onCountChanged(count);
        });

        if (provider.addedTrips.isEmpty) {
          return const _EmptyState(
            icon: Icons.map_outlined,
            message: 'Your trip is empty',
            sub: 'Add destinations from the explore page to start planning',
          );
        }

        final grouped   = provider.tripsByProvince;
        final provinces = grouped.keys.toList();

        return Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 120.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── AI banner ──
                  _AiBanner(
                    hasSelected: count > 0,
                    selectedCount: count,
                    totalCount: provider.addedTrips.length,
                    onAskAI: () => count > 0
                        ? _bookWithAI(context, selected)
                        : showTopSnackbar(context,
                            'Select destinations first, then tap Ask AI',
                            icon: Icons.info_outline_rounded),
                  ),
                  SizedBox(height: 20.h),

                  // ── Destination list grouped by province ──
                  ...List.generate(provinces.length, (pi) {
                    final province = provinces[pi];
                    final trips    = grouped[province]!;
                    return AnimatedCardItem(
                      index: pi,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _ProvinceHeader(province: province),
                          SizedBox(height: 10.h),
                          ...trips.map((trip) => _TripLineItem(
                                trip: trip,
                                onTap: () => Navigator.push(
                                  context,
                                  SmoothPageRoute(
                                    page: DestinationDetails(
                                      title: trip.name,
                                      location: trip.location,
                                      images: [trip.image],
                                      price: trip.price,
                                      rating: trip.rating,
                                    ),
                                  ),
                                ),
                              )),
                          SizedBox(height: 20.h),
                          const Divider(color: AppColors.surfaceBorder, height: 1),
                          SizedBox(height: 20.h),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            // ── Floating checkout pill ──
            Positioned(
              bottom: 0, left: 0, right: 0,
              child: AnimatedBuilder(
                animation: _barCtrl,
                builder: (_, __) => Transform.translate(
                  offset: Offset(0, (1 - _barSlide.value) * 110),
                  child: Opacity(
                    opacity: _barFade.value.clamp(0.0, 1.0),
                    child: _CheckoutBar(
                      selectedTrips: selected,
                      leftSlide: _leftSlide,
                      rightSlide: _rightSlide,
                      labelFade: _labelFade,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── AI banner ─────────────────────────────────────────────────────────────────
class _AiBanner extends StatelessWidget {
  final bool hasSelected;
  final int selectedCount;
  final int totalCount;
  final VoidCallback onAskAI;

  const _AiBanner({
    required this.hasSelected,
    required this.selectedCount,
    required this.totalCount,
    required this.onAskAI,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 20.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasSelected
                      ? '$selectedCount of $totalCount selected'
                      : 'Not sure where to go?',
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  hasSelected
                      ? 'Let AI book the best stays for your selected destinations'
                      : 'Tap a destination to select it, or ask AI to help plan your trip',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.white.withOpacity(0.85),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          GestureDetector(
            onTap: onAskAI,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'Ask AI',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDarker,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Checkout bar ──────────────────────────────────────────────────────────────
class _CheckoutBar extends StatelessWidget {
  final List<TripItem> selectedTrips;
  final Animation<double> leftSlide;
  final Animation<double> rightSlide;
  final Animation<double> labelFade;

  const _CheckoutBar({
    required this.selectedTrips,
    required this.leftSlide,
    required this.rightSlide,
    required this.labelFade,
  });

  @override
  Widget build(BuildContext context) {
    final count = selectedTrips.length;

    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () => context.push('/plan'),
        child: Container(
          height: 58.h,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.38),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: FadeTransition(
                  opacity: labelFade,
                  child: Text(
                    'Plan My Trip',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
              // Destination avatars slide in from left
              Positioned(
                left: 8.w, top: 0, bottom: 0,
                child: AnimatedBuilder(
                  animation: leftSlide,
                  builder: (_, __) => Transform.translate(
                    offset: Offset(leftSlide.value * 100.w, 0),
                    child: Center(child: _StackedAvatars(trips: selectedTrips)),
                  ),
                ),
              ),
              // Bag with count badge slides in from right
              Positioned(
                right: 8.w, top: 0, bottom: 0,
                child: AnimatedBuilder(
                  animation: rightSlide,
                  builder: (_, __) => Transform.translate(
                    offset: Offset(rightSlide.value * 100.w, 0),
                    child: Center(child: _BagBadge(count: count)),
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

// ── Stacked avatars ───────────────────────────────────────────────────────────
class _StackedAvatars extends StatelessWidget {
  final List<TripItem> trips;
  const _StackedAvatars({required this.trips});

  @override
  Widget build(BuildContext context) {
    final visible   = trips.take(_kMaxAvatars).toList();
    final overflow  = trips.length - _kMaxAvatars;
    final itemCount = visible.length + (overflow > 0 ? 1 : 0);
    final totalW    = _kAvatarSize + ((itemCount - 1) * _kAvatarOverlap);

    return SizedBox(
      width: totalW.w,
      height: _kAvatarSize.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ...List.generate(visible.length, (i) => Positioned(
            left: (i * _kAvatarOverlap).w,
            child: _Avatar(imageUrl: visible[i].image),
          )),
          if (overflow > 0)
            Positioned(
              left: (visible.length * _kAvatarOverlap).w,
              child: _OverflowChip(count: overflow),
            ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String imageUrl;
  const _Avatar({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _kAvatarSize.w,
      height: _kAvatarSize.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(color: AppColors.primaryDark),
          errorWidget: (_, __, ___) => Container(
            color: AppColors.primaryDark,
            child: const Icon(Icons.place, color: Colors.white, size: 14),
          ),
        ),
      ),
    );
  }
}

class _OverflowChip extends StatelessWidget {
  final int count;
  const _OverflowChip({required this.count});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
      child: Container(
        key: ValueKey(count),
        width: _kAvatarSize.w,
        height: _kAvatarSize.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.25),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Center(
          child: Text(
            '+$count',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _BagBadge extends StatelessWidget {
  final int count;
  const _BagBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.18),
          ),
          child: Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 22.w),
        ),
        Positioned(
          top: -3, right: -3,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 280),
            transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
            child: Container(
              key: ValueKey(count),
              constraints: BoxConstraints(minWidth: 18.w, minHeight: 18.w),
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: Center(
                child: Text(
                  '$count',
                  style: TextStyle(
                    color: AppColors.primaryDarker,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Trip line item ────────────────────────────────────────────────────────────
class _TripLineItem extends StatelessWidget {
  final TripItem trip;
  final VoidCallback onTap;

  const _TripLineItem({required this.trip, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<TripsProvider>(
      builder: (context, provider, _) {
        final selected = provider.isSelected(trip.id);

        return GestureDetector(
          onTap: () => provider.toggleSelected(trip.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.surfaceBorder, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                // Image morphs to circle on selection
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(selected ? 30.r : 10.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(selected ? 30.r : 10.r),
                    child: CachedNetworkImage(
                      imageUrl: trip.image,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.shimmerBase,
                        child: const Icon(Icons.broken_image, size: 20, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trip.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textHeading,
                        ),
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          Icon(Icons.location_on, size: 11.w, color: AppColors.textSecondary),
                          SizedBox(width: 2.w),
                          Text(
                            trip.location,
                            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        trip.price,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 26.w,
                  height: 26.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected ? AppColors.primary : Colors.transparent,
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.surfaceBorder,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 14.w,
                    color: selected ? Colors.white : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ── Province header ───────────────────────────────────────────────────────────
class _ProvinceHeader extends StatelessWidget {
  final String province;
  const _ProvinceHeader({required this.province});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(Icons.location_city_outlined, size: 16.w, color: AppColors.primary),
        ),
        SizedBox(width: 8.w),
        Text(
          province,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textHeading,
          ),
        ),
      ],
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String sub;

  const _EmptyState({required this.icon, required this.message, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56.w, color: AppColors.textDisabled),
            SizedBox(height: 16.h),
            Text(
              message,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              sub,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
