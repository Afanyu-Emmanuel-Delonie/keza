import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../trips/domain/entities/trip_entities.dart';
import '../../trips/providers/trips_provider.dart';
import '../../trips/presentation/booking_form_sheet.dart';
import '../../../core/utils/trip_snackbar.dart';

// ── Data model for AI result ──────────────────────────────────────────────────

enum _ResultType { accommodation, tour, experience }

class _AiResult {
  final String id;
  final String name;
  final String location;
  final String image;
  final String price;
  final String priceLabel; // 'per night', 'per person', etc.
  final String rating;
  final String reviews;
  final _ResultType type;
  final String? tag; // 'Best Value', 'AI Pick', etc.

  const _AiResult({
    required this.id,
    required this.name,
    required this.location,
    required this.image,
    required this.price,
    required this.priceLabel,
    required this.rating,
    required this.reviews,
    required this.type,
    this.tag,
  });

  TripItem toTripItem() => TripItem(
        id: id,
        name: name,
        location: location,
        province: _inferProvince(location),
        image: image,
        price: price,
        rating: rating,
        isAccommodation: type == _ResultType.accommodation,
      );

  static String _inferProvince(String location) {
    final l = location.toLowerCase();
    if (l.contains('kigali')) return 'Kigali City';
    if (l.contains('musanze') || l.contains('volcanoes')) return 'Northern Province';
    if (l.contains('rubavu') || l.contains('kivu') || l.contains('gisenyi')) return 'Western Province';
    if (l.contains('akagera') || l.contains('kayonza')) return 'Eastern Province';
    if (l.contains('huye') || l.contains('nyungwe')) return 'Southern Province';
    return 'Kigali City';
  }
}

// ── Simulated AI result sets ──────────────────────────────────────────────────

const _kAccommodationResults = [
  _AiResult(
    id: 'ai_acc_0',
    name: 'Five Volcanoes Boutique Hotel',
    location: 'Musanze, Northern Province',
    image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=600&fit=crop',
    price: '\$120.00',
    priceLabel: 'per night',
    rating: '4.8',
    reviews: '214',
    type: _ResultType.accommodation,
    tag: 'AI Pick',
  ),
  _AiResult(
    id: 'ai_acc_1',
    name: 'Sabyinyo Silverback Lodge',
    location: 'Kinigi, Northern Province',
    image: 'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=600&fit=crop',
    price: '\$350.00',
    priceLabel: 'per night',
    rating: '4.9',
    reviews: '98',
    type: _ResultType.accommodation,
    tag: 'Luxury',
  ),
  _AiResult(
    id: 'ai_acc_2',
    name: 'Mountain Gorilla View Lodge',
    location: 'Musanze, Northern Province',
    image: 'https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=600&fit=crop',
    price: '\$85.00',
    priceLabel: 'per night',
    rating: '4.6',
    reviews: '156',
    type: _ResultType.accommodation,
    tag: 'Best Value',
  ),
];

const _kTourResults = [
  _AiResult(
    id: 'ai_tour_0',
    name: 'Gorilla Trekking — Full Day',
    location: 'Volcanoes National Park',
    image: 'https://images.unsplash.com/photo-1516426122078-c23e76319801?q=80&w=600&fit=crop',
    price: '\$1,500.00',
    priceLabel: 'per person',
    rating: '5.0',
    reviews: '432',
    type: _ResultType.tour,
    tag: 'AI Pick',
  ),
  _AiResult(
    id: 'ai_tour_1',
    name: 'Golden Monkey Trek',
    location: 'Volcanoes National Park',
    image: 'https://images.unsplash.com/photo-1547471080-7cc2caa01a7e?q=80&w=600&fit=crop',
    price: '\$100.00',
    priceLabel: 'per person',
    rating: '4.7',
    reviews: '189',
    type: _ResultType.tour,
    tag: 'Popular',
  ),
];

const _kKigaliResults = [
  _AiResult(
    id: 'ai_kig_0',
    name: 'Kigali Serena Hotel',
    location: 'Kiyovu, Kigali',
    image: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=600&fit=crop',
    price: '\$180.00',
    priceLabel: 'per night',
    rating: '4.9',
    reviews: '312',
    type: _ResultType.accommodation,
    tag: 'AI Pick',
  ),
  _AiResult(
    id: 'ai_kig_1',
    name: 'Radisson Blu Kigali',
    location: 'Gasabo, Kigali',
    image: 'https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=600&fit=crop',
    price: '\$150.00',
    priceLabel: 'per night',
    rating: '4.7',
    reviews: '198',
    type: _ResultType.accommodation,
  ),
  _AiResult(
    id: 'ai_kig_2',
    name: 'Kigali City Tour — Half Day',
    location: 'Kigali City',
    image: 'https://images.unsplash.com/photo-1523805009345-7448845a9e53?q=80&w=600&fit=crop',
    price: '\$45.00',
    priceLabel: 'per person',
    rating: '4.6',
    reviews: '87',
    type: _ResultType.tour,
  ),
];

