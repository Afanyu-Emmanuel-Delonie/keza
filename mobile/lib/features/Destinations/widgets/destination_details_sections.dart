import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/animated_card_item.dart';
import '../domain/models/destination_details_model.dart';
import '../presentation/destination_details/destination_details_screen.dart';
import 'destination_info_all_page.dart';

// ── Section title ─────────────────────────────────────────────────────────────
class DestSectionTitle extends StatelessWidget {
  final String text;
  const DestSectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textHeading,
          letterSpacing: -0.2,
        ),
      );
}


// ── 1. Highlights ─────────────────────────────────────────────────────────────
class HighlightsSection extends StatelessWidget {
  final List<String> highlights;
  const HighlightsSection({super.key, required this.highlights});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DestSectionTitle('Highlights'),
        SizedBox(height: 12.h),
        ...highlights.map(
          (h) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_rounded, size: 15.w, color: AppColors.primary),
                SizedBox(width: 10.w),
                Expanded(
                  child: Text(
                    h,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── 2. Activity Info ──────────────────────────────────────────────────────────
class ActivityInfoSection extends StatelessWidget {
  final ActivityInfo info;
  const ActivityInfoSection({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            _InfoTile(icon: Icons.cancel_outlined, label: 'Cancellation', value: info.cancellationPolicy, color: Colors.red.shade300),
            _Divider(),
            _InfoTile(icon: Icons.person_outline_rounded, label: 'Tour Guide', value: info.tourGuide, color: AppColors.primary),
            _Divider(),
            _InfoTile(icon: Icons.access_time_rounded, label: 'Duration', value: info.duration, color: Colors.amber.shade300),
            _Divider(),
            _InfoTile(icon: Icons.language_rounded, label: 'Languages', value: info.languages.join(' · '), color: Colors.blue.shade300),
            _Divider(),
            _InfoTile(icon: Icons.place_outlined, label: 'Meeting Point', value: info.meetingPoint, color: Colors.green.shade300),
            _Divider(),
            _InfoTile(icon: Icons.groups_outlined, label: 'Group Size', value: info.groupSize, isLast: true, color: Colors.purple.shade300),
          ],
      );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;
  final Color? color;
  const _InfoTile({required this.icon, required this.label, required this.value, this.isLast = false, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, isLast ? 12.h : 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24.w, color: color ?? AppColors.textSecondary),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
                SizedBox(height: 2.h),
                Text(value,
                    style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textPrimary,
                        height: 1.45)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Divider(
        height: 0.5, indent: 14.w, endIndent: 14.w, color: AppColors.surfaceBorder),
  );
}


class ExtraInfo extends StatelessWidget {
  final String title;
  final dynamic data;
  final int tabIndex;

  const ExtraInfo({
    super.key,
    required this.title,
    required this.data,
    required this.tabIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textHeading,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DestinationInfoAllPage(
                    data: data,
                    initialTab: tabIndex,
                  ),
                ),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16.w,
                color: AppColors.textHeading,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Divider(
          color: AppColors.surfaceBorder,
          thickness: 1.h,
          height: 1.h,
        ),
      ],
    );
  }
}

// ── 3. Reviews ────────────────────────────────────────────────────────────────
class ReviewsSection extends StatelessWidget {
  final List<DestReview> reviews;
  final String rating;
  const ReviewsSection({super.key, required this.reviews, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DestSectionTitle('Reviews $rating (${reviews.length})'),
        SizedBox(height: 14.h),
        SizedBox(
          height: 185.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: EdgeInsets.zero,
            itemCount: reviews.length,
            itemBuilder: (_, i) => _ReviewCard(review: reviews[i]),
          ),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final DestReview review;
  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260.w,
      margin: EdgeInsets.only(right: 14.w),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 17.r,
                backgroundColor: AppColors.surfaceBorder,
                child: Text(review.avatar,
                    style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary)),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.name,
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textHeading)),
                    Text(review.date,
                        style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star_rounded, color: Colors.amber, size: 13.w),
                  SizedBox(width: 3.w),
                  Text(review.rating.toStringAsFixed(1),
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textHeading)),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Expanded(
            child: Text(
              review.comment,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                  height: 1.55),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 4. Itinerary ──────────────────────────────────────────────────────────────
class ItinerarySection extends StatelessWidget {
  final List<DestItineraryStop> stops;
  final DestinationDetailData? data;
  const ItinerarySection({super.key, required this.stops, this.data});

  static const _bubbleColors = [
    Color(0xFF00A651),
    Color(0xFF1A73E8),
    Color(0xFFB06000),
    Color(0xFF9C27B0),
    Color(0xFFD93025),
    Color(0xFF00897B),
  ];

  @override
  Widget build(BuildContext context) {
    final preview = stops.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DestSectionTitle('Itinerary'),
        SizedBox(height: 14.h),
        ...preview.asMap().entries.map((e) => _ItineraryRow(
              stop: e.value,
              isLast: e.key == preview.length - 1,
              color: _bubbleColors[e.key % _bubbleColors.length],
            )),
      ],
    );
  }
}

