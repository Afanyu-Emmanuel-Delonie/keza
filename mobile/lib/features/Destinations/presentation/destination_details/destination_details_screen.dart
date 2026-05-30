import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../../core/widgets/animated_card_item.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/trip_snackbar.dart';
import '../../../trips/providers/trips_provider.dart';
import '../../domain/models/destination_details_model.dart';
import 'destination_details_booking.dart';
import '../../widgets/destination_details_sections.dart';
import '../../widgets/destination_info_all_page.dart';

class DestinationDetails extends StatefulWidget {
  final String title;
  final String location;
  final List<String> images;
  final String? price;
  final String? rating;
  final String? description;
  final DestinationDetailData? data;

  const DestinationDetails({
    required this.title,
    required this.location,
    required this.images,
    this.price = '\$50',
    this.rating = '4.8',
    this.description =
        'Discover one of Rwanda\'s most iconic experiences. Set against the backdrop of the land of a thousand hills, this activity offers an unforgettable encounter with nature, culture and adventure.',
    this.data,
    super.key,
  });

  @override
  State<DestinationDetails> createState() => _DestinationDetailsState();
}

class _DestinationDetailsState extends State<DestinationDetails> {
  final _scrollCtrl = ScrollController();
  final _pageCtrl = PageController();
  bool _titleVisible = false;
  int _currentPage = 0;

  DestinationDetailData get _data => widget.data ?? kDefaultDestinationData;

  TripItem get _tripItem => TripItem(
        id: 'dest_${widget.title.replaceAll(' ', '_').toLowerCase()}',
        name: widget.title,
        location: widget.location,
        province: _inferProvince(widget.location),
        image: widget.images.isNotEmpty ? widget.images.first : '',
        price: widget.price ?? 'Free',
        rating: widget.rating ?? '4.8',
      );

  static String _inferProvince(String location) {
    final l = location.toLowerCase();
    if (l.contains('kigali')) return 'Kigali City';
    if (l.contains('musanze') || l.contains('north') || l.contains('burera') || l.contains('ruhondo')) return 'Northern Province';
    if (l.contains('rubavu') || l.contains('west') || l.contains('kivu')) return 'Western Province';
    if (l.contains('kayonza') || l.contains('east') || l.contains('akagera')) return 'Eastern Province';
    if (l.contains('huye') || l.contains('south') || l.contains('nyanza') || l.contains('nyungwe')) return 'Southern Province';
    return 'Kigali City';
  }

