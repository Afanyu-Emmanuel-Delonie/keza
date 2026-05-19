import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/animated_card_item.dart';
import '../../../shared/widgets/Categories.dart';
import '../../../shared/widgets/keza_app_bar.dart';
import '../../../shared/widgets/search.dart';
import '../../home_screen/presentation/DestinationDetails.dart';
import 'ProvincePlacesScreen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const KezaAppBar(
        title: 'Explore Rwanda',
        subtitle: 'Discover the land of a thousand hills',
        showBack: false,

      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ========== Search ================================
              const AnimatedCardItem(index: 0, child: CustomSearchBar()),

              SizedBox(height: 20.h),

              // ========== Categories ================================
              AnimatedCardItem(
                index: 2,
                child: CategoriesSection(
                  categories: AppConstants.categories,
                  onCategorySelected: (_) {},
                ),
              ),

              SizedBox(height: 24.h),

              // ========== AI Banner ================================
              AnimatedCardItem(index: 3, child: const _ExploreAiBanner()),

              SizedBox(height: 24.h),

              // ========== Provinces ================================
              AnimatedCardItem(
                index: 4,
                child: _SectionHeader(
                  title: 'Browse by Province',
                  subtitle: 'View all',
                  onTap: () {},
                ),
              ),
              SizedBox(height: 12.h),
              const AnimatedCardItem(index: 5, child: _ProvincesGrid()),

              SizedBox(height: 24.h),

              // ========== Top Destinations ================================
              AnimatedCardItem(
                index: 6,
                child: _SectionHeader(
                  title: 'Top Destinations',
                  subtitle: 'See all',
                  onTap: () {},
                ),
              ),
              SizedBox(height: 12.h),
              const _TopDestinationsList(),

              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ========== Section Header ================================
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const _SectionHeader({required this.title, this.subtitle, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        if (subtitle != null)
          GestureDetector(
            onTap: onTap,
            child: Row(
              children: [
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(Icons.arrow_forward_ios, size: 11.w, color: AppColors.primary),
              ],
            ),
          ),
      ],
    );
  }
}

// ========== AI Banner ================================
class _ExploreAiBanner extends StatelessWidget {
  const _ExploreAiBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: AppColors.aiGradient,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome, color: Colors.amber, size: 14.w),
                    SizedBox(width: 6.w),
                    Text(
                      'AI Discovery',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6.h),
                Text(
                  'Not sure where to go?\nLet AI suggest the best spots for you.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'Ask AI',
                style: TextStyle(
                  color: AppColors.primaryDark,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ========== Provinces Grid ================================
class _ProvincesGrid extends StatelessWidget {
  const _ProvincesGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1.2,
      ),
      itemCount: AppConstants.provinces.length,
      itemBuilder: (context, index) {
        final province = AppConstants.provinces[index];
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: province['image'] as String,
                  fit: BoxFit.cover,
                  errorWidget: (_, __, ___) =>
                      Container(color: Colors.grey[200]),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.72),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12.h,
                  left: 12.w,
                  right: 12.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        province['name'] as String,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          Icon(Icons.place_outlined,
                              color: Colors.white60, size: 11.w),
                          SizedBox(width: 3.w),
                          Text(
                            province['places_count'] as String,
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 10.sp,
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
        );
      },
    );
  }
}

// ========== Top Destinations List ================================
class _TopDestinationsList extends StatelessWidget {
  const _TopDestinationsList();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: AppConstants.topDestinations.length,
      itemBuilder: (context, index) {
        final dest = AppConstants.topDestinations[index];
        return AnimatedCardItem(
          index: index + 7,
          child: GestureDetector(
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
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: CachedNetworkImage(
                      imageUrl: dest['image']!,
                      width: 80.w,
                      height: 80.w,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        width: 80.w,
                        height: 80.w,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dest['name']!,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 12.w, color: AppColors.primary),
                            SizedBox(width: 3.w),
                            Text(
                              dest['location']!,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Price badge
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                dest['price']!,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            // Rating
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Colors.amber, size: 13.w),
                                SizedBox(width: 3.w),
                                Text(
                                  dest['rating']!,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(Icons.arrow_forward_ios,
                      size: 13.w,
                      color: AppColors.textSecondary.withOpacity(0.4)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
