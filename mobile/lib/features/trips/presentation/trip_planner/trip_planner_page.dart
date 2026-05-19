import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../providers/trips_provider.dart';
import 'sections/destination_section.dart';
import 'sections/accommodation_section.dart';
import 'sections/transport_section.dart';
import 'sections/pricing_section.dart';
import 'widgets/checkout_bar.dart';

class TripPlannerPage extends StatefulWidget {
  const TripPlannerPage({super.key});

  @override
  State<TripPlannerPage> createState() => _TripPlannerPageState();
}

class _TripPlannerPageState extends State<TripPlannerPage> {
  AccommodationMode _accommodationMode = AccommodationMode.recommended;
  String? _selectedHotel = 'Kigali Serena Hotel';
  TransportMode _transportMode = TransportMode.tourVehicle;

  // Pricing constants
  static const double _transportCost = 80.0;
  static const double _serviceFee = 25.0;
  static const Map<String, double> _hotelPrices = {
    'Kigali Serena Hotel': 180,
    'Lake Kivu Serena': 150,
    'Gorilla Nest Lodge': 200,
  };
  static const Map<TransportMode, double> _transportPrices = {
    TransportMode.tourVehicle: 80,
    TransportMode.selfDrive: 50,
    TransportMode.airportPickup: 120,
  };

  double _accommodationCost(TripsProvider provider) {
    if (_accommodationMode == AccommodationMode.chooseOwn) return 0;
    return _hotelPrices[_selectedHotel] ?? 0;
  }

  double _total(TripsProvider provider) {
    return provider.selectedTripCost +
        _accommodationCost(provider) +
        (_transportPrices[_transportMode] ?? _transportCost) +
        _serviceFee;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TripsProvider>();
    final top = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Column(
          children: [
            // ── App bar ──────────────────────────────────────
            _AppBar(top: top, onBack: () => context.pop()),

            // ── Scrollable content ───────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1 — Destinations
                    const DestinationSection(),
                    SizedBox(height: 32.h),

                    // Section 2 — Accommodation
                    AccommodationSection(
                      mode: _accommodationMode,
                      selectedHotelName: _selectedHotel,
                      onModeChanged: (m) =>
                          setState(() => _accommodationMode = m),
                      onHotelSelected: (name) =>
                          setState(() => _selectedHotel = name),
                    ),
                    SizedBox(height: 32.h),

                    // Section 3 — Transport
                    TransportSection(
                      selected: _transportMode,
                      onChanged: (m) => setState(() => _transportMode = m),
                    ),
                    SizedBox(height: 32.h),

                    // Section 4 — Pricing
                    PricingSection(
                      accommodation: _accommodationCost(provider),
                      transport:
                          _transportPrices[_transportMode] ?? _transportCost,
                      activities: provider.selectedTripCost,
                      serviceFee: _serviceFee,
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),

            // Section 5 — Sticky checkout bar
            CheckoutBar(
              total: _total(provider),
              onCheckout: () => context.push('/checkout'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  final double top;
  final VoidCallback onBack;

  const _AppBar({required this.top, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.only(
          top: top + 10.h, left: 8.w, right: 20.w, bottom: 12.h),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            iconSize: 20.w,
            color: AppColors.textHeading,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plan Your Trip',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeading,
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  'Rwanda · Customise your experience',
                  style: TextStyle(
                      fontSize: 11.sp, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.tune_rounded,
                size: 18.w, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
