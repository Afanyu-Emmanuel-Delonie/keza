import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/trips_provider.dart';

/// Shows once when the user adds their first item to a trip.
/// Creates a named trip group and gives them a clear next step.
class TripGroupSheet extends StatefulWidget {
  final String firstItemName;
  final String firstItemImage;

  const TripGroupSheet({
    super.key,
    required this.firstItemName,
    required this.firstItemImage,
  });

  static Future<void> show(
    BuildContext context, {
    required String firstItemName,
    required String firstItemImage,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TripGroupSheet(
        firstItemName: firstItemName,
        firstItemImage: firstItemImage,
      ),
    );
  }

  @override
  State<TripGroupSheet> createState() => _TripGroupSheetState();
}

class _TripGroupSheetState extends State<TripGroupSheet> {
  final _nameCtrl = TextEditingController(text: 'My Rwanda Trip');
  bool _created = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _create() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    HapticFeedback.mediumImpact();
    context.read<TripsProvider>().createGroup(name);
    setState(() => _created = true);
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceRaised,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, bottomPad + 24.h),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 350),
          child: _created ? _SuccessView(key: const ValueKey('success')) : _FormView(
            key: const ValueKey('form'),
            nameCtrl: _nameCtrl,
            firstItemName: widget.firstItemName,
            onCreate: _create,
          ),
        ),
      ),
    );
  }
}

class _FormView extends StatelessWidget {
  final TextEditingController nameCtrl;
  final String firstItemName;
  final VoidCallback onCreate;

  const _FormView({
    super.key,
    required this.nameCtrl,
    required this.firstItemName,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Handle
        Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.surfaceBorder,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
        ),

        // Header
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                gradient: AppColors.aiGradient,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(Icons.luggage_rounded, color: Colors.white, size: 22.w),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trip started! 🎉',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textHeading,
                    ),
                  ),
                  Text(
                    '"$firstItemName" added to your trip',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),

        // What happens next
        Container(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'How it works',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDarker,
                ),
              ),
              SizedBox(height: 8.h),
              _Step(number: '1', text: 'Add destinations, stays & activities'),
              SizedBox(height: 6.h),
              _Step(number: '2', text: 'AI plans your itinerary & books stays'),
              SizedBox(height: 6.h),
              _Step(number: '3', text: 'Choose airport pickup & tour guide'),
              SizedBox(height: 6.h),
              _Step(number: '4', text: 'Pay now or pay on arrival — your choice'),
            ],
          ),
        ),
        SizedBox(height: 20.h),

        // Trip name input
        Text(
          'Name your trip',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textHeading,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          controller: nameCtrl,
          autofocus: false,
          style: TextStyle(fontSize: 14.sp, color: AppColors.textHeading, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            hintText: 'e.g. Rwanda Adventure 2025',
            hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textDisabled),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.surfaceBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.surfaceBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
        SizedBox(height: 20.h),

        // CTA
        SizedBox(
          width: double.infinity,
          child: GestureDetector(
            onTap: onCreate,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF007D3D), Color(0xFF00A651)],
                ),
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.30),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text(
                'Create Trip Group',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              gradient: AppColors.aiGradient,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.check_rounded, color: Colors.white, size: 32.w),
          ),
          SizedBox(height: 16.h),
          Text(
            'Trip group created!',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textHeading,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Keep adding places — then let AI plan everything.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String number;
  final String text;
  const _Step({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            number,
            style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.w800),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 12.sp, color: AppColors.primaryDarker, height: 1.4),
          ),
        ),
      ],
    );
  }
}
