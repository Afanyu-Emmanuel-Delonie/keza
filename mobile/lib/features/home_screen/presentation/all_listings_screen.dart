import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/animated_card_item.dart';
import '../../../core/utils/trip_snackbar.dart';
import '../../../shared/widgets/Categories.dart';
import '../../trips/providers/trips_provider.dart';
import '../../trips/presentation/booking_form_sheet.dart';
import 'AccommodationDetails.dart';
import 'DestinationDetails.dart';

// ── All Destinations ──────────────────────────────────────────────────────────
class AllDestinationsScreen extends StatefulWidget {
  const AllDestinationsScreen({super.key});

  @override
  State<AllDestinationsScreen> createState() => _AllDestinationsScreenState();
}

class _AllDestinationsScreenState extends State<AllDestinationsScreen> {
  String _selectedCategory = 'all';
  String _query = '';

  List<Map<String, String>> get _filtered {
    var list = List<Map<String, String>>.from(AppConstants.topDestinations);
    if (_selectedCategory != 'all') {
      final kw = AppConstants.categoryKeywords[_selectedCategory] ?? [];
      if (kw.isNotEmpty) {
        list = list.where((d) {
          final text = '${d['name']!} ${d['location']!}'.toLowerCase();
          return kw.any((k) => text.contains(k));
        }).toList();
      }
    }
    if (_query.isNotEmpty) {
      final q = _query.toLowerCase();
      list = list
          .where((d) =>
              d['name']!.toLowerCase().contains(q) ||
              d['location']!.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  static String _inferProvince(String location) => AppConstants.inferProvince(location);

  @override
  Widget build(BuildContext context) {
    final destinations = _filtered;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ListingAppBar(title: 'Top Destinations', count: destinations.length),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
              child: _SearchField(onChanged: (v) => setState(() => _query = v)),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 14.h, 0, 0),
              child: CategoriesSection(
                categories: AppConstants.categories
                    .where((c) => c['id'] != 'accommodation')
                    .toList(),
                onCategorySelected: (cat) =>
                    setState(() => _selectedCategory = cat['id'] as String),
              ),
            ),
            SizedBox(height: 14.h),
            Expanded(
              child: destinations.isEmpty
                  ? _Empty(label: 'No destinations found')
                  : Consumer<TripsProvider>(
                      builder: (context, provider, _) => ListView.builder(
                        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                        itemCount: destinations.length,
                        itemBuilder: (_, i) {
                          final dest = destinations[i];
                          final item = TripItem(
                            id: 'dest_${dest['name']!.replaceAll(' ', '_').toLowerCase()}',
                            name: dest['name']!,
                            location: dest['location']!,
                            province: _inferProvince(dest['location']!),
                            image: dest['image']!,
                            price: dest['price'] ?? 'Free',
                            rating: dest['rating'] ?? '4.5',
                          );
                          final isAdded = provider.isAdded(item.id);
                          final isLiked = provider.isFavourite(item.id);
                          return _DestinationCard(
                            dest: dest,
                            item: item,
                            isAdded: isAdded,
                            isLiked: isLiked,
                            onLike: () => provider.toggleFavourite(item),
                            onAddTrip: () {
                              provider.toggleAddTrip(item);
                              if (!isAdded) showAddedToTripSnackbar(context, dest['name']!);
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DestinationCard extends StatelessWidget {
  final Map<String, String> dest;
  final TripItem item;
  final bool isAdded;
  final bool isLiked;
  final VoidCallback onLike;
  final VoidCallback onAddTrip;

  const _DestinationCard({
    required this.dest,
    required this.item,
    required this.isAdded,
    required this.isLiked,
    required this.onLike,
    required this.onAddTrip,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        SmoothPageRoute(
          page: DestinationDetails(
            title: dest['name']!,
            location: dest['location']!,
            images: [dest['image']!],
            price: dest['price'],
            rating: dest['rating'],
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                bottomLeft: Radius.circular(16.r),
              ),
              child: CachedNetworkImage(
                imageUrl: dest['image']!,
                width: 100.w,
                height: 100.w,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                errorWidget: (_, __, ___) => Container(color: AppColors.shimmerBase),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dest['name']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textHeading)),
                    SizedBox(height: 3.h),
                    Row(children: [
                      Icon(Icons.location_on, size: 11.w, color: AppColors.primary),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(dest['location']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
                      ),
                    ]),
                    SizedBox(height: 6.h),
                    Row(children: [
                      Icon(Icons.star_rounded, color: Colors.amber, size: 13.w),
                      SizedBox(width: 3.w),
                      Text(dest['rating']!,
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textHeading)),
                      const Spacer(),
                      Text(dest['price']!,
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: AppColors.primary)),
                    ]),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _IconBtn(
                    icon: isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                    color: isLiked ? AppColors.error : AppColors.textSecondary,
                    bg: isLiked ? AppColors.errorSoft : AppColors.surfaceBorder.withOpacity(0.5),
                    onTap: onLike,
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: onAddTrip,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: isAdded ? AppColors.primarySoft : AppColors.primary,
                        borderRadius: BorderRadius.circular(8.r),
                        border: isAdded ? Border.all(color: AppColors.primary) : null,
                      ),
                      child: Text(
                        isAdded ? '✓' : '+ Trip',
                        style: TextStyle(
                            color: isAdded ? AppColors.primary : Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── All Stays ─────────────────────────────────────────────────────────────────
class AllStaysScreen extends StatefulWidget {
  const AllStaysScreen({super.key});

  @override
  State<AllStaysScreen> createState() => _AllStaysScreenState();
}

class _AllStaysScreenState extends State<AllStaysScreen> {
  String _query = '';

  static const _allStays = AppConstants.allStays;

  List<Map<String, String>> get _filtered {
    if (_query.isEmpty) return List.from(_allStays);
    final q = _query.toLowerCase();
    return _allStays
        .where((s) =>
            s['name']!.toLowerCase().contains(q) ||
            s['location']!.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final stays = _filtered;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ListingAppBar(title: 'All Stays', count: stays.length),
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 14.h),
              child: _SearchField(
                  onChanged: (v) => setState(() => _query = v),
                  hint: 'Search stays...'),
            ),
            Expanded(
              child: stays.isEmpty
                  ? _Empty(label: 'No stays found')
                  : Consumer<TripsProvider>(
                      builder: (context, provider, _) => ListView.builder(
                        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 24.h),
                        itemCount: stays.length,
                        itemBuilder: (_, i) {
                          final stay = stays[i];
                          final tripItem = TripItem(
                            id: stay['id']!,
                            name: stay['name']!,
                            location: stay['location']!,
                            province: stay['province']!,
                            image: stay['image']!,
                            price: stay['price']!,
                            rating: stay['rating']!,
                            isAccommodation: true,
                          );
                          final liked = provider.isAccommodationLiked(tripItem.id);
                          final booked = provider.isAccommodationSelected(tripItem.id);
                          return _StayCard(
                            stay: stay,
                            tripItem: tripItem,
                            liked: liked,
                            booked: booked,
                            onLike: () => provider.toggleLikeAccommodation(tripItem),
                            onBook: () async {
                              if (booked) {
                                provider.cancelAccommodationBooking(tripItem.province);
                              } else {
                                final booking = await BookingFormSheet.show(context, tripItem);
                                if (booking != null) {
                                  provider.confirmAccommodationBooking(booking);
                                  if (context.mounted) {
                                    showTopSnackbar(context, '${stay['name']!} booked!',
                                        icon: Icons.hotel_rounded);
                                  }
                                }
                              }
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StayCard extends StatelessWidget {
  final Map<String, String> stay;
  final TripItem tripItem;
  final bool liked;
  final bool booked;
  final VoidCallback onLike;
  final VoidCallback onBook;

  const _StayCard({
    required this.stay,
    required this.tripItem,
    required this.liked,
    required this.booked,
    required this.onLike,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        SmoothPageRoute(
          page: AccommodationDetails(
            title: stay['name']!,
            location: stay['location']!,
            images: [stay['image']!],
            price: stay['price'],
            rating: stay['rating'],
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                bottomLeft: Radius.circular(16.r),
              ),
              child: CachedNetworkImage(
                imageUrl: stay['image']!,
                width: 100.w,
                height: 100.w,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                errorWidget: (_, __, ___) => Container(color: AppColors.shimmerBase),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stay['name']!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textHeading)),
                    SizedBox(height: 3.h),
                    Row(children: [
                      Icon(Icons.location_on, size: 11.w, color: AppColors.primary),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(stay['location']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
                      ),
                    ]),
                    SizedBox(height: 5.h),
                    Row(children: [
                      Icon(Icons.star_rounded, color: Colors.amber, size: 13.w),
                      SizedBox(width: 3.w),
                      Text(stay['rating']!,
                          style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600, color: AppColors.textHeading)),
                      SizedBox(width: 4.w),
                      Text('(${stay['reviews']} reviews)',
                          style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary)),
                    ]),
                    SizedBox(height: 4.h),
                    Text(stay['price']!,
                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: AppColors.primary)),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _IconBtn(
                    icon: liked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                    color: liked ? AppColors.error : AppColors.textSecondary,
                    bg: liked ? AppColors.errorSoft : AppColors.surfaceBorder.withOpacity(0.5),
                    onTap: onLike,
                  ),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: onBook,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                      decoration: BoxDecoration(
                        color: booked ? AppColors.errorSoft : AppColors.primary,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        booked ? 'Cancel' : '+ Book',
                        style: TextStyle(
                            color: booked ? AppColors.error : Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared ────────────────────────────────────────────────────────────────────
class _ListingAppBar extends StatelessWidget {
  final String title;
  final int count;
  const _ListingAppBar({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(8.w, 8.h, 16.w, 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 40.w,
              height: 40.w,
              margin: EdgeInsets.only(left: 8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2)),
                ],
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded, size: 16.w, color: AppColors.textHeading),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.bold, color: AppColors.textHeading)),
                Text('$count results',
                    style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final ValueChanged<String> onChanged;
  final String hint;
  const _SearchField({required this.onChanged, this.hint = 'Search destinations...'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.search_rounded, size: 20.w, color: AppColors.textSecondary),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              onChanged: onChanged,
              style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color bg;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.color, required this.bg, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, size: 16.w, color: color),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  final String label;
  const _Empty({required this.label});

  @override
  Widget build(BuildContext context) => Center(
        child: Text(label,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
      );
}
