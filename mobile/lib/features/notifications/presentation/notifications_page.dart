import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/animated_card_item.dart';
import '../../../shared/widgets/keza_app_bar.dart';

// ========== Notification Model ================================
class _NotifItem {
  final String title;
  final String body;
  final String time;
  final _NotifType type;
  bool isRead;

  _NotifItem({
    required this.title,
    required this.body,
    required this.time,
    required this.type,
    this.isRead = false,
  });
}

enum _NotifType { trip, promo, system, ai }

// ========== Notifications Page ================================
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<_NotifItem> _today = [
    _NotifItem(
      title: 'Trip Confirmed!',
      body: 'Your Kigali City Tour on Oct 12 is confirmed. Tap to view details.',
      time: '2m ago',
      type: _NotifType.trip,
    ),
    _NotifItem(
      title: 'Keza AI has a suggestion',
      body: 'Based on your interests, we found 3 new spots near Lake Kivu.',
      time: '1h ago',
      type: _NotifType.ai,
    ),
    _NotifItem(
      title: '20% off Gorilla Trekking',
      body: 'Limited offer — book before Oct 30 and save big on Volcanoes NP.',
      time: '3h ago',
      type: _NotifType.promo,
    ),
  ];

  final List<_NotifItem> _earlier = [
    _NotifItem(
      title: 'Welcome to Keza!',
      body: 'Discover Rwanda\'s best destinations, stays, and experiences.',
      time: 'Yesterday',
      type: _NotifType.system,
      isRead: true,
    ),
    _NotifItem(
      title: 'New places in Eastern Province',
      body: 'Akagera National Park just added 4 new guided tour packages.',
      time: '2 days ago',
      type: _NotifType.trip,
      isRead: true,
    ),
    _NotifItem(
      title: 'Your itinerary is ready',
      body: 'Keza AI finished building your 3-day Musanze adventure plan.',
      time: '3 days ago',
      type: _NotifType.ai,
      isRead: true,
    ),
  ];

  void _markAllRead() {
    setState(() {
      for (final n in [..._today, ..._earlier]) {
        n.isRead = true;
      }
    });
  }

  int get _unreadCount =>
      [..._today, ..._earlier].where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KezaAppBar(
        title: 'Notifications',
        subtitle: _unreadCount > 0 ? '$_unreadCount unread' : 'All caught up',
        showBack: true,
        showNotification: false,
        actions: [
          if (_unreadCount > 0)
            AppBarAction(
              icon: Icons.done_all_rounded,
              onTap: _markAllRead,
              iconColor: AppColors.primary,
            ),
        ],
      ),
      body: _today.isEmpty && _earlier.isEmpty
          ? const _EmptyState()
          : ListView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              children: [
                // ========== Today ================================
                if (_today.isNotEmpty) ...[
                  _GroupLabel(label: 'Today', index: 0),
                  SizedBox(height: 8.h),
                  ..._today.asMap().entries.map(
                        (e) => AnimatedCardItem(
                          index: e.key + 1,
                          child: _NotifCard(
                            item: e.value,
                            onTap: () => setState(() => e.value.isRead = true),
                          ),
                        ),
                      ),
                  SizedBox(height: 20.h),
                ],

                // ========== Earlier ================================
                if (_earlier.isNotEmpty) ...[
                  _GroupLabel(label: 'Earlier', index: _today.length + 1),
                  SizedBox(height: 8.h),
                  ..._earlier.asMap().entries.map(
                        (e) => AnimatedCardItem(
                          index: e.key + _today.length + 2,
                          child: _NotifCard(
                            item: e.value,
                            onTap: () => setState(() => e.value.isRead = true),
                          ),
                        ),
                      ),
                ],

                SizedBox(height: 24.h),
              ],
            ),
    );
  }
}

// ========== Group Label ================================
class _GroupLabel extends StatelessWidget {
  final String label;
  final int index;

  const _GroupLabel({required this.label, required this.index});

  @override
  Widget build(BuildContext context) {
    return AnimatedCardItem(
      index: index,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

// ========== Notification Card ================================
class _NotifCard extends StatelessWidget {
  final _NotifItem item;
  final VoidCallback onTap;

  const _NotifCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuart,
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: item.isRead ? AppColors.surface : AppColors.primarySoft,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: item.isRead
                ? AppColors.surfaceBorder
                : AppColors.primary.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ========== Icon Badge ================================
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: _iconBg(item.type),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                _iconData(item.type),
                size: 18.w,
                color: _iconColor(item.type),
              ),
            ),
            SizedBox(width: 12.w),

            // ========== Content ================================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: item.isRead
                                ? FontWeight.w500
                                : FontWeight.w700,
                            color: AppColors.textHeading,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        item.time,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    item.body,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),

            // ========== Unread Dot ================================
            if (!item.isRead)
              Padding(
                padding: EdgeInsets.only(left: 8.w, top: 4.h),
                child: Container(
                  width: 7.w,
                  height: 7.w,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _iconData(_NotifType type) => switch (type) {
        _NotifType.trip   => Icons.card_travel_rounded,
        _NotifType.promo  => Icons.local_offer_rounded,
        _NotifType.ai     => Icons.auto_awesome_rounded,
        _NotifType.system => Icons.info_outline_rounded,
      };

  Color _iconBg(_NotifType type) => switch (type) {
        _NotifType.trip   => AppColors.primarySoft,
        _NotifType.promo  => AppColors.warningSoft,
        _NotifType.ai     => AppColors.infoSoft,
        _NotifType.system => AppColors.surfaceRaised,
      };

  Color _iconColor(_NotifType type) => switch (type) {
        _NotifType.trip   => AppColors.primary,
        _NotifType.promo  => AppColors.warning,
        _NotifType.ai     => AppColors.info,
        _NotifType.system => AppColors.textSecondary,
      };
}

// ========== Empty State ================================
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              size: 40.w,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'No notifications yet',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textHeading,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'We\'ll let you know when something\nimportant comes up.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
