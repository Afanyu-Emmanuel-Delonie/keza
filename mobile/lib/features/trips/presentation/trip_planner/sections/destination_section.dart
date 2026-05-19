import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../providers/trips_provider.dart';
import '../widgets/destination_card.dart';

// Destination groups derived from selected trips
class _DestGroup {
  final String groupTitle;
  final String nights;
  final String distance;
  final int activitiesCount;
  final String imageUrl;
  final List<String> placeNames;

  const _DestGroup({
    required this.groupTitle,
    required this.nights,
    required this.distance,
    required this.activitiesCount,
    required this.imageUrl,
    required this.placeNames,
  });
}

// Maps province → display group metadata
_DestGroup _groupFor(String province, List<TripItem> trips) {
  final places = trips.map((t) => t.name).toList();
  final image = trips.first.image;

  switch (province) {
    case 'Kigali City':
      return _DestGroup(
        groupTitle: 'Kigali Stay',
        nights: '${trips.length + 1} Nights',
        distance: '~5 km apart',
        activitiesCount: trips.length * 3,
        imageUrl: image,
        placeNames: places,
      );
    case 'Western Province':
      return _DestGroup(
        groupTitle: 'Western Rwanda Experience',
        nights: '${trips.length + 2} Nights',
        distance: '~12 km apart',
        activitiesCount: trips.length * 4,
        imageUrl: image,
        placeNames: places,
      );
    case 'Northern Province':
      return _DestGroup(
        groupTitle: 'Northern Highlands',
        nights: '${trips.length + 1} Nights',
        distance: '~8 km apart',
        activitiesCount: trips.length * 3,
        imageUrl: image,
        placeNames: places,
      );
    case 'Eastern Province':
      return _DestGroup(
        groupTitle: 'Eastern Safari Zone',
        nights: '${trips.length} Nights',
        distance: '~20 km apart',
        activitiesCount: trips.length * 2,
        imageUrl: image,
        placeNames: places,
      );
    default:
      return _DestGroup(
        groupTitle: province,
        nights: '${trips.length} Nights',
        distance: 'Various',
        activitiesCount: trips.length * 2,
        imageUrl: image,
        placeNames: places,
      );
  }
}

class DestinationSection extends StatelessWidget {
  const DestinationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final grouped = context.watch<TripsProvider>().tripsByProvince;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Your Trip',
          subtitle: '${grouped.values.fold(0, (s, l) => s + l.length)} destinations selected',
        ),
        SizedBox(height: 16.h),
        ...grouped.entries.map((e) {
          final group = _groupFor(e.key, e.value);
          return DestinationCard(
            groupTitle: group.groupTitle,
            nights: group.nights,
            distance: group.distance,
            activitiesCount: group.activitiesCount,
            imageUrl: group.imageUrl,
            placeNames: group.placeNames,
          );
        }),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textHeading,
                letterSpacing: -0.3,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              subtitle,
              style: TextStyle(
                  fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}
