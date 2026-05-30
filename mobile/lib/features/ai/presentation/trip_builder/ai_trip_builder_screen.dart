import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/trip_snackbar.dart';
import '../../../navigation/presentation/navigation_page.dart';
import 'trip_builder_model.dart';
import 'trip_builder_prefs_step.dart';
import 'trip_builder_places_step.dart';
import 'trip_builder_itinerary_step.dart';
import 'trip_builder_checkout_step.dart';

enum _Step { prefs, loadingPlaces, places, loadingPlan, itinerary, checkout }

class AiTripBuilderScreen extends StatefulWidget {
  const AiTripBuilderScreen({super.key});

  @override
  State<AiTripBuilderScreen> createState() => _AiTripBuilderScreenState();
}

class _AiTripBuilderScreenState extends State<AiTripBuilderScreen> {
  _Step _step = _Step.prefs;
  TripPrefs? _prefs;
  List<ProposedPlace> _proposedPlaces = [];
  TripPlan? _plan;

  // ── Step 1 → 2: fetch proposed places ────────────────────────────────────
  void _onPrefsSubmit(TripPrefs prefs) {
    setState(() {
      _prefs = prefs;
      _step = _Step.loadingPlaces;
    });
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() {
        _proposedPlaces = getProposedPlaces(prefs.interests);
        _step = _Step.places;
      });
    });
  }

  // ── Step 2 → 3: generate plan from selected places ────────────────────────
  void _onPlacesSelected(List<ProposedPlace> selected) {
    setState(() => _step = _Step.loadingPlan);
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      setState(() {
        _plan = generatePlan(_prefs!, selected);
        _step = _Step.itinerary;
      });
    });
  }

  // ── Step 3 → 4: go to checkout ────────────────────────────────────────────
  void _onCheckout(TripPlan plan) {
    setState(() {
      _plan = plan;
      _step = _Step.checkout;
    });
  }

  // ── Step 4: confirm booking ───────────────────────────────────────────────
  void _onConfirm() {
    Navigator.of(context).popUntil((route) => route.isFirst);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NavigationPage.jumpToTab(context, 2);
      showTopSnackbar(
        context,
        'Trip saved! We\'ll notify you when booking is confirmed.',
        icon: Icons.check_circle_rounded,
      );
    });
  }

  // ── Back navigation ───────────────────────────────────────────────────────
  void _onBack() {
    switch (_step) {
      case _Step.places:
        setState(() => _step = _Step.prefs);
      case _Step.itinerary:
        setState(() => _step = _Step.places);
      case _Step.checkout:
        setState(() => _step = _Step.itinerary);
      default:
        Navigator.maybePop(context);
    }
  }

  // ── Rebuild from scratch ──────────────────────────────────────────────────
  void _rebuild() => setState(() {
        _step = _Step.prefs;
        _prefs = null;
        _proposedPlaces = [];
        _plan = null;
      });

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
              _AppBar(
                step: _step,
                onBack: _onBack,
                onRebuild: _step.index >= _Step.places.index &&
                        _step != _Step.loadingPlaces &&
                        _step != _Step.loadingPlan
                    ? _rebuild
                    : null,
              ),
              if (_step != _Step.loadingPlaces && _step != _Step.loadingPlan)
                _StepDots(step: _step),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 320),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  child: _buildBody(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_step) {
      case _Step.prefs:
        return TripBuilderPrefsStep(
          key: const ValueKey('prefs'),
          onNext: _onPrefsSubmit,
        );
      case _Step.loadingPlaces:
        return const _LoadingView(
          key: ValueKey('loadingPlaces'),
          message: 'Finding matching places...',
          sub: 'AI is scanning destinations based on your interests',
        );
      case _Step.places:
        return TripBuilderPlacesStep(
          key: const ValueKey('places'),
          prefs: _prefs!,
          places: _proposedPlaces,
          onNext: _onPlacesSelected,
        );
      case _Step.loadingPlan:
        return _LoadingView(
          key: const ValueKey('loadingPlan'),
          message: 'Building your itinerary...',
          sub: 'AI is booking accommodation & crafting your day-by-day plan',
        );
      case _Step.itinerary:
        return TripBuilderItineraryStep(
          key: const ValueKey('itinerary'),
          plan: _plan!,
          onCheckout: _onCheckout,
        );
      case _Step.checkout:
        return TripBuilderCheckoutStep(
          key: const ValueKey('checkout'),
          plan: _plan!,
          onConfirm: _onConfirm,
        );
    }
  }
}

// ── App bar ───────────────────────────────────────────────────────────────────
class _AppBar extends StatelessWidget {
  final _Step step;
  final VoidCallback onBack;
  final VoidCallback? onRebuild;

  const _AppBar(
      {required this.step, required this.onBack, this.onRebuild});

  String get _title => switch (step) {
        _Step.prefs => 'AI Trip Builder',
        _Step.loadingPlaces => 'Finding Places',
        _Step.places => 'Choose Places',
        _Step.loadingPlan => 'Building Plan',
        _Step.itinerary => 'Your Itinerary',
        _Step.checkout => 'Checkout',
      };

  String get _subtitle => switch (step) {
        _Step.prefs => 'Tell us your dates, budget & interests',
        _Step.loadingPlaces => 'Scanning destinations for you...',
        _Step.places => 'Select the places you want to visit',
        _Step.loadingPlan => 'AI is crafting your plan...',
        _Step.itinerary => 'Customise & review your trip',
        _Step.checkout => 'Review costs & confirm booking',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      padding: EdgeInsets.fromLTRB(8.w, 8.h, 16.w, 8.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Container(
              width: 40.w,
              height: 40.w,
              margin: EdgeInsets.only(left: 8.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  size: 16.w, color: AppColors.textHeading),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_title,
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textHeading)),
                Text(_subtitle,
                    style: TextStyle(
                        fontSize: 11.sp, color: AppColors.textSecondary)),
              ],
            ),
          ),
          if (onRebuild != null)
            GestureDetector(
              onTap: onRebuild,
              child: Container(
                padding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
                decoration: BoxDecoration(
                  color: AppColors.primarySoft,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.refresh_rounded,
                        size: 14.w, color: AppColors.primary),
                    SizedBox(width: 4.w),
                    Text('Rebuild',
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Step progress dots ────────────────────────────────────────────────────────
class _StepDots extends StatelessWidget {
  final _Step step;
  const _StepDots({required this.step});

  static const _visible = [
    _Step.prefs,
    _Step.places,
    _Step.itinerary,
    _Step.checkout,
  ];

  @override
  Widget build(BuildContext context) {
    final current = _visible.indexOf(step).clamp(0, _visible.length - 1);
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_visible.length, (i) {
          final active = i == current;
          final done = i < current;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            width: active ? 22.w : 7.w,
            height: 7.w,
            decoration: BoxDecoration(
              color: done || active
                  ? AppColors.primary
                  : AppColors.surfaceBorder,
              borderRadius: BorderRadius.circular(4.r),
            ),
          );
        }),
      ),
    );
  }
}

// ── Loading view ──────────────────────────────────────────────────────────────
class _LoadingView extends StatelessWidget {
  final String message;
  final String sub;
  const _LoadingView({super.key, required this.message, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 52.w,
            height: 52.w,
            child: CircularProgressIndicator(
                strokeWidth: 3, color: AppColors.primary),
          ),
          SizedBox(height: 24.h),
          Text(message,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textHeading)),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Text(sub,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                    height: 1.5)),
          ),
        ],
      ),
    );
  }
}
