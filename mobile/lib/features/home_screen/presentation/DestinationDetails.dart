import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/animated_card_item.dart';
import '../../../core/utils/trip_snackbar.dart';
import '../../trips/providers/trips_provider.dart';

class DestinationDetails extends StatefulWidget {
  final String title;
  final String location;
  final List<String> images;
  final String? price;
  final String? rating;
  final String? description;

  const DestinationDetails({
    required this.title,
    required this.location,
    required this.images,
    this.price = '\$250.00',
    this.rating = '4.5',
    this.description =
    'Nyandungu Eco-Park provides a space for residents and visitors to explore and learn about nature, and is a blueprint for the restoration of degraded ecosystems across Rwanda.',
    super.key
  });

  @override
  State<DestinationDetails> createState() => _DestinationDetailsState();
}

class _DestinationDetailsState extends State<DestinationDetails> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  bool _titleVisible = false;
  int _currentCarouselPage = 0;

  @override
  void initState(){
    super.initState();
    _scrollController.addListener(() {
      if (!_scrollController.hasClients) return;
      final showTitle = _scrollController.offset > 260;
      if (_titleVisible != showTitle) {
        setState(() {
          _titleVisible = showTitle;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _openFullScreenImage(int initialIndex) {
    Navigator.push(
      context,
      SmoothPageRoute(
        page: FullScreenImageViewer(
          images: widget.images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  TripItem _asTripItem() => TripItem(
        id: 'dest_${widget.title.replaceAll(' ', '_').toLowerCase()}',
        name: widget.title,
        location: widget.location,
        province: _inferProvince(widget.location),
        image: widget.images.isNotEmpty ? widget.images.first : '',
        price: widget.price ?? 'Free',
        rating: widget.rating ?? '4.5',
        isAccommodation: false,
      );

  static String _inferProvince(String location) {
    final l = location.toLowerCase();
    if (l.contains('kigali')) return 'Kigali City';
    if (l.contains('musanze') || l.contains('north') || l.contains('burera') || l.contains('ruhondo')) return 'Northern Province';
    if (l.contains('rubavu') || l.contains('west') || l.contains('kivu')) return 'Western Province';
    if (l.contains('kayonza') || l.contains('east') || l.contains('akagera')) return 'Eastern Province';
    if (l.contains('huye') || l.contains('south') || l.contains('nyanza')) return 'Southern Province';
    return 'Kigali City';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TripsProvider>(
      builder: (context, provider, _) {
        final item = _asTripItem();
        final isAdded = provider.isAdded(item.id);
        final isLiked = provider.isFavourite(item.id);
        return _buildScaffold(context, provider, item, isAdded, isLiked);
      },
    );
  }

  Widget _buildScaffold(BuildContext context, TripsProvider provider, TripItem item, bool isAdded, bool isLiked) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              // ========== App Bar ================================
              _DetailsSliverAppBar(
                title: widget.title,
                titleVisible: _titleVisible,
                images: widget.images,
                currentPage: _currentCarouselPage,
                pageController: _pageController,
                onImageTap: _openFullScreenImage,
                onPageChanged: (i) => setState(() => _currentCarouselPage = i),
                isLiked: isLiked,
                onLike: () => provider.toggleFavourite(item),
              ),
              // ========== Content ================================
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Icon(Icons.location_on, size: 16.w, color: AppColors.primary),
                                    SizedBox(width: 4.w),
                                    Text(
                                      widget.location,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 18.w),
                                SizedBox(width: 4.w),
                                Text(
                                  widget.rating!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'About Destination',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        widget.description!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Gallery',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _GalleryList(
                        images: widget.images,
                        onImageTap: _openFullScreenImage,
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        'Amenities',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      const _AmenitiesList(),
                      SizedBox(height: 24.h),
                      Text(
                        'Activities',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      const _ActivitiesList(),
                      SizedBox(height: 24.h),

                      Text(
                        'What\'s Included',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      const _IncludedList(),
                      SizedBox(height: 120.h), // bottom bar spacer
                    ],
                  ),
                ),
              ),
            ],
          ),
          // ========== Bottom Booking Bar ================================
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 30.h),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Entry Price',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12.sp),
                      ),
                      Text(
                        widget.price!,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        provider.toggleAddTrip(item);
                        if (!isAdded) {
                          showAddedToTripSnackbar(context, widget.title);
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        decoration: BoxDecoration(
                          color: isAdded ? AppColors.primarySoft : AppColors.primary,
                          borderRadius: BorderRadius.circular(12.r),
                          border: isAdded ? Border.all(color: AppColors.primary, width: 1.5) : null,
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isAdded ? Icons.check_rounded : Icons.add_rounded,
                              color: isAdded ? AppColors.primary : Colors.white,
                              size: 18.w,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              isAdded ? 'Added to Trip' : 'Add to Trip',
                              style: TextStyle(
                                color: isAdded ? AppColors.primary : Colors.white,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ========== Shared Details Sliver App Bar ================================
class _DetailsSliverAppBar extends StatelessWidget {
  final String title;
  final bool titleVisible;
  final List<String> images;
  final int currentPage;
  final PageController pageController;
  final Function(int) onImageTap;
  final ValueChanged<int> onPageChanged;
  final bool isLiked;
  final VoidCallback onLike;

  const _DetailsSliverAppBar({
    required this.title,
    required this.titleVisible,
    required this.images,
    required this.currentPage,
    required this.pageController,
    required this.onImageTap,
    required this.onPageChanged,
    this.isLiked = false,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 340.h,
      pinned: true,
      elevation: 0,
      centerTitle: false,
      backgroundColor: AppColors.background,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      automaticallyImplyLeading: false,
      title: titleVisible
          ? Text(
              title,
              style: TextStyle(
                color: AppColors.textHeading,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.3,
              ),
            )
          : null,
      // ========== Leading — back button ================================
      leading: Padding(
        padding: EdgeInsets.only(left: 12.w, top: 6.h, bottom: 6.h),
        child: GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutQuart,
            decoration: BoxDecoration(
              color: titleVisible
                  ? AppColors.surfaceBorder.withOpacity(0.6)
                  : Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 16.w,
              color: titleVisible ? AppColors.textHeading : Colors.white,
            ),
          ),
        ),
      ),
      // ========== Actions — favourite + share ================================
      actions: [
        _DetailsAction(
          icon: isLiked ? Icons.favorite_rounded : Icons.favorite_outline_rounded,
          collapsed: titleVisible,
          onTap: onLike,
          isActive: isLiked,
        ),
        _DetailsAction(
          icon: Icons.share_outlined,
          collapsed: titleVisible,
          onTap: () {},
          isLast: true,
        ),
      ],
      // ========== Hero image carousel ================================
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: images.isEmpty ? 1 : images.length,
              onPageChanged: onPageChanged,
              itemBuilder: (context, index) {
                final url = images.isEmpty ? '' : images[index];
                return GestureDetector(
                  onTap: () => onImageTap(index),
                  child: Hero(
                    tag: 'gallery_image_$index',
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: AppColors.shimmerBase),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.shimmerBase,
                        child: Icon(Icons.broken_image, size: 50.w, color: AppColors.textDisabled),
                      ),
                    ),
                  ),
                );
              },
            ),
            // gradient overlay
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.40),
                    Colors.transparent,
                    Colors.black.withOpacity(0.30),
                  ],
                  stops: const [0.0, 0.35, 1.0],
                ),
              ),
            ),
            // dot pagination
            if (images.length > 1)
              Positioned(
                bottom: 20.h,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    images.length,
                    (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 240),
                      margin: EdgeInsets.symmetric(horizontal: 3.w),
                      width: currentPage == i ? 18.w : 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        color: currentPage == i
                            ? Colors.white
                            : Colors.white.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ========== Details Action Button ================================
class _DetailsAction extends StatelessWidget {
  final IconData icon;
  final bool collapsed;
  final VoidCallback onTap;
  final bool isLast;
  final bool isActive;

  const _DetailsAction({
    required this.icon,
    required this.collapsed,
    required this.onTap,
    this.isLast = false,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutQuart,
        width: 36.w,
        height: 36.w,
        margin: EdgeInsets.only(
          left: 8.w,
          right: isLast ? 16.w : 0,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.error.withOpacity(0.85)
              : collapsed
                  ? AppColors.surfaceBorder.withOpacity(0.6)
                  : Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          icon,
          size: 17.w,
          color: isActive ? Colors.white : collapsed ? AppColors.textHeading : Colors.white,
        ),
      ),
    );
  }
}

class _GalleryList extends StatelessWidget {
  final List<String> images;
  final Function(int) onImageTap;

  const _GalleryList({required this.images, required this.onImageTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onImageTap(index),
            child: Container(
              margin: EdgeInsets.only(right: 12.w),
              width: 80.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(images[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AmenitiesList extends StatelessWidget {
  const _AmenitiesList();

  @override
  Widget build(BuildContext context) {
    final amenities = [
      {'icon': Icons.wifi, 'label': 'Free Wi-Fi'},
      {'icon': Icons.restaurant, 'label': 'Restaurant'},
      {'icon': Icons.local_parking, 'label': 'Parking Area'},
      {'icon': Icons.nature_people, 'label': 'Nature Exploration'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: amenities.map((item) {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(item['icon'] as IconData, color: AppColors.primary, size: 22.w),
            ),
            SizedBox(height: 6.h),
            Text(
              item['label'] as String,
              style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _IncludedList extends StatelessWidget {
  const _IncludedList();

  @override
  Widget build(BuildContext context) {
    final items = [
      'Park Entrance Fees',
      'Expert Tour Guide',
      'Bottled Water',
      'Insurance Cover',
      'Tour Guide'
      'Transport from Kigali'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) => _BulletItem(text: item)).toList(),
    );
  }
}

class _ActivitiesList extends StatelessWidget {
  const _ActivitiesList();

  @override
  Widget build(BuildContext context) {
    final activities = [
      'Hiking & Trekking',
      'Bird Watching',
      'Nature Photography',
      'Eco Tour',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: activities.map((activity) => _BulletItem(text: activity)).toList(),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;

  const _BulletItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ',
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary)),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FullScreenImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;

  const FullScreenImageViewer({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Hero(
                tag: 'gallery_image_$index',
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Center(
                    child: CachedNetworkImage(
                      imageUrl: widget.images[index],
                      fit: BoxFit.contain,
                      width: double.infinity,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 40.h,
            left: 20.w,
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                '${_currentIndex + 1} / ${widget.images.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.sp,
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
