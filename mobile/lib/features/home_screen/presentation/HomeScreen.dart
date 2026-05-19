import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/animated_card_item.dart';
import '../../../shared/widgets/AI_Card.dart';
import '../../../shared/widgets/Categories.dart';
import '../../../shared/widgets/search.dart';
import '../../notifications/presentation/notifications_page.dart';
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
              // ========== Header ================================
              const AnimatedCardItem(index: 0, child: _HomeHeader()),
              SizedBox(height: 20.h),

              // ========== Search ================================
              const AnimatedCardItem(index: 1, child: CustomSearchBar()),
              SizedBox(height: 20.h),

              // ========== AI Card ================================
              AnimatedCardItem(
                index: 2,
                child: AiCallToAction(onGetStartedPressed: () {}),
              ),
              SizedBox(height: 24.h),

              // ========== Categories ================================
              AnimatedCardItem(
                index: 3,
                child: CategoriesSection(
                  categories: AppConstants.categories,
                  onCategorySelected: (category) {},
                ),
              ),
              SizedBox(height: 24.h),

              // ========== Recommended ================================
              _SectionHeader(
                title: 'Recommended',
                index: 4,
                subtitle: 'Explore More',
                onTap: () {},
              ),
              SizedBox(height: 12.h),
              const _RecommendedList(),
              SizedBox(height: 24.h),

              // ========== Featured Stay ================================
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
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
          ),
          if (subtitle != null)
            GestureDetector(
              onTap: onTap,
              child: Row(children: [
                Text(
                  subtitle!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontSize: 11.sp,
                      ),
                ),
                SizedBox(width: 4.w),
                const Icon(Icons.arrow_forward_ios,
                    size: 12, color: AppColors.primary),
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
              backgroundImage: const AssetImage('assets/general/profile.png'),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 11.sp,
                      ),
                ),
                SizedBox(height: 2.h),
                Text(
                  'Afanyu Emmanuel',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              onPressed: () => Navigator.push(
                context,
                SmoothPageRoute(page: const NotificationsPage()),
              ),
              icon: const Icon(Icons.notifications_none, size: 26),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5.w,
                  ),
                ),
              ),
            ),
          ],
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
      height: 230.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: AppConstants.categories.length,
        itemBuilder: (context, index) {
          final item = AppConstants.categories[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                SmoothPageRoute(
                  page: DestinationDetails(
                    title: 'Nyandungu Park',
                    location: 'Kigali, Rwanda',
                    images: [item['image']!],
                  ),
                ),
              );
            },
            child: AnimatedCardItem(
              index: index + 4,
              child: Container(
                margin: EdgeInsets.only(right: 12.w),
                width: 250.w,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: item['image']!,
                        width: 250.w,
                        height: 230.h,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.15),
                              Colors.black.withOpacity(0.70),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12.h,
                        left: 12.w,
                        right: 12.w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 13.w),
                                  SizedBox(width: 3.w),
                                  Text(
                                    '4.5',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: Container(
                                padding: EdgeInsets.all(6.w),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.25),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.favorite_outline_rounded,
                                    color: Colors.white, size: 16.w),
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildInfo(context),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    return Positioned(
      bottom: 12.h,
      left: 12.w,
      right: 12.w,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Nyandungu Park',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 12.w, color: Colors.white70),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        'Kigali, Rwanda',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(color: Colors.white70, fontSize: 11.sp),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          CircleAvatar(
            backgroundColor: AppColors.primary,
            radius: 16.r,
            child: Transform.rotate(
              angle: -math.pi / 4,
              child: const Icon(Icons.arrow_forward_rounded,
                  color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedStaySection extends StatelessWidget {
  const _FeaturedStaySection();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 3,
      itemBuilder: (context, index) {
        final stay = AppConstants.categories[index];
        return AnimatedCardItem(
          index: index + 6,
          child: _StayCard(stay: stay),
        );
      },
    );
  }
}

class _StayCard extends StatelessWidget {
  final Map<String, String> stay;
  const _StayCard({required this.stay});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          SmoothPageRoute(
            page: AccommodationDetails(
              title: 'Luxury Green Villa',
              location: 'Musanze, Rwanda',
              images: [stay['image']!],
              price: '\$120.00',
              rating: '4.8',
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: CachedNetworkImage(
                imageUrl: stay['image']!,
                width: 75.w,
                height: 75.w,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.broken_image, size: 20, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Luxury Green Villa',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Icon(
                          Icons.favorite_outline_rounded,
                          color: AppColors.textSecondary.withOpacity(0.6),
                          size: 18.w,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 12.w, color: AppColors.textSecondary),
                      SizedBox(width: 2.w),
                      Text(
                        'Musanze, Rwanda',
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: 11.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$120.00',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 12),
                          Text(
                            ' 4.8',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ],
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