// ── Screen ────────────────────────────────────────────────────────────────────

class ExploreBookAiScreen extends StatefulWidget {
  final String? initialQuery;
  const ExploreBookAiScreen({super.key, this.initialQuery});

  @override
  State<ExploreBookAiScreen> createState() => _ExploreBookAiScreenState();
}

class _ExploreBookAiScreenState extends State<ExploreBookAiScreen> {
  final _inputCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  bool _isSearching = false;
  bool _hasResults = false;
  String _aiSummary = '';
  List<_AiResult> _results = [];
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _inputCtrl.text = widget.initialQuery!;
      WidgetsBinding.instance.addPostFrameCallback((_) => _search(widget.initialQuery!));
    }
  }

  @override
  void dispose() {
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _search(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    setState(() {
      _isSearching = true;
      _hasResults = false;
      _currentQuery = trimmed;
    });

    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      final (summary, results) = _simulateSearch(trimmed);
      setState(() {
        _isSearching = false;
        _hasResults = true;
        _aiSummary = summary;
        _results = results;
      });
    });
  }

  (String, List<_AiResult>) _simulateSearch(String query) {
    final lower = query.toLowerCase();
    if (lower.contains('gorilla') || lower.contains('volcanoes') || lower.contains('musanze')) {
      return (
        'Found ${_kAccommodationResults.length + _kTourResults.length} options near Volcanoes National Park — sorted by AI recommendation.',
        [..._kTourResults, ..._kAccommodationResults],
      );
    }
    if (lower.contains('kigali')) {
      return (
        'Found ${_kKigaliResults.length} options in Kigali — hotels and experiences sorted for you.',
        _kKigaliResults,
      );
    }
    return (
      'Found ${_kAccommodationResults.length} accommodation options matching your search.',
      _kAccommodationResults,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              _SearchHeader(
                controller: _inputCtrl,
                onSearch: _search,
                isSearching: _isSearching,
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  child: _isSearching
                      ? _SearchingState(key: const ValueKey('searching'))
                      : !_hasResults
                          ? _IdleState(
                              key: const ValueKey('idle'),
                              onChipTap: (q) {
                                _inputCtrl.text = q;
                                _search(q);
                              },
                            )
                          : _ResultsState(
                              key: ValueKey(_currentQuery),
                              summary: _aiSummary,
                              results: _results,
                              scrollCtrl: _scrollCtrl,
                            ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Search header ─────────────────────────────────────────────────────────────

class _SearchHeader extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSearch;
  final bool isSearching;

  const _SearchHeader({
    required this.controller,
    required this.onSearch,
    required this.isSearching,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
              width: 38.w,
              height: 38.w,
              decoration: BoxDecoration(
                color: AppColors.surfaceBorder.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  size: 16.w, color: AppColors.textHeading),
            ),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Container(
              height: 44.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Row(
                children: [
                  Icon(Icons.auto_awesome_rounded,
                      size: 16.w, color: AppColors.primary),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      style: TextStyle(
                          fontSize: 14.sp, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'What are you looking for?',
                        hintStyle: TextStyle(
                            fontSize: 14.sp, color: AppColors.textDisabled),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      textInputAction: TextInputAction.search,
                      onSubmitted: onSearch,
                    ),
                  ),
                  if (isSearching)
                    SizedBox(
                      width: 16.w,
                      height: 16.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () => onSearch(controller.text),
                      child: Icon(Icons.search_rounded,
                          size: 18.w, color: AppColors.textSecondary),
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

// ── Idle state ────────────────────────────────────────────────────────────────

class _IdleState extends StatelessWidget {
  final ValueChanged<String> onChipTap;
  const _IdleState({super.key, required this.onChipTap});

  static const _suggestions = [
    ('🦍', 'Lodge near Volcanoes NP'),
    ('🏙️', 'Hotels in Kigali'),
    ('🌊', 'Lakeside stays in Gisenyi'),
    ('🌿', 'Eco lodges in Nyungwe'),
    ('🎒', 'Budget stays under \$80'),
    ('⭐', 'Top rated tours'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: AppColors.aiGradient,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Explore & Book with AI',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'Describe what you\'re looking for — AI finds the best options and you confirm.',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.8),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 12.w),
                Opacity(
                  opacity: 0.2,
                  child: SvgPicture.asset(
                    'assets/general/main-logo.svg',
                    width: 52.w,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Try searching for',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textHeading,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _suggestions.map((s) {
              return GestureDetector(
                onTap: () => onChipTap(s.$2),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: AppColors.surfaceBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(s.$1, style: TextStyle(fontSize: 13.sp)),
                      SizedBox(width: 6.w),
                      Text(
                        s.$2,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Searching state ───────────────────────────────────────────────────────────

class _SearchingState extends StatelessWidget {
  const _SearchingState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 48.w,
            height: 48.w,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'Keza AI is searching...',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textHeading,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Finding the best options for you',
            style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ── Results state ─────────────────────────────────────────────────────────────

class _ResultsState extends StatelessWidget {
  final String summary;
  final List<_AiResult> results;
  final ScrollController scrollCtrl;

  const _ResultsState({
    super.key,
    required this.summary,
    required this.results,
    required this.scrollCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollCtrl,
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
      itemCount: results.length + 1,
      itemBuilder: (_, i) {
        if (i == 0) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Row(
              children: [
                Container(
                  width: 28.w,
                  height: 28.w,
                  decoration: BoxDecoration(
                    gradient: AppColors.aiGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/general/main-logo.svg',
                      width: 14.w,
                      colorFilter: const ColorFilter.mode(
                          Colors.white, BlendMode.srcIn),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    summary,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return _ResultCard(result: results[i - 1]);
      },
    );
  }
}

// ── Result card ───────────────────────────────────────────────────────────────

class _ResultCard extends StatelessWidget {
  final _AiResult result;
  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    return Consumer<TripsProvider>(
      builder: (context, provider, _) {
        final tripItem = result.toTripItem();
        final booked = provider.isAccommodationSelected(tripItem.id);

        return Container(
          margin: EdgeInsets.only(bottom: 14.h),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Image ──
              ClipRRect(
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(16.r)),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: result.image,
                      height: 160.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(height: 160.h, color: AppColors.shimmerBase),
                      errorWidget: (_, __, ___) =>
                          Container(height: 160.h, color: AppColors.shimmerBase),
                    ),
                    // type badge
                    Positioned(
                      top: 12.h,
                      left: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 5.h),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _typeIcon(result.type),
                              size: 11.w,
                              color: Colors.white,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              _typeLabel(result.type),
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // AI tag
                    if (result.tag != null)
                      Positioned(
                        top: 12.h,
                        right: 12.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            gradient: AppColors.aiGradient,
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.auto_awesome_rounded,
                                  size: 10.w, color: Colors.white),
                              SizedBox(width: 4.w),
                              Text(
                                result.tag!,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Details ──
              Padding(
                padding: EdgeInsets.all(14.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.name,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textHeading,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 12.w, color: AppColors.textSecondary),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            result.location,
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: AppColors.textSecondary),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        // rating
                        Icon(Icons.star_rounded,
                            color: Colors.amber, size: 14.w),
                        SizedBox(width: 3.w),
                        Text(
                          result.rating,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textHeading,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '(${result.reviews})',
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textSecondary),
                        ),
                        const Spacer(),
                        // price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              result.price,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                            Text(
                              result.priceLabel,
                              style: TextStyle(
                                  fontSize: 10.sp,
                                  color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    // ── Confirm button ──
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: booked
                            ? () => provider
                                .cancelAccommodationBooking(tripItem.province)
                            : () async {
                                if (result.type == _ResultType.accommodation) {
                                  final booking = await BookingFormSheet.show(
                                      context, tripItem);
                                  if (booking != null) {
                                    provider.confirmAccommodationBooking(booking);
                                    if (context.mounted) {
                                      showTopSnackbar(
                                        context,
                                        '${result.name} booked!',
                                        icon: Icons.hotel_rounded,
                                      );
                                    }
                                  }
                                } else {
                                  // Tours/experiences — direct confirm
                                  if (context.mounted) {
                                    showTopSnackbar(
                                      context,
                                      '${result.name} added to your trip!',
                                      icon: Icons.check_circle_rounded,
                                    );
                                  }
                                }
                              },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: EdgeInsets.symmetric(vertical: 13.h),
                          decoration: BoxDecoration(
                            color: booked
                                ? AppColors.errorSoft
                                : AppColors.primary,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                booked
                                    ? Icons.close_rounded
                                    : Icons.check_rounded,
                                color: booked
                                    ? AppColors.error
                                    : Colors.white,
                                size: 16.w,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                booked ? 'Cancel Booking' : 'Confirm & Book',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  color: booked
                                      ? AppColors.error
                                      : Colors.white,
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
            ],
          ),
        );
      },
    );
  }

  IconData _typeIcon(_ResultType type) {
    switch (type) {
      case _ResultType.accommodation:
        return Icons.hotel_rounded;
      case _ResultType.tour:
        return Icons.hiking_rounded;
      case _ResultType.experience:
        return Icons.attractions_rounded;
    }
  }

  String _typeLabel(_ResultType type) {
    switch (type) {
      case _ResultType.accommodation:
        return 'Stay';
      case _ResultType.tour:
        return 'Tour';
      case _ResultType.experience:
        return 'Experience';
    }
  }
}
