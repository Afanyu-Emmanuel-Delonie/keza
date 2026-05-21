import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/widgets/animated_card_item.dart';
import '../../../core/utils/trip_snackbar.dart';
import '../../../shared/widgets/Categories.dart';
import '../../../shared/widgets/keza_app_bar.dart';
import '../../ai/presentation/general_chat_screen.dart';
import '../../home_screen/presentation/DestinationDetails.dart';
import '../../trips/providers/trips_provider.dart';
import 'ProvincePlacesScreen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String _selectedCategory = 'all';

  // Filter destinations by category id
  List<Map<String, String>> _filteredDestinations() {
    if (_selectedCategory == 'all') return AppConstants.topDestinations;
    final kw = AppConstants.categoryKeywords[_selectedCategory] ?? [];
    if (kw.isEmpty) return AppConstants.topDestinations;
    return AppConstants.topDestinations.where((d) {
      final text = '${d['name']!} ${d['location']!}'.toLowerCase();
      return kw.any((k) => text.contains(k));
    }).toList();
  }

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
              const AnimatedCardItem(index: 0, child: _SearchButton()),
              SizedBox(height: 20.h),
              AnimatedCardItem(
                index: 2,
                child: _ExploreAiBanner(
                  onAskAi: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GeneralChatScreen()),
                  ),
                ),
              ),
              SizedBox(height: 28.h),
              AnimatedCardItem(
                index: 3,
                child: const _SectionHeader(
                  title: 'Browse by Province',
                ),
              ),
              SizedBox(height: 16.h),
              AnimatedCardItem(index: 4, child: const _ProvincesGrid()),
              SizedBox(height: 28.h),
              _SectionHeader(
                title: 'Top Destinations',
                subtitle: 'See all',
                onTap: () => setState(() => _selectedCategory = 'all'),
              ),
              SizedBox(height: 12.h),
              CategoriesSection(
                categories: AppConstants.categories
                    .where((c) => c['id'] != 'accommodation')
                    .toList(),
                onCategorySelected: (cat) =>
                    setState(() => _selectedCategory = cat['id'] as String),
              ),
              SizedBox(height: 16.h),
              _TopDestinationsList(destinations: _filteredDestinations()),
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
            color: AppColors.textHeading,
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
                    fontWeight: FontWeight.w700,
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

class _ExploreAiBanner extends StatelessWidget {
  final VoidCallback? onAskAi;
  const _ExploreAiBanner({this.onAskAi});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: AppColors.aiGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Stack(
          children: [
            // SVG watermark
            Positioned(
              right: -10.w,
              bottom: -10.h,
              child: Opacity(
                opacity: 0.08,
                child: SvgPicture.asset(
                  'assets/general/main-logo.svg',
                  width: 150.w,
                  height: 150.w,
                  colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, color: Colors.amber, size: 14.w),
                      SizedBox(width: 8.w),
                      Text(
                        'AI DISCOVERY',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Not sure where to go?\nLet AI suggest the best spots for you.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: onAskAi,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          'Ask Keza AI',
                          style: TextStyle(
                            color: AppColors.primaryDarker,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
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
    );
  }
}

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
        childAspectRatio: 1.1,
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
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: province['image'] as String,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: Colors.grey[200]),
                    errorWidget: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.85),
                        ],
                        stops: const [0.5, 1.0],
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
                            Icon(Icons.place_outlined, color: Colors.white70, size: 11.w),
                            SizedBox(width: 3.w),
                            Text(
                              province['places_count'] as String,
                              style: TextStyle(color: Colors.white70, fontSize: 10.sp),
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
    );
  }
}

class _TopDestinationsList extends StatelessWidget {
  final List<Map<String, String>> destinations;
  const _TopDestinationsList({required this.destinations});

  @override
  Widget build(BuildContext context) {
    if (destinations.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: Center(
          child: Text('No destinations in this category',
              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
        ),
      );
    }
    return Consumer<TripsProvider>(
      builder: (context, provider, _) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: destinations.length,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            final dest = destinations[index];
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
              child: InkWell(
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
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: CachedNetworkImage(
                        imageUrl: dest['image']!,
                        width: 80.w,
                        height: 80.w,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(width: 80.w, height: 80.w, color: Colors.grey[100]),
                        errorWidget: (_, __, ___) => Container(width: 80.w, color: Colors.grey[200]),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dest['name']!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textHeading,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 12.w, color: AppColors.primary),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  dest['location']!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Text(
                                dest['price']!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                              const Spacer(),
                              Icon(Icons.star, color: Colors.amber, size: 13.w),
                              SizedBox(width: 3.w),
                              Text(
                                dest['rating']!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textHeading,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => provider.toggleFavourite(item),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              color: isLiked ? AppColors.errorSoft : AppColors.surfaceBorder.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
                              size: 15.w,
                              color: isLiked ? AppColors.error : AppColors.textSecondary,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        GestureDetector(
                          onTap: () {
                            provider.toggleAddTrip(item);
                            if (!isAdded) showAddedToTripSnackbar(context, dest['name']!);
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: isAdded ? AppColors.primarySoft : AppColors.primary,
                              borderRadius: BorderRadius.circular(8.r),
                              border: isAdded ? Border.all(color: AppColors.primary) : null,
                            ),
                            child: Text(
                              isAdded ? '✓ Added' : '+ Trip',
                              style: TextStyle(
                                color: isAdded ? AppColors.primary : Colors.white,
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

  static String _inferProvince(String location) => AppConstants.inferProvince(location);
}

// ── Search button (replaces inline search bar) ──────────────────────────────────────
class _SearchButton extends StatelessWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        barrierColor: Colors.black54,
        builder: (_) => const _SearchPopup(),
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.textSecondary, size: 20.w),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'Search for places',
                style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.tune_rounded, color: Colors.white, size: 16.w),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Search popup dialog ───────────────────────────────────────────────────────────────
class _SearchPopup extends StatefulWidget {
  const _SearchPopup();

  @override
  State<_SearchPopup> createState() => _SearchPopupState();
}

class _SearchPopupState extends State<_SearchPopup> {
  final _controller = TextEditingController();
  List<Map<String, String>> _results = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    final q = query.toLowerCase().trim();
    setState(() {
      _results = q.isEmpty
          ? []
          : AppConstants.topDestinations.where((d) {
              return d['name']!.toLowerCase().contains(q) ||
                  d['location']!.toLowerCase().contains(q);
            }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 60.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Search field
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: AppColors.textSecondary, size: 20.w),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      onChanged: _onSearch,
                      decoration: InputDecoration(
                        hintText: 'Search destinations, provinces...',
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                        hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.close, size: 18.w, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            if (_results.isNotEmpty) ...[
              SizedBox(height: 12.h),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 300.h),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: _results.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.surfaceBorder),
                  itemBuilder: (context, i) {
                    final d = _results[i];
                    return ListTile(
                      dense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 4.w),
                      leading: Icon(Icons.place_outlined, color: AppColors.primary, size: 18.w),
                      title: Text(d['name']!, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textHeading)),
                      subtitle: Text(d['location']!, style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
                      onTap: () => Navigator.pop(context),
                    );
                  },
                ),
              ),
            ] else if (_controller.text.isNotEmpty) ...[
              SizedBox(height: 20.h),
              Text('No results found', style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
              SizedBox(height: 12.h),
            ],
          ],
        ),
      ),
    );
  }
}
