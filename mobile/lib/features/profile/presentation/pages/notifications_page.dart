import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import 'profile_page_scaffold.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool _tripUpdates = true;
  bool _bookingAlerts = true;
  bool _aiSuggestions = false;
  bool _promotions = false;
  bool _appUpdates = true;

  final _recent = [
    _Notif(
      icon: Icons.hotel_rounded,
      color: AppColors.primary,
      title: 'Booking Confirmed',
      body: 'Your stay at Kigali Serena Hotel has been confirmed.',
      time: '2h ago',
      unread: true,
    ),
    _Notif(
      icon: Icons.auto_awesome_rounded,
      color: Color(0xFF7C3AED),
      title: 'AI Recommendation',
      body: 'Keza AI found 3 new destinations matching your interests.',
      time: '5h ago',
      unread: true,
    ),
    _Notif(
      icon: Icons.local_offer_rounded,
      color: AppColors.warning,
      title: 'Special Offer',
      body: '20% off on Lake Kivu Serena this weekend only.',
      time: '1d ago',
      unread: false,
    ),
    _Notif(
      icon: Icons.confirmation_num_rounded,
      color: AppColors.success,
      title: 'Trip Reminder',
      body: 'Your Volcanoes Gorilla Trek is in 3 days. Get ready!',
      time: '2d ago',
      unread: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Notifications',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Recent notifications ──
          _Label('RECENT'),
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
              children: _recent.asMap().entries.map((e) {
                final i = e.key;
                final n = e.value;
                return Column(
                  children: [
                    _NotifTile(notif: n),
                    if (i < _recent.length - 1)
                      Divider(height: 1, indent: 62.w, color: AppColors.surfaceBorder),
                  ],
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 28.h),

          // ── Preferences ──
          _Label('PREFERENCES'),
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
              children: [
                _ToggleTile(
                  icon: Icons.card_travel_rounded,
                  label: 'Trip Updates',
                  sub: 'Changes to your planned trips',
                  value: _tripUpdates,
                  onChanged: (v) => setState(() => _tripUpdates = v),
                ),
                _divider(),
                _ToggleTile(
                  icon: Icons.hotel_rounded,
                  label: 'Booking Alerts',
                  sub: 'Confirmations and reminders',
                  value: _bookingAlerts,
                  onChanged: (v) => setState(() => _bookingAlerts = v),
                ),
                _divider(),
                _ToggleTile(
                  icon: Icons.auto_awesome_rounded,
                  label: 'AI Suggestions',
                  sub: 'Personalised travel ideas from Keza AI',
                  value: _aiSuggestions,
                  onChanged: (v) => setState(() => _aiSuggestions = v),
                ),
                _divider(),
                _ToggleTile(
                  icon: Icons.local_offer_rounded,
                  label: 'Promotions & Deals',
                  sub: 'Discounts and special offers',
                  value: _promotions,
                  onChanged: (v) => setState(() => _promotions = v),
                ),
                _divider(),
                _ToggleTile(
                  icon: Icons.system_update_rounded,
                  label: 'App Updates',
                  sub: 'New features and improvements',
                  value: _appUpdates,
                  onChanged: (v) => setState(() => _appUpdates = v),
                  isLast: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      Divider(height: 1, indent: 62.w, color: AppColors.surfaceBorder);
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
          letterSpacing: 0.8,
        ),
      );
}

class _Notif {
  final IconData icon;
  final Color color;
  final String title;
  final String body;
  final String time;
  final bool unread;
  const _Notif({
    required this.icon,
    required this.color,
    required this.title,
    required this.body,
    required this.time,
    required this.unread,
  });
}

class _NotifTile extends StatelessWidget {
  final _Notif notif;
  const _NotifTile({required this.notif});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: notif.color.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(notif.icon, size: 18.w, color: notif.color),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notif.title,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textHeading,
                        ),
                      ),
                    ),
                    if (notif.unread)
                      Container(
                        width: 7.w,
                        height: 7.w,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  notif.body,
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary, height: 1.4),
                ),
                SizedBox(height: 4.h),
                Text(
                  notif.time,
                  style: TextStyle(fontSize: 10.sp, color: AppColors.textDisabled),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  const _ToggleTile({
    required this.icon,
    required this.label,
    required this.sub,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 18.w, color: AppColors.primary),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary)),
                Text(sub,
                    style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}