class _ItineraryRow extends StatelessWidget {
  final DestItineraryStop stop;
  final bool isLast;
  final Color color;
  const _ItineraryRow({required this.stop, required this.isLast, required this.color});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  stop.time,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    color: color.withOpacity(0.35),
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                  ),
                ),
            ],
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stop.title,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textHeading)),
                  SizedBox(height: 3.h),
                  Text(stop.detail,
                      style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textSecondary,
                          height: 1.5)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 7. Map ────────────────────────────────────────────────────────────────────
class MapSection extends StatelessWidget {
  final String meetingPoint;
  const MapSection({super.key, required this.meetingPoint});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DestSectionTitle('Location'),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: () {},
          child: Container(
            height: 160.h,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: Image.network(
                    'https://maps.googleapis.com/maps/api/staticmap?center=Rwanda&zoom=8&size=600x300&maptype=roadmap&key=DEMO',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFF0F4F0),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.map_outlined,
                                size: 36.w, color: AppColors.textSecondary),
                            SizedBox(height: 6.h),
                            Text('Map View',
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(14.r)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.place_outlined, size: 15.w, color: AppColors.primary),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(meetingPoint,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textPrimary)),
                        ),
                        Text('Open Maps',
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: AppColors.info,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── 8. Similar places ─────────────────────────────────────────────────────────
class SimilarPlacesSection extends StatelessWidget {
  final List<Map<String, String>> places;
  const SimilarPlacesSection({super.key, required this.places});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DestSectionTitle('You Might Also Like'),
        SizedBox(height: 14.h),
        SizedBox(
          height: 210.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            padding: EdgeInsets.zero,
            itemCount: places.length,
            itemBuilder: (_, i) {
              final p = places[i];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  SmoothPageRoute(
                    page: DestinationDetails(
                      title: p['name']!,
                      location: p['location']!,
                      images: [p['image']!],
                      price: p['price'],
                      rating: p['rating'],
                    ),
                  ),
                ),
                child: Container(
                  width: 180.w,
                  margin: EdgeInsets.only(right: 14.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.r),
                    color: AppColors.shimmerBase,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.r),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: p['image']!,
                          fit: BoxFit.cover,
                          placeholder: (_, __) =>
                              Container(color: AppColors.shimmerBase),
                          errorWidget: (_, __, ___) =>
                              Container(color: AppColors.shimmerBase),
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.75),
                              ],
                              stops: const [0.4, 1.0],
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
                                p['name']!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.sp,
                                  height: 1.25,
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Row(
                                children: [
                                  Icon(Icons.star_rounded,
                                      color: Colors.amber, size: 11.w),
                                  SizedBox(width: 3.w),
                                  Text(
                                    p['rating']!,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const Spacer(),
                                  Text(
                                    p['price']!,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w500),
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
        ),
      ],
    );
  }
}
