import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../widgets/accommodation_card.dart';

enum AccommodationMode { chooseOwn, recommended }

class AccommodationSection extends StatelessWidget {
  final AccommodationMode mode;
  final String? selectedHotelName;
  final ValueChanged<AccommodationMode> onModeChanged;
  final ValueChanged<String> onHotelSelected;

  const AccommodationSection({
    super.key,
    required this.mode,
    required this.selectedHotelName,
    required this.onModeChanged,
    required this.onHotelSelected,
  });

  static const _hotels = [
    _Hotel(
      name: 'Kigali Serena Hotel',
      imageUrl:
          'https://images.unsplash.com/photo-1551882547-ff40c63fe5fa?q=80&w=400&fit=crop',
      stars: 5.0,
      distance: '0.3 km from activities',
      pricePerNight: 180,
    ),
    _Hotel(
      name: 'Lake Kivu Serena',
      imageUrl:
          'https://images.unsplash.com/photo-1540541338287-41700207dee6?q=80&w=400&fit=crop',
      stars: 4.5,
      distance: '0.8 km from activities',
      pricePerNight: 150,
    ),
    _Hotel(
      name: 'Gorilla Nest Lodge',
      imageUrl:
          'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?q=80&w=400&fit=crop',
      stars: 4.0,
      distance: '1.2 km from activities',
      pricePerNight: 200,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle('Where Would You Like To Stay?'),
        SizedBox(height: 14.h),
        Row(
          children: [
            Expanded(
              child: _ModeCard(
                icon: Icons.search_rounded,
                label: 'Choose My\nOwn Stay',
                selected: mode == AccommodationMode.chooseOwn,
                onTap: () => onModeChanged(AccommodationMode.chooseOwn),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _ModeCard(
                icon: Icons.auto_awesome_rounded,
                label: 'Recommended\nNear Activities',
                selected: mode == AccommodationMode.recommended,
                onTap: () => onModeChanged(AccommodationMode.recommended),
              ),
            ),
          ],
        ),
        if (mode == AccommodationMode.recommended) ...[
          SizedBox(height: 18.h),
          Text(
            'Top picks near your destinations',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 10.h),
          ..._hotels.map(
            (h) => AccommodationCard(
              imageUrl: h.imageUrl,
              name: h.name,
              stars: h.stars,
              distanceFromActivities: h.distance,
              pricePerNight: h.pricePerNight,
              selected: selectedHotelName == h.name,
              onTap: () => onHotelSelected(h.name),
            ),
          ),
        ],
      ],
    );
  }
}

class _Hotel {
  final String name;
  final String imageUrl;
  final double stars;
  final String distance;
  final double pricePerNight;

  const _Hotel({
    required this.name,
    required this.imageUrl,
    required this.stars,
    required this.distance,
    required this.pricePerNight,
  });
}

class _ModeCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ModeCard({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 14.w),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryDark : AppColors.surface,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: selected ? AppColors.primaryDark : AppColors.surfaceBorder,
            width: 1.5,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primaryDark.withOpacity(0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white.withOpacity(0.15)
                    : AppColors.primarySoft,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon,
                  size: 18.w,
                  color: selected ? Colors.white : AppColors.primary),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: selected ? Colors.white : AppColors.textHeading,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textHeading,
        letterSpacing: -0.3,
      ),
    );
  }
}
