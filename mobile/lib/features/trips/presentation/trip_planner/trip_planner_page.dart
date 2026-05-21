import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../providers/trips_provider.dart';
import 'sections/accommodation_section.dart';
import 'sections/pricing_section.dart';
import 'sections/transport_section.dart';
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
  late final TextEditingController _notesCtrl;

  static const double _transportCostFallback = 80.0;
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

  @override
  void initState() {
    super.initState();
    final profile = context.read<TripsProvider>().tripProfile;
    _notesCtrl = TextEditingController(text: profile.notes);
    _notesCtrl.addListener(_syncNotes);
  }

  @override
  void dispose() {
    _notesCtrl.removeListener(_syncNotes);
    _notesCtrl.dispose();
    super.dispose();
  }

  void _syncNotes() {
    if (!mounted) return;
    final provider = context.read<TripsProvider>();
    provider.updateTripProfile(provider.tripProfile.copyWith(notes: _notesCtrl.text));
  }

  void _updateProfile(TripsProvider provider, TripPlanningProfile Function(TripPlanningProfile profile) updater) {
    provider.updateTripProfile(updater(provider.tripProfile));
  }

  double _accommodationCost() {
    if (_accommodationMode == AccommodationMode.chooseOwn) return 0;
    return _hotelPrices[_selectedHotel] ?? 0;
  }

  double _transportCost() {
    return _transportPrices[_transportMode] ?? _transportCostFallback;
  }

  double _previewTotal(TripsProvider provider) {
    return provider.selectedTripCost + _accommodationCost() + _transportCost() + _serviceFee;
  }

  double _selectedPlanTotal(TripsProvider provider) {
    return provider.selectedPlan?.estimatedCost ?? provider.grandTotal;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TripsProvider>();
    final profile = provider.tripProfile;
    final plans = provider.planOptions;
    final selectedPlan = provider.selectedPlan;
    final top = MediaQuery.of(context).padding.top;
    final hasTrips = provider.tripsByProvince.isNotEmpty;
    final selectedPlanTotal = _selectedPlanTotal(provider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              _Header(top: top, onBack: () => context.pop()),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SectionTitle(
                        title: 'Trip Builder',
                        subtitle: hasTrips
                            ? '${provider.selectedTrips.isNotEmpty ? provider.selectedTrips.length : provider.addedTrips.length} places ready to shape into a route'
                            : 'Add places to My Trip first so Keza can generate a route for you',
                      ),
                      SizedBox(height: 14.h),
                      _TripBriefSection(
                        profile: profile,
                        onPeopleChanged: (value) => _updateProfile(
                          provider,
                          (p) => p.copyWith(people: value.clamp(1, 12) as int),
                        ),
                        onDaysChanged: (value) => _updateProfile(
                          provider,
                          (p) => p.copyWith(days: value.clamp(1, 10) as int),
                        ),
                        onBudgetChanged: (value) => _updateProfile(
                          provider,
                          (p) => p.copyWith(budget: value),
                        ),
                        onPaceChanged: (pace) => _updateProfile(
                          provider,
                          (p) => p.copyWith(pace: pace),
                        ),
                        onTransportChanged: (mode) => _updateProfile(
                          provider,
                          (p) => p.copyWith(transportStyle: mode),
                        ),
                        onStayChanged: (mode) => _updateProfile(
                          provider,
                          (p) => p.copyWith(stayStyle: mode),
                        ),
                        onInterestToggle: (interest) {
                          final interests = [...profile.interests];
                          if (interests.contains(interest)) {
                            interests.remove(interest);
                          } else {
                            interests.add(interest);
                          }
                          _updateProfile(provider, (p) => p.copyWith(interests: interests));
                        },
                        notesController: _notesCtrl,
                      ),
                      SizedBox(height: 20.h),
                      _SelectedPlacesSection(groupedTrips: provider.tripsByProvince),
                      SizedBox(height: 20.h),
                      _PlanOptionsSection(
                        plans: plans,
                        selectedPlanType: provider.selectedPlanType,
                        onSelect: provider.selectPlanType,
                      ),
                      SizedBox(height: 20.h),
                      _SelectedPlanPreview(
                        selectedPlan: selectedPlan,
                        budget: profile.budget,
                        total: selectedPlanTotal,
                      ),
                      SizedBox(height: 20.h),
                      if (hasTrips) ...[
                        AccommodationSection(
                          mode: _accommodationMode,
                          selectedHotelName: _selectedHotel,
                          onModeChanged: (m) => setState(() => _accommodationMode = m),
                          onHotelSelected: (name) => setState(() => _selectedHotel = name),
                        ),
                        SizedBox(height: 20.h),
                        TransportSection(
                          selected: _transportMode,
                          onChanged: (m) => setState(() => _transportMode = m),
                        ),
                        SizedBox(height: 20.h),
                        PricingSection(
                          accommodation: _accommodationCost(),
                          transport: _transportCost(),
                          activities: provider.selectedTripCost,
                          serviceFee: _serviceFee,
                        ),
                        SizedBox(height: 20.h),
                      ],
                      _DayByDaySection(selectedPlan: selectedPlan, plans: plans),
                      SizedBox(height: 20.h),
                      _SummaryHintCard(
                        title: 'Checkout ready',
                        subtitle: hasTrips
                            ? 'Choose the plan that matches your budget, then move to checkout to confirm stays and payment.'
                            : 'Once you add destinations, Keza will build the day plan, accommodation suggestions, and pricing.',
                      ),
                      SizedBox(height: 80.h),
                    ],
                  ),
                ),
              ),
              CheckoutBar(
                total: selectedPlanTotal,
                onCheckout: () => context.push('/checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final double top;
  final VoidCallback onBack;

  const _Header({required this.top, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.only(
        top: top + 6.h,
        left: 8.w,
        right: 20.w,
        bottom: 12.h,
      ),
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
                SizedBox(height: 2.h),
                Text(
                  'Tell Keza what you need, then choose the best trip style',
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
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
            child: Icon(Icons.tune_rounded, size: 18.w, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SectionTitle({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
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
        SizedBox(height: 4.h),
        Text(
          subtitle,
          style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

class _TripBriefSection extends StatelessWidget {
  final TripPlanningProfile profile;
  final ValueChanged<int> onPeopleChanged;
  final ValueChanged<int> onDaysChanged;
  final ValueChanged<double> onBudgetChanged;
  final ValueChanged<TripPace> onPaceChanged;
  final ValueChanged<TripTransportStyle> onTransportChanged;
  final ValueChanged<TripStayStyle> onStayChanged;
  final ValueChanged<String> onInterestToggle;
  final TextEditingController notesController;

  const _TripBriefSection({
    required this.profile,
    required this.onPeopleChanged,
    required this.onDaysChanged,
    required this.onBudgetChanged,
    required this.onPaceChanged,
    required this.onTransportChanged,
    required this.onStayChanged,
    required this.onInterestToggle,
    required this.notesController,
  });

  static const _interestOptions = [
    'Culture',
    'Nature',
    'Wildlife',
    'Food',
    'Adventure',
    'Relaxation',
    'Family',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trip details',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textHeading,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Set the basics so Keza can shape a plan that actually fits.',
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 14.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth > 560 ? (constraints.maxWidth - 12.w) / 2 : constraints.maxWidth;
              return Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: [
                  SizedBox(
                    width: cardWidth,
                    child: _StepperCard(
                      icon: Icons.groups_rounded,
                      title: 'People',
                      value: '${profile.people}',
                      subtitle: 'Traveling together',
                      onDecrement: profile.people > 1 ? () => onPeopleChanged(profile.people - 1) : null,
                      onIncrement: () => onPeopleChanged(profile.people + 1),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _StepperCard(
                      icon: Icons.calendar_month_rounded,
                      title: 'Days',
                      value: '${profile.days}',
                      subtitle: 'Planned route length',
                      onDecrement: profile.days > 1 ? () => onDaysChanged(profile.days - 1) : null,
                      onIncrement: () => onDaysChanged(profile.days + 1),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _BudgetCard(
                      budget: profile.budget,
                      onChanged: onBudgetChanged,
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _SelectionCard(
                      title: 'Pace',
                      subtitle: 'How busy should the trip feel?',
                      child: _ChoiceRow<TripPace>(
                        value: profile.pace,
                        items: const [
                          (TripPace.relaxed, 'Relaxed'),
                          (TripPace.balanced, 'Balanced'),
                          (TripPace.adventurous, 'Fast'),
                        ],
                        onChanged: onPaceChanged,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _SelectionCard(
                      title: 'Transport',
                      subtitle: 'Preferred travel style',
                      child: _ChoiceRow<TripTransportStyle>(
                        value: profile.transportStyle,
                        items: const [
                          (TripTransportStyle.sharedVehicle, 'Shared'),
                          (TripTransportStyle.selfDrive, 'Self-drive'),
                          (TripTransportStyle.airportPickup, 'Pickup'),
                        ],
                        onChanged: onTransportChanged,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: cardWidth,
                    child: _SelectionCard(
                      title: 'Stay',
                      subtitle: 'Accommodation preference',
                      child: _ChoiceRow<TripStayStyle>(
                        value: profile.stayStyle,
                        items: const [
                          (TripStayStyle.recommended, 'Recommended'),
                          (TripStayStyle.ownStay, 'Own stay'),
                          (TripStayStyle.premium, 'Premium'),
                        ],
                        onChanged: onStayChanged,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 14.h),
          Text(
            'Interests',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textHeading,
            ),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: _interestOptions.map((interest) {
              final selected = profile.interests.contains(interest);
              return GestureDetector(
                onTap: () => onInterestToggle(interest),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : AppColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(999.r),
                    border: Border.all(
                      color: selected ? AppColors.primary : AppColors.surfaceBorder,
                    ),
                  ),
                  child: Text(
                    interest,
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          SizedBox(height: 14.h),
          Text(
            'Extra notes',
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textHeading,
            ),
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: notesController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Tell Keza about airport arrival, family needs, food preferences, or anything else important.',
              hintStyle: TextStyle(fontSize: 12.sp, color: AppColors.textDisabled),
              filled: true,
              fillColor: AppColors.surfaceRaised,
              contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(color: AppColors.surfaceBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(color: AppColors.surfaceBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepperCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final VoidCallback? onDecrement;
  final VoidCallback onIncrement;

  const _StepperCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.onDecrement,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, size: 18.w, color: AppColors.primary),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeading,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StepButton(icon: Icons.remove_rounded, enabled: onDecrement != null, onTap: onDecrement ?? () {}),
              SizedBox(width: 8.w),
              _StepButton(icon: Icons.add_rounded, enabled: true, onTap: onIncrement),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _StepButton({required this.icon, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Container(
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
          color: enabled ? AppColors.primarySoft : AppColors.surfaceRaised,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: Icon(icon, size: 16.w, color: enabled ? AppColors.primary : AppColors.textDisabled),
      ),
    );
  }
}

class _BudgetCard extends StatelessWidget {
  final double budget;
  final ValueChanged<double> onChanged;

  const _BudgetCard({required this.budget, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final display = budget.toStringAsFixed(0);
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.payments_outlined, size: 18.w, color: AppColors.primary),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Budget', style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                    SizedBox(height: 2.h),
                    Text('\$$display', style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: AppColors.textHeading)),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.primarySoft,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primarySoft,
            ),
            child: Slider(
              value: budget.clamp(200, 5000).toDouble(),
              min: 200,
              max: 5000,
              divisions: 24,
              label: '\$$display',
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _SelectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _SelectionCard({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
          SizedBox(height: 2.h),
          Text(subtitle, style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
          SizedBox(height: 12.h),
          child,
        ],
      ),
    );
  }
}

class _ChoiceRow<T> extends StatelessWidget {
  final T value;
  final List<(T, String)> items;
  final ValueChanged<T> onChanged;

  const _ChoiceRow({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: items.map((item) {
        final selected = item.$1 == value;
        return GestureDetector(
          onTap: () => onChanged(item.$1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
            decoration: BoxDecoration(
              color: selected ? AppColors.primary : AppColors.surfaceRaised,
              borderRadius: BorderRadius.circular(999.r),
              border: Border.all(
                color: selected ? AppColors.primary : AppColors.surfaceBorder,
              ),
            ),
            child: Text(
              item.$2,
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SelectedPlacesSection extends StatelessWidget {
  final Map<String, List<TripItem>> groupedTrips;

  const _SelectedPlacesSection({required this.groupedTrips});

  @override
  Widget build(BuildContext context) {
    if (groupedTrips.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.surfaceBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'No destinations yet',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textHeading,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Add places from Explore or My Trip, then come back here to build the route.',
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(Icons.place_rounded, size: 16.w, color: AppColors.primary),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected places',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textHeading,
                      ),
                    ),
                    Text(
                      'Grouped by province so the route stays smooth',
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...groupedTrips.entries.map((entry) {
            final places = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.key,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textHeading,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: places
                          .map(
                            (place) => Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(999.r),
                                border: Border.all(color: AppColors.surfaceBorder),
                              ),
                              child: Text(
                                place.name,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _PlanOptionsSection extends StatelessWidget {
  final List<TripPlanOption> plans;
  final TripPlanType selectedPlanType;
  final ValueChanged<TripPlanType> onSelect;

  const _PlanOptionsSection({
    required this.plans,
    required this.selectedPlanType,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Plan types',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textHeading,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Pick the experience that best matches your budget and pace.',
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 14.h),
          if (plans.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.surfaceRaised,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.surfaceBorder),
              ),
              child: Text(
                'Add destinations first and Keza will generate plan types automatically.',
                style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final cardsPerRow = width >= 900
                    ? 3
                    : width >= 600
                        ? 2
                        : 1;
                final cardWidth = cardsPerRow == 1
                    ? width
                    : (width - (12.w * (cardsPerRow - 1))) / cardsPerRow;
                return Wrap(
                  spacing: 12.w,
                  runSpacing: 12.h,
                  children: plans
                      .map(
                        (plan) => SizedBox(
                          width: cardWidth,
                          child: _PlanTypeCard(
                            plan: plan,
                            selected: plan.type == selectedPlanType,
                            onTap: () => onSelect(plan.type),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _PlanTypeCard extends StatelessWidget {
  final TripPlanOption plan;
  final bool selected;
  final VoidCallback onTap;

  const _PlanTypeCard({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryDark : AppColors.surfaceRaised,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: selected ? AppColors.primaryDark : AppColors.surfaceBorder,
            width: selected ? 1.5 : 1,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primaryDark.withOpacity(0.25),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    plan.name,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: selected ? Colors.white : AppColors.textHeading,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: selected ? Colors.white.withOpacity(0.16) : AppColors.primarySoft,
                    borderRadius: BorderRadius.circular(999.r),
                  ),
                  child: Text(
                    plan.withinBudget ? 'Within budget' : 'Over budget',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              plan.description,
              style: TextStyle(
                fontSize: 11.sp,
                height: 1.45,
                color: selected ? Colors.white.withOpacity(0.9) : AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 10.h),
            _PlanMeta(
              icon: Icons.event_note_rounded,
              text: '${plan.days.length} day${plan.days.length == 1 ? '' : 's'}',
              selected: selected,
            ),
            SizedBox(height: 6.h),
            _PlanMeta(
              icon: Icons.directions_car_rounded,
              text: plan.transportNote,
              selected: selected,
            ),
            SizedBox(height: 6.h),
            _PlanMeta(
              icon: Icons.hotel_rounded,
              text: plan.stayNote,
              selected: selected,
            ),
            SizedBox(height: 12.h),
            Text(
              '\$${plan.estimatedCost.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
                color: selected ? Colors.white : AppColors.textHeading,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              plan.fitNote,
              style: TextStyle(
                fontSize: 10.sp,
                height: 1.45,
                color: selected ? Colors.white.withOpacity(0.82) : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanMeta extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool selected;

  const _PlanMeta({
    required this.icon,
    required this.text,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 13.w, color: selected ? Colors.white : AppColors.primary),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 10.sp,
              height: 1.35,
              color: selected ? Colors.white.withOpacity(0.84) : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

class _SelectedPlanPreview extends StatelessWidget {
  final TripPlanOption? selectedPlan;
  final double budget;
  final double total;

  const _SelectedPlanPreview({
    required this.selectedPlan,
    required this.budget,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final plan = selectedPlan;
    final delta = total - budget;

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDarker.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, size: 18.w, color: Colors.amber),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  plan == null ? 'Plan preview' : plan.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            plan == null
                ? 'Choose a plan type to see the day-by-day route and the total.'
                : plan.fitNote,
            style: TextStyle(
              fontSize: 12.sp,
              height: 1.45,
              color: Colors.white.withOpacity(0.88),
            ),
          ),
          SizedBox(height: 14.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: [
              _InfoPill(
                label: 'Budget \$${budget.toStringAsFixed(0)}',
                valueColor: Colors.white,
              ),
              _InfoPill(
                label: 'Estimate \$${total.toStringAsFixed(0)}',
                valueColor: Colors.white,
              ),
              _InfoPill(
                label: delta <= 0
                    ? '\$${delta.abs().toStringAsFixed(0)} under budget'
                    : '\$${delta.toStringAsFixed(0)} over budget',
                valueColor: Colors.white,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final String label;
  final Color valueColor;

  const _InfoPill({required this.label, required this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: Colors.white.withOpacity(0.18)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: valueColor,
        ),
      ),
    );
  }
}

class _DayByDaySection extends StatelessWidget {
  final TripPlanOption? selectedPlan;
  final List<TripPlanOption> plans;

  const _DayByDaySection({
    required this.selectedPlan,
    required this.plans,
  });

  @override
  Widget build(BuildContext context) {
    final plan = selectedPlan ?? (plans.isNotEmpty ? plans.first : null);
    if (plan == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Day-by-day route',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textHeading,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'This is the draft Keza will hand off to checkout.',
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
          ),
          SizedBox(height: 14.h),
          ...plan.days.map(
            (day) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: AppColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: AppColors.surfaceBorder),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: AppColors.primarySoft,
                            borderRadius: BorderRadius.circular(999.r),
                          ),
                          child: Text(
                            'Day ${day.dayNumber}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                day.title,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textHeading,
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                day.summary,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  height: 1.45,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '\$${day.estimatedCost.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textHeading,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      day.stayNote,
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (day.stops.isNotEmpty) ...[
                      SizedBox(height: 10.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: day.stops.map((stop) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999.r),
                              border: Border.all(color: AppColors.surfaceBorder),
                            ),
                            child: Text(
                              stop.name,
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryHintCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SummaryHintCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textHeading,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
