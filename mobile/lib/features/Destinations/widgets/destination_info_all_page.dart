import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../domain/models/destination_details_model.dart';

class DestinationInfoAllPage extends StatefulWidget {
  final DestinationDetailData data;
  final int initialTab;

  const DestinationInfoAllPage({
    super.key,
    required this.data,
    this.initialTab = 0,
  });

  @override
  State<DestinationInfoAllPage> createState() => _DestinationInfoAllPageState();
}

class _DestinationInfoAllPageState extends State<DestinationInfoAllPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _tabs = [
    'What to Expect',
    "What's Included",
    'Departure & Return',
    'Accessibility',
    'Guide Languages',
    'Additional Info',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                size: 18.w, color: AppColors.textHeading),
          ),
        ),
        title: Text(
          'More Info',
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textHeading,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(44.h),
          child: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            labelStyle: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
            unselectedLabelStyle:
                TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w400),
            indicatorColor: AppColors.primary,
            indicatorWeight: 2.5,
            dividerColor: AppColors.surfaceBorder,
            tabs: _tabs.map((t) => Tab(text: t)).toList(),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _BulletList(items: d.whatToExpect, icon: Icons.check_circle_outline_rounded, color: AppColors.primary),
          _BulletList(items: d.whatIsIncluded, icon: Icons.check_rounded, color: Colors.green.shade400),
          _DepartureReturnTab(text: d.activityInfo.departureAndReturn),
          _BulletList(items: d.accessibility, icon: Icons.accessibility_new_rounded, color: Colors.blue.shade400),
          _LanguagesList(languages: d.activityInfo.languages),
          _BulletList(items: d.additionalInfo, icon: Icons.info_outline_rounded, color: Colors.orange.shade400),
        ],
      ),
    );
  }
}

// ── Bullet list tab ───────────────────────────────────────────────────────────
class _BulletList extends StatelessWidget {
  final List<String> items;
  final IconData icon;
  final Color color;

  const _BulletList({required this.items, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      itemCount: items.length,
      separatorBuilder: (_, __) => SizedBox(height: 14.h),
      itemBuilder: (_, i) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18.w, color: color),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              items[i],
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Departure & Return tab ────────────────────────────────────────────────────
class _DepartureReturnTab extends StatelessWidget {
  final String text;
  const _DepartureReturnTab({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoCard(
            icon: Icons.flight_takeoff_rounded,
            label: 'Departure',
            color: AppColors.primary,
            child: Text(
              text.contains('Departs')
                  ? text.split('.').first.trim()
                  : text,
              style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                  height: 1.55),
            ),
          ),
          SizedBox(height: 14.h),
          _InfoCard(
            icon: Icons.flight_land_rounded,
            label: 'Return',
            color: Colors.green.shade400,
            child: Text(
              text.contains('Returns')
                  ? text.split('.').last.trim()
                  : text,
              style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                  height: 1.55),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Widget child;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.surfaceBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18.w, color: color),
              SizedBox(width: 8.w),
              Text(label,
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHeading)),
            ],
          ),
          SizedBox(height: 10.h),
          child,
        ],
      ),
    );
  }
}

// ── Languages tab ─────────────────────────────────────────────────────────────
class _LanguagesList extends StatelessWidget {
  final List<String> languages;
  const _LanguagesList({required this.languages});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your guide speaks the following languages:',
            style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                height: 1.5),
          ),
          SizedBox(height: 20.h),
          Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: languages
                .map((lang) => Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(30.r),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.language_rounded,
                              size: 15.w, color: AppColors.primary),
                          SizedBox(width: 6.w),
                          Text(lang,
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary)),
                        ],
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
