import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import 'profile_page_scaffold.dart';

class HelpFaqPage extends StatelessWidget {
  const HelpFaqPage({super.key});

  static const _faqs = [
    _Faq(
      q: 'How do I book a trip on Keza?',
      a: 'Go to the Explore tab, pick a destination, tap "Add to Trip", then head to My Trip and tap "Plan My Trip" to select accommodation and confirm your booking.',
    ),
    _Faq(
      q: 'Can I cancel or modify a booking?',
      a: 'Yes. Go to the Trips tab → Booked, find your booking and tap "View Details". Cancellations are free up to 48 hours before your travel date.',
    ),
    _Faq(
      q: 'What payment methods are accepted?',
      a: 'Keza accepts Credit/Debit cards (Visa, Mastercard, Amex), Mobile Money (MTN MoMo, Airtel Money), and direct Bank Transfer.',
    ),
    _Faq(
      q: 'How does the AI trip planner work?',
      a: 'Keza AI analyses your selected destinations, interests, and budget to suggest the best accommodations, tour guides, and itineraries tailored to you.',
    ),
    _Faq(
      q: 'How do I book a tour guide?',
      a: 'On the Plan My Trip page, after selecting accommodation, you\'ll see available guides per province. Tap a guide to view their profile and confirm a booking.',
    ),
    _Faq(
      q: 'Is my payment information secure?',
      a: 'Yes. All payments are processed through encrypted, PCI-compliant gateways. Keza never stores your full card details.',
    ),
    _Faq(
      q: 'How do I contact support?',
      a: 'Use the "Contact Support" button below or email us at support@kezatour.rw. We respond within 24 hours.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Help & FAQ',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Search hint ──
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.surfaceBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.search_rounded, size: 18.w, color: AppColors.textSecondary),
                SizedBox(width: 10.w),
                Text('Search help articles...',
                    style: TextStyle(fontSize: 13.sp, color: AppColors.textDisabled)),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          Text('FREQUENTLY ASKED QUESTIONS',
              style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8)),
          SizedBox(height: 10.h),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: _faqs.asMap().entries.map((e) {
                final isLast = e.key == _faqs.length - 1;
                return _FaqTile(faq: e.value, isLast: isLast);
              }).toList(),
            ),
          ),
          SizedBox(height: 28.h),

          // ── Contact support ──
          Text('STILL NEED HELP?',
              style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8)),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _ContactCard(
                  icon: Icons.email_outlined,
                  label: 'Email Us',
                  sub: 'support@kezatour.rw',
                  onTap: () {},
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _ContactCard(
                  icon: Icons.chat_bubble_outline_rounded,
                  label: 'Live Chat',
                  sub: 'Available 8am – 8pm',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Faq {
  final String q;
  final String a;
  const _Faq({required this.q, required this.a});
}

class _FaqTile extends StatefulWidget {
  final _Faq faq;
  final bool isLast;
  const _FaqTile({required this.faq, required this.isLast});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => setState(() => _open = !_open),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.faq.q,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: _open ? AppColors.primaryDark : AppColors.textHeading,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                AnimatedRotation(
                  turns: _open ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(Icons.keyboard_arrow_down_rounded,
                      size: 20.w, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          crossFadeState: _open ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstChild: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
            child: Text(
              widget.faq.a,
              style: TextStyle(
                  fontSize: 13.sp, color: AppColors.textSecondary, height: 1.55),
            ),
          ),
          secondChild: const SizedBox.shrink(),
        ),
        if (!widget.isLast)
          Divider(height: 1, indent: 16.w, endIndent: 16.w, color: AppColors.surfaceBorder),
      ],
    );
  }
}

class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final VoidCallback onTap;

  const _ContactCard({
    required this.icon,
    required this.label,
    required this.sub,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.surfaceBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(icon, size: 18.w, color: AppColors.primary),
            ),
            SizedBox(height: 10.h),
            Text(label,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeading)),
            SizedBox(height: 2.h),
            Text(sub,
                style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