  @override
  void initState() {
    super.initState();
    _scrollCtrl.addListener(() {
      if (!_scrollCtrl.hasClients) return;
      final show = _scrollCtrl.offset > 260;
      if (show != _titleVisible) setState(() => _titleVisible = show);
    });
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  void _openFullScreen(int index) {
    Navigator.push(
      context,
      SmoothPageRoute(
        page: FullScreenImageViewer(
            images: widget.images, initialIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TripsProvider>(
      builder: (context, provider, _) {
        final item = _tripItem;
        final isAdded = provider.isAdded(item.id);
        final isLiked = provider.isFavourite(item.id);

        return Scaffold(
          backgroundColor: AppColors.background,
          bottomNavigationBar: _StickyBookingBar(
            price: widget.price ?? '\$50',
            isAdded: isAdded,
            onAddToTrip: () {
              provider.toggleAddTrip(item);
              if (!isAdded) showAddedToTripSnackbar(context, widget.title);
            },
          ),
          body: CustomScrollView(
            controller: _scrollCtrl,
            slivers: [
              _DetailsSliverAppBar(
                title: widget.title,
                titleVisible: _titleVisible,
                images: widget.images,
                currentPage: _currentPage,
                pageController: _pageCtrl,
                onImageTap: _openFullScreen,
                onPageChanged: (i) => setState(() => _currentPage = i),
                isLiked: isLiked,
                onLike: () => provider.toggleFavourite(item),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 32.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TitleBlock(
                        title: widget.title,
                        location: widget.location,
                        rating: widget.rating ?? '4.8',
                        description: widget.description ?? 'Discover one of Rwanda\'s most iconic experiences.',
                      ),

                      SizedBox(height: 10.h,),

                      ActivityInfoSection(info: _data.activityInfo),
                      _Spacer(),

                      HighlightsSection(highlights: _data.highlights),
                      _Spacer(),

                      DestinationBookingBox(
                        spots: _data.availableSpots,
                        onSeeAll: () {},
                      ),
                      _Spacer(),

                      ExtraInfo(
                        title: 'What to Expect',
                        data: _data,
                        tabIndex: 0,
                      ),
                      _Spacer(),

                      ExtraInfo(
                        title: 'What\'s Included',
                        data: _data,
                        tabIndex: 1,
                      ),
                      _Spacer(),

                      ExtraInfo(
                        title: 'Accessibility',
                        data: _data,
                        tabIndex: 3,
                      ),
                      _Spacer(),

                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DestinationInfoAllPage(
                                data: _data,
                                initialTab: 0,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 40.h,
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(100.r),
                            border: Border.all(color: AppColors.textHeading, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'See all',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textHeading,
                            ),
                          ),
                        ),
                      ),

                      _Spacer(),

                      ReviewsSection(
                          reviews: _data.reviews,
                          rating: widget.rating ?? '4.8'),
                      _Spacer(),

                      MapSection(meetingPoint: _data.activityInfo.meetingPoint),
                      _Spacer(),
                      ItinerarySection(stops: _data.itinerary),
                      _Spacer(),

                      SimilarPlacesSection(places: _data.similarPlaces),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Spacer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SizedBox(height: 32.h);
}

// ── Sticky bottom booking bar ─────────────────────────────────────────────────
class _StickyBookingBar extends StatelessWidget {
  final String price;
  final bool isAdded;
  final VoidCallback onAddToTrip;

  const _StickyBookingBar({
    required this.price,
    required this.isAdded,
    required this.onAddToTrip,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 12.h + bottomPad),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: const Border(top: BorderSide(color: AppColors.surfaceBorder, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: price,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    TextSpan(
                      text: ' /adult',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(width: 16.w),
          GestureDetector(
            onTap: onAddToTrip,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              height: 40.h,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: isAdded ? AppColors.primarySoft : AppColors.primary,
                borderRadius: BorderRadius.circular(100.r),
                border: isAdded ? Border.all(color: AppColors.primary, width: 1.5) : null,
                boxShadow: isAdded
                    ? null
                    : [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.32),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                'Check Availability' ,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: isAdded ? AppColors.primary : Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ── Title block ───────────────────────────────────────────────────────────────
class _TitleBlock extends StatefulWidget {
  final String title;
  final String location;
  final String rating;
  final String description;
  const _TitleBlock({
    required this.title,
    required this.location,
    required this.rating,
    required this.description,
  });

  @override
  State<_TitleBlock> createState() => _TitleBlockState();
}

class _TitleBlockState extends State<_TitleBlock> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.location_on_rounded, size: 13.w, color: AppColors.primary),
            SizedBox(width: 4.w),
            Text(
              widget.location,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textHeading,
                  height: 1.15,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rounded, color: Colors.amber, size: 15.w),
                  SizedBox(width: 4.w),
                  Text(
                    widget.rating,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14.sp,
                      color: AppColors.textHeading,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),
        Text(
          widget.description,
          maxLines: _expanded ? null : 3,
          overflow: _expanded ? null : TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
            height: 1.65,
          ),
        ),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Text(
              _expanded ? 'Show less' : 'Read more',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Sliver app bar (image carousel) ──────────────────────────────────────────
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
    required this.isLiked,
    required this.onLike,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 380.h,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.background,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      automaticallyImplyLeading: false,
      title: titleVisible
          ? Text(title,
              style: TextStyle(
                  color: AppColors.textHeading,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold))
          : null,
      leading: Padding(
        padding: EdgeInsets.only(left: 12.w, top: 6.h, bottom: 6.h),
        child: GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            decoration: BoxDecoration(
              color: titleVisible
                  ? AppColors.surfaceBorder.withOpacity(0.6)
                  : Colors.black.withOpacity(0.35),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                size: 16.w,
                color: titleVisible ? AppColors.textHeading : Colors.white),
          ),
        ),
      ),
      actions: [
        _Action(
          icon: isLiked
              ? Icons.favorite_rounded
              : Icons.favorite_outline_rounded,
          collapsed: titleVisible,
          onTap: onLike,
          isActive: isLiked,
        ),
        _Action(
          icon: Icons.share_outlined,
          collapsed: titleVisible,
          onTap: () {},
          isLast: true,
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: images.isEmpty ? 1 : images.length,
              onPageChanged: onPageChanged,
              itemBuilder: (_, i) {
                final url = images.isEmpty ? '' : images[i];
                return GestureDetector(
                  onTap: () => onImageTap(i),
                  child: CachedNetworkImage(
                    imageUrl: url,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        Container(color: AppColors.shimmerBase),
                    errorWidget: (_, __, ___) =>
                        Container(color: AppColors.shimmerBase),
                  ),
                );
              },
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.35),
                    Colors.transparent,
                    Colors.black.withOpacity(0.25),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
            if (images.length > 1)
              Positioned(
                bottom: 16.h,
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
            if (images.length > 1)
              Positioned(
                top: 56.h,
                right: 16.w,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.45),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    '${currentPage + 1}/${images.length}',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final IconData icon;
  final bool collapsed;
  final VoidCallback onTap;
  final bool isLast;
  final bool isActive;

  const _Action({
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
        width: 36.w,
        height: 36.w,
        margin: EdgeInsets.only(left: 8.w, right: isLast ? 16.w : 0),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.error.withOpacity(0.85)
              : collapsed
                  ? AppColors.surfaceBorder.withOpacity(0.6)
                  : Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon,
            size: 17.w,
            color: isActive
                ? Colors.white
                : collapsed
                    ? AppColors.textHeading
                    : Colors.white),
      ),
    );
  }
}

// ── Full screen image viewer ──────────────────────────────────────────────────
class FullScreenImageViewer extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  const FullScreenImageViewer(
      {super.key, required this.images, required this.initialIndex});

  @override
  State<FullScreenImageViewer> createState() => _FullScreenImageViewerState();
}

class _FullScreenImageViewerState extends State<FullScreenImageViewer> {
  late PageController _ctrl;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _ctrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _ctrl,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) => InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: widget.images[i],
                  fit: BoxFit.contain,
                  width: double.infinity,
                  placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(color: Colors.white)),
                  errorWidget: (_, __, ___) =>
                      const Icon(Icons.broken_image, color: Colors.white, size: 50),
                ),
              ),
            ),
          ),
          Positioned(
            top: 48.h,
            left: 16.w,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle),
                child: const Icon(Icons.close, color: Colors.white, size: 20),
              ),
            ),
          ),
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: Center(
              child: Text('${_current + 1} / ${widget.images.length}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
