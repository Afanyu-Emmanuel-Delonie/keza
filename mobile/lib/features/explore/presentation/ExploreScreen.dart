import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/trip_snackbar.dart';
import '../../../core/widgets/animated_card_item.dart';
import '../../../shared/widgets/explore_item_card.dart';
import '../../../shared/widgets/explore_section_row.dart';
import '../../../shared/widgets/search.dart';
import '../../Destinations/presentation/destination_details/destination_details_screen.dart';
import '../../ai/presentation/trip_builder/ai_trip_builder_screen.dart';
import '../../notifications/presentation/notifications_page.dart';
import '../../trips/providers/trips_provider.dart';
import 'ProvincePlacesScreen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: top),

              const AnimatedCardItem(index: 0, child: _HomeHeader()),
              SizedBox(height: 20.h),
              const AnimatedCardItem(index: 1, child: CustomSearchBar()),
              SizedBox(height: 20.h),

              // ── AI Plan CTA ──
              AnimatedCardItem(
                index: 2,
                child: _AiPlanBanner(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AiTripBuilderScreen()),
                  ),
                ),
              ),
              SizedBox(height: 28.h),

              // ── Browse by Province ──
              AnimatedCardItem(
                index: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    'Browse by Province',
                    style: TextStyle(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textHeading,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              AnimatedCardItem(index: 4, child: const _ProvincesRow()),
              SizedBox(height: 28.h),

              // ── Destinations section ──
              AnimatedCardItem(
                index: 5,
                child: _DestinationsSection(searchQuery: _searchQuery),
              ),
              SizedBox(height: 28.h),

              // ── Places to Stay section ──
              AnimatedCardItem(
                index: 6,
                child: _StaysSection(searchQuery: _searchQuery),
              ),
              SizedBox(height: 28.h),

              // ── Things To Do section ──
              AnimatedCardItem(
                index: 7,
                child: _ThingsToDoSection(searchQuery: _searchQuery),
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}


// ── AI Plan banner ────────────────────────────────────────────────────────────
class _AiPlanBanner extends StatelessWidget {
  final VoidCallback onTap;
  const _AiPlanBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
          gradient: AppColors.aiGradient,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.30),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome_rounded, color: Colors.amber, size: 11.w),
                        SizedBox(width: 5.w),
                        Text(
                          'KEZA AI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Plan your Rwanda trip\nwith AI in minutes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Tell us your budget & interests AI books everything.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.80),
                      fontSize: 12.sp,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 14.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'Start',
                style: TextStyle(
                  color: AppColors.primaryDarker,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 22.r,
              backgroundColor: Colors.grey[200],
              backgroundImage: const AssetImage('assets/general/profile.png'),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 11.sp),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Afanyu Emmanuel',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                    color: AppColors.textHeading,
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationsPage()),
          ),
          icon: const Icon(Icons.notifications_none, size: 26),
        ),
      ],
    );
  }
}

