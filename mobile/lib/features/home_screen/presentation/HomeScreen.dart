import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/animated_card_item.dart';
import '../../../shared/widgets/AI_Card.dart';
import '../../../shared/widgets/Categories.dart';
import '../../../shared/widgets/search.dart';
import '../../notifications/presentation/notifications_page.dart';
import '../../trips/providers/trips_provider.dart';
import 'DestinationDetails.dart';
import 'AccommodationDetails.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
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

class _RecommendedList extends StatelessWidget {
  const _RecommendedList();

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
                    // ===== Rating + Favourite =====
                    Positioned(
                      top: 12.h,
                      left: 12.w,
                      right: 12.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.45),
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
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Consumer<TripsProvider>(
                            builder: (context, provider, _) {
                              final tripItem = TripItem(
                                id: 'rec_$index',
                                name: item['name']!,
                                location: item['location']!,
                                province: 'Rwanda',
                                image: item['image']!,
                                price: item['price']!,
                                rating: item['rating']!,
                              );
                              final isFav = provider.favourites.any((f) => f.name == item['name']);
                              final inTrip = provider.isInTrip(item['name']!);
                              return GestureDetector(
                                onTap: () {
                                  if (!inTrip) provider.toggleFavourite(tripItem);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 220),
                                  width: 32.w,
                                  height: 32.w,
                                  decoration: BoxDecoration(
                                    color: isFav
                                        ? AppColors.primary
                                        : Colors.black.withOpacity(0.45),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    isFav ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                                    color: Colors.white,
                                    size: 16.w,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    // ===== Name, Location & CTA =====
                    Positioned(
                      bottom: 14.h,
                      left: 14.w,
                      right: 14.w,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
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
                          SizedBox(width: 8.w),
                          Container(
                            width: 34.w,
                            height: 34.w,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: 16.w,
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
        },
      ),
    );
  }
}

const _kFeaturedStays = [
  {'name': 'Luxury Green Villa',  'location': 'Musanze, Rwanda', 'price': '\$120.00', 'image': 'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=400&fit=crop'},
  {'name': 'Kigali Serena Hotel', 'location': 'Kigali CBD',      'price': '\$180.00', 'image': 'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?q=80&w=400&fit=crop'},
  {'name': 'Lake Kivu Serena',    'location': 'Rubavu, Rwanda',  'price': '\$150.00', 'image': 'https://images.unsplash.com/photo-1540541338287-41700207dee6?q=80&w=400&fit=crop'},
];

class _FeaturedStaySection extends StatelessWidget {
  const _FeaturedStaySection();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _kFeaturedStays.length,
      itemBuilder: (context, index) {
        final stay = _kFeaturedStays[index];
        return Container(
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
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CachedNetworkImage(
                  imageUrl: stay['image']!,
                  width: 80.w,
                  height: 80.w,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stay['name']!,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4.h),
                    Text(stay['location']!, style: TextStyle(color: AppColors.textSecondary, fontSize: 11.sp)),
                    SizedBox(height: 8.h),
                    Text(stay['price']!, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
