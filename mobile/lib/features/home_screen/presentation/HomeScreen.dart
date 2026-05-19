import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/animated_card_item.dart';
import '../../../shared/widgets/AI_Card.dart';
import '../../../shared/widgets/Categories.dart';
import '../../../shared/widgets/search.dart';
import '../../../core/utils/trip_snackbar.dart';
import '../../notifications/presentation/notifications_page.dart';
import '../../trips/providers/trips_provider.dart';
import 'AccommodationDetails.dart';
import 'DestinationDetails.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AnimatedCardItem(index: 0, child: _HomeHeader()),
              SizedBox(height: 20.h),
              const AnimatedCardItem(index: 1, child: CustomSearchBar()),
              SizedBox(height: 20.h),
              AnimatedCardItem(
                index: 2,
                child: AiCallToAction(onGetStartedPressed: () {}),
              ),
              SizedBox(height: 24.h),
              AnimatedCardItem(
                index: 3,
                child: CategoriesSection(
                  categories: AppConstants.categories,
                  onCategorySelected: (category) {},
                ),
              ),
              SizedBox(height: 24.h),
              _SectionHeader(
                title: 'Recommended',
                index: 4,
                subtitle: 'Explore More',
                onTap: () {},
              ),
              SizedBox(height: 12.h),
              const _RecommendedList(),
              SizedBox(height: 24.h),
              _SectionHeader(
                title: 'Featured Stay',
                index: 5,
                subtitle: 'See all',
                onTap: () {},
              ),
              SizedBox(height: 12.h),
              const _FeaturedStaySection(),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Section header ──────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String title;
  final int index;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SectionHeader({
    required this.title,
    required this.index,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedCardItem(
      index: index,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: AppColors.textHeading,
            ),
          ),
          if (subtitle != null)
            GestureDetector(
              onTap: onTap,
              child: Row(children: [
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(width: 4.w),
                const Icon(Icons.arrow_forward_ios, size: 11, color: AppColors.primary),
              ]),
            )
        ],
      ),
    );
  }
}

// ── Home header with SVG logo ────────────────────────────────────────────────
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

// ── Recommended horizontal list ──────────────────────────────────────────────
class _RecommendedList extends StatefulWidget {
  const _RecommendedList();

  @override
  State<_RecommendedList> createState() => _RecommendedListState();
}

class _RecommendedListState extends State<_RecommendedList> {
  final Set<int> _liked = {};

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: EdgeInsets.zero,
        itemCount: AppConstants.topDestinations.length,
        itemBuilder: (context, index) {
          final item = AppConstants.topDestinations[index];
          final liked = _liked.contains(index);
          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              SmoothPageRoute(
                page: DestinationDetails(
                  title: item['name']!,
                  location: item['location']!,
                  images: [item['image']!],
                  price: item['price'],
                  rating: item['rating'],
                ),
              ),
            ),
            child: Container(
              margin: EdgeInsets.only(right: 15.w),
              width: 220.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.grey[200],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: item['image']!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: Colors.grey[200]),
                      errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.82)],
                          stops: const [0.45, 1.0],
                        ),
                      ),
                    ),
                    // ── Top overlay: rating + favourite + arrow ──
                    Positioned(
                      top: 12.h,
                      left: 12.w,
                      right: 12.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Rating badge
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star_rounded, color: Colors.amber, size: 12.w),
                                SizedBox(width: 3.w),
                                Text(
                                  item['rating']!,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Favourite + arrow
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => setState(() {
                                  if (liked) _liked.remove(index); else _liked.add(index);
                                }),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    color: liked
                                        ? AppColors.error.withOpacity(0.85)
                                        : Colors.black.withOpacity(0.35),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    liked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                                    color: Colors.white,
                                    size: 14.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // ── Bottom: name + location ──
                    Positioned(
                      bottom: 14.h,
                      left: 14.w,
                      right: 14.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            item['name']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 11.w, color: Colors.white70),
                              SizedBox(width: 3.w),
                              Expanded(
                                child: Text(
                                  item['location']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white70, fontSize: 11.sp),
                                ),
                              ),
                            ],
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

// ── Featured Stay — Kigali stays with like, rating, add-to-trip ──────────────
const _kKigaliStays = [
  {
    'id': 'stay_kigali_0',
    'name': 'Kigali Serena Hotel',
    'location': 'Kiyovu, Kigali',
    'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=400&fit=crop',
    'price': '\$180.00',
    'rating': '4.9',
    'reviews': '312',
  },
  {
    'id': 'stay_kigali_1',
    'name': 'Radisson Blu Kigali',
    'location': 'Gasabo, Kigali',
    'image': 'https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=400&fit=crop',
    'price': '\$150.00',
    'rating': '4.7',
    'reviews': '198',
  },
  {
    'id': 'stay_kigali_2',
    'name': 'Nyandungu Eco Lodge',
    'location': 'Nyarugunga, Kigali',
    'image': 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=400&fit=crop',
    'price': '\$95.00',
    'rating': '4.5',
    'reviews': '87',
  },
];

class _FeaturedStaySection extends StatefulWidget {
  const _FeaturedStaySection();

  @override
  State<_FeaturedStaySection> createState() => _FeaturedStaySectionState();
}

class _FeaturedStaySectionState extends State<_FeaturedStaySection> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TripsProvider>(
      builder: (context, provider, _) {
        return ListView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _kKigaliStays.length,
          itemBuilder: (context, index) {
            final stay = _kKigaliStays[index];
            final tripItem = TripItem(
              id: stay['id']!,
              name: stay['name']!,
              location: stay['location']!,
              province: 'Kigali City',
              image: stay['image']!,
              price: stay['price']!,
              rating: stay['rating']!,
              isAccommodation: true,
            );
            final liked = provider.isAccommodationLiked(tripItem.id);
            final added = provider.isAccommodationSelected(tripItem.id);

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
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
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
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: CachedNetworkImage(
                        imageUrl: stay['image']!,
                        width: 80.w,
                        height: 80.w,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                        errorWidget: (_, __, ___) => Container(color: AppColors.shimmerBase),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stay['name']!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textHeading,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 11.w, color: AppColors.textSecondary),
                              SizedBox(width: 2.w),
                              Text(
                                stay['location']!,
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 11.sp),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            children: [
                              Icon(Icons.star_rounded, color: Colors.amber, size: 13.w),
                              SizedBox(width: 3.w),
                              Text(
                                stay['rating']!,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textHeading,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                '(${stay['reviews']} reviews)',
                                style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            stay['price']!,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    // Actions
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => provider.toggleLikeAccommodation(tripItem),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: liked ? AppColors.errorSoft : AppColors.surfaceBorder.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              liked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                              size: 16.w,
                              color: liked ? AppColors.error : AppColors.textSecondary,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap: () {
                            provider.toggleSelectAccommodation(tripItem);
                            if (!added) showAddedToTripSnackbar(context, stay['name']!);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: added ? AppColors.primarySoft : AppColors.primary,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              added ? 'Added' : '+ Trip',
                              style: TextStyle(
                                color: added ? AppColors.primary : Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}