// ── Provinces horizontal row ──────────────────────────────────────────────────
class _ProvincesRow extends StatelessWidget {
  const _ProvincesRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: EdgeInsets.only( right: 6.w),
        itemCount: AppConstants.provinces.length,
        itemBuilder: (context, i) {
          final province = AppConstants.provinces[i];
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              SmoothPageRoute(
                page: ProvincePlacesScreen(
                  provinceName: province['name'] as String,
                  destinations: List<Map<String, dynamic>>.from(
                      province['destinations'] as List),
                ),
              ),
            ),
            child: Container(
              width: 130.w,
              margin: EdgeInsets.only(right: 12.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                color: AppColors.shimmerBase,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: province['image'] as String,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                      errorWidget: (_, __, ___) => Container(color: AppColors.shimmerBase),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.80)],
                          stops: const [0.4, 1.0],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10.h,
                      left: 10.w,
                      right: 10.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            province['name'] as String,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            province['places_count'] as String,
                            style: TextStyle(color: Colors.white70, fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Destinations section ──────────────────────────────────────────────────────
class _DestinationsSection extends StatelessWidget {
  final String searchQuery;
  const _DestinationsSection({required this.searchQuery});

  List<Map<String, String>> get _items {
    if (searchQuery.isEmpty) return AppConstants.topDestinations;
    return AppConstants.topDestinations.where((d) {
      return d['name']!.toLowerCase().contains(searchQuery) ||
          d['location']!.toLowerCase().contains(searchQuery);
    }).toList();
  }

  String _categoryLabel(Map<String, String> d) {
    final n = d['name']!.toLowerCase();
    final l = d['location']!.toLowerCase();
    if (n.contains('gorilla') || n.contains('volcanoes')) return 'Wildlife';
    if (n.contains('akagera') || n.contains('safari')) return 'Safari';
    if (n.contains('lake') || n.contains('kivu')) return 'Nature';
    if (n.contains('memorial') || n.contains('museum')) return 'Culture';
    if (n.contains('nyungwe') || n.contains('forest')) return 'Forest';
    if (l.contains('kigali')) return 'City';
    return 'Explore';
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    if (items.isEmpty) return const SizedBox.shrink();

    return Consumer<TripsProvider>(
      builder: (context, provider, _) {
        return ExploreSectionRow(
          title: 'Top Destinations',
          subtitle: 'Must-see places in Rwanda',
          icon: Icons.landscape_outlined,
          cards: items.map((d) {
            final item = TripItem(
              id: 'dest_${d['name']!.replaceAll(' ', '_').toLowerCase()}',
              name: d['name']!,
              location: d['location']!,
              province: AppConstants.inferProvince(d['location']!),
              image: d['image']!,
              price: d['price'] ?? 'Free',
              rating: d['rating'] ?? '4.5',
            );
            return ExploreItemCard(
              id: item.id,
              name: item.name,
              location: item.location,
              image: item.image,
              price: item.price,
              rating: item.rating,
              categoryLabel: _categoryLabel(d),
              isLiked: provider.isFavourite(item.id),
              isAdded: provider.isAdded(item.id),
              onTap: () => Navigator.push(
                context,
                SmoothPageRoute(
                  page: DestinationDetails(
                    title: item.name,
                    location: item.location,
                    images: [item.image],
                    price: item.price,
                    rating: item.rating,
                    description: d['description'],
                  ),
                ),
              ),
              onLike: () => provider.toggleFavourite(item),
              onAddToTrip: () => addToTripWithGroupCheck(context, item),
            );
          }).toList(),
        );
      },
    );
  }
}

// ── Stays section ─────────────────────────────────────────────────────────────
class _StaysSection extends StatelessWidget {
  final String searchQuery;
  const _StaysSection({required this.searchQuery});

  List<Map<String, String>> get _items {
    if (searchQuery.isEmpty) return AppConstants.allStays;
    return AppConstants.allStays.where((s) {
      return s['name']!.toLowerCase().contains(searchQuery) ||
          s['location']!.toLowerCase().contains(searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    if (items.isEmpty) return const SizedBox.shrink();

    return Consumer<TripsProvider>(
      builder: (context, provider, _) {
        return ExploreSectionRow(
          title: 'Places to Stay',
          subtitle: 'Hotels, lodges & eco stays',
          icon: Icons.hotel_outlined,
          cards: items.map((s) {
            final item = TripItem(
              id: s['id'] ?? 'stay_${s['name']!.replaceAll(' ', '_').toLowerCase()}',
              name: s['name']!,
              location: s['location']!,
              province: s['province'] ?? AppConstants.inferProvince(s['location']!),
              image: s['image']!,
              price: s['price'] ?? 'Free',
              rating: s['rating'] ?? '4.5',
              isAccommodation: true,
            );
            return ExploreItemCard(
              id: item.id,
              name: item.name,
              location: item.location,
              image: item.image,
              price: item.price,
              rating: item.rating,
              categoryLabel: 'Stay',
              isLiked: provider.isFavourite(item.id),
              isAdded: provider.isAdded(item.id),
              onTap: () => Navigator.push(
                context,
                SmoothPageRoute(
                  page: DestinationDetails(
                    title: item.name,
                    location: item.location,
                    images: [item.image],
                    price: item.price,
                    rating: item.rating,
                  ),
                ),
              ),
              onLike: () => provider.toggleFavourite(item),
              onAddToTrip: () => addToTripWithGroupCheck(context, item),
            );
          }).toList(),
        );
      },
    );
  }
}

// ── Things To Do section ──────────────────────────────────────────────────────
class _ThingsToDoSection extends StatelessWidget {
  final String searchQuery;
  const _ThingsToDoSection({required this.searchQuery});

  List<Map<String, String>> get _items {
    if (searchQuery.isEmpty) return AppConstants.thingsToDo;
    return AppConstants.thingsToDo.where((t) {
      return t['title']!.toLowerCase().contains(searchQuery) ||
          t['location']!.toLowerCase().contains(searchQuery) ||
          (t['category'] ?? '').toLowerCase().contains(searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    if (items.isEmpty) return const SizedBox.shrink();

    return Consumer<TripsProvider>(
      builder: (context, provider, _) {
        return ExploreSectionRow(
          title: 'Things To Do',
          subtitle: 'Activities & experiences',
          icon: Icons.hiking_outlined,
          cards: items.map((t) {
            final item = TripItem(
              id: t['id'] ?? 'todo_${t['title']!.replaceAll(' ', '_').toLowerCase()}',
              name: t['title']!,
              location: t['location']!,
              province: AppConstants.inferProvince(t['location']!),
              image: t['image']!,
              price: t['price'] ?? 'Free',
              rating: '4.8',
            );
            return ExploreItemCard(
              id: item.id,
              name: item.name,
              location: item.location,
              image: item.image,
              price: item.price,
              rating: item.rating,
              categoryLabel: t['category'] ?? 'Activity',
              isLiked: provider.isFavourite(item.id),
              isAdded: provider.isAdded(item.id),
              onTap: () => Navigator.push(
                context,
                SmoothPageRoute(
                  page: DestinationDetails(
                    title: item.name,
                    location: item.location,
                    images: [item.image],
                    price: item.price,
                    rating: item.rating,
                    description: t['description'],
                  ),
                ),
              ),
              onLike: () => provider.toggleFavourite(item),
              onAddToTrip: () => addToTripWithGroupCheck(context, item),
            );
          }).toList(),
        );
      },
    );
  }
}
