import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/app_colors.dart';
import '../widgets/transport_option_card.dart';

enum TransportMode { tourVehicle, selfDrive, airportPickup }

class TransportSection extends StatelessWidget {
  final TransportMode selected;
  final ValueChanged<TransportMode> onChanged;

  const TransportSection({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  static const _options = [
    _TransportOption(
      mode: TransportMode.tourVehicle,
      icon: Icons.directions_bus_rounded,
      label: 'Tour Vehicle',
      subtitle: 'Guided & comfortable',
    ),
    _TransportOption(
      mode: TransportMode.selfDrive,
      icon: Icons.directions_car_rounded,
      label: 'Self Drive',
      subtitle: 'Rent & explore freely',
    ),
    _TransportOption(
      mode: TransportMode.airportPickup,
      icon: Icons.flight_land_rounded,
      label: 'Airport Pickup',
      subtitle: 'Door-to-door service',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transportation',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textHeading,
            letterSpacing: -0.3,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'How would you like to get around?',
          style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
        ),
        SizedBox(height: 14.h),
        Row(
          children: _options
              .map(
                (opt) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: opt.mode != TransportMode.airportPickup ? 10.w : 0,
                    ),
                    child: TransportOptionCard(
                      icon: opt.icon,
                      label: opt.label,
                      subtitle: opt.subtitle,
                      selected: selected == opt.mode,
                      onTap: () => onChanged(opt.mode),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _TransportOption {
  final TransportMode mode;
  final IconData icon;
  final String label;
  final String subtitle;

  const _TransportOption({
    required this.mode,
    required this.icon,
    required this.label,
    required this.subtitle,
  });
}
