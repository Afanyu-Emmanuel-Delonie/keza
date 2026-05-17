import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';

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
      MaterialPageRoute(
        builder: (context) => FullScreenImageViewer(
          images: widget.images,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              //=============== APP BAR SECTION ========================
              SliverAppBar(
                expandedHeight: 340.h,
                pinned: true,
                elevation: 0,
                backgroundColor: AppColors.background,
                leading: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: CircleAvatar(
                    backgroundColor: Colors.black.withOpacity(0.4),
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                    ),
                  ),
                ),
                title: _titleVisible
                    ? Text(
                        widget.title,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.4),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.favorite_outline_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: CircleAvatar(
                      backgroundColor: Colors.black.withOpacity(0.4),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.share, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      PageView.builder(
                        controller: _pageController,
                        itemCount: widget.images.isEmpty ? 1 : widget.images.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentCarouselPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final imageUrl = widget.images.isEmpty ? '' : widget.images[index];
                          return GestureDetector(
                            onTap: () => _openFullScreenImage(index),
                            child: Hero(
                              tag: 'gallery_image_$index',
                              child: CachedNetworkImage(
                                imageUrl: imageUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: const Center(child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.35),
                              Colors.transparent,
                              Colors.black.withOpacity(0.35),
                            ],
                            stops: const [0.0, 0.3, 1.0],
                          ),
                        ),
                      ),
                      if (widget.images.length > 1)
                        Positioned(
                          bottom: 20.h,
                          left: 0,
                          right: 0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.images.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 240),
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                width: _currentCarouselPage == index ? 18.w : 6.w,
                                height: 6.w,
                                decoration: BoxDecoration(
                                  color: _currentCarouselPage == index
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
              ),
              //=============== CONTENT SECTION ========================
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
                      SizedBox(height: 120.h), // Spacer for bottom bar
                    ],
                  ),
                ),
              ),
            ],
          ),
          //=============== BOTTOM BOOKING BAR ========================
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
                        'Total Price',
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
                  SizedBox(width: 30.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Add Trip',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
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
