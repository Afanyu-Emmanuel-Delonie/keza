import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import 'profile_page_scaffold.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  static const _sections = [
    _Section(
      title: '1. Information We Collect',
      body:
          'We collect information you provide directly, such as your name, email address, phone number, and payment details when you register or make a booking. We also collect usage data including destinations browsed, trips planned, and preferences set within the app.',
    ),
    _Section(
      title: '2. How We Use Your Information',
      body:
          'Your information is used to process bookings, personalise your travel recommendations, improve our AI trip planner, send booking confirmations and reminders, and provide customer support. We do not sell your personal data to third parties.',
    ),
    _Section(
      title: '3. Data Sharing',
      body:
          'We share your data only with service providers necessary to fulfil your bookings (hotels, tour operators, payment processors). All partners are bound by strict data protection agreements.',
    ),
    _Section(
      title: '4. Data Security',
      body:
          'We use industry-standard encryption (TLS/SSL) for all data in transit and at rest. Payment information is processed through PCI-DSS compliant gateways. We never store full card numbers on our servers.',
    ),
    _Section(
      title: '5. Your Rights',
      body:
          'You have the right to access, correct, or delete your personal data at any time. You may also request a copy of your data or withdraw consent for marketing communications by contacting us at privacy@kezatour.rw.',
    ),
    _Section(
      title: '6. Cookies & Tracking',
      body:
          'The Keza app uses analytics tools to understand usage patterns and improve the experience. No third-party advertising trackers are used. You can opt out of analytics in your device settings.',
    ),
    _Section(
      title: '7. Changes to This Policy',
      body:
          'We may update this Privacy Policy from time to time. We will notify you of significant changes via the app or email. Continued use of Keza after changes constitutes acceptance of the updated policy.',
    ),
    _Section(
      title: '8. Contact Us',
      body:
          'For any privacy-related questions or requests, contact our Data Protection Officer at privacy@kezatour.rw or write to: Keza Tour Ltd, Kigali, Rwanda.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Privacy Policy',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Last updated banner ──
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, size: 15.w, color: AppColors.primary),
                SizedBox(width: 8.w),
                Text(
                  'Last updated: January 2025',
                  style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          Text(
            'Your privacy matters to us. This policy explains how Keza Tour collects, uses, and protects your personal information.',
            style: TextStyle(
                fontSize: 13.sp, color: AppColors.textSecondary, height: 1.6),
          ),
          SizedBox(height: 20.h),

          ..._sections.map((s) => _PolicySection(section: s)),
        ],
      ),
    );
  }
}

class _Section {
  final String title;
  final String body;
  const _Section({required this.title, required this.body});
}

class _PolicySection extends StatelessWidget {
  final _Section section;
  const _PolicySection({required this.section});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            section.title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textHeading,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            section.body,
            style: TextStyle(
                fontSize: 13.sp, color: AppColors.textSecondary, height: 1.65),
          ),
        ],
      ),
    );
  }
}
