import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../../trips/providers/trips_provider.dart';
import 'pages/edit_profile_page.dart';
import 'pages/change_password_page.dart';
import 'pages/notifications_page.dart';
import 'pages/language_page.dart';
import 'pages/interests_page.dart';
import 'pages/help_faq_page.dart';
import 'pages/privacy_policy_page.dart';
import 'pages/about_page.dart';
import 'pages/budget_range_page.dart';
import 'pages/travel_style_page.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _ProfileHero(top: top),
              const _StatsRow(),
              SizedBox(height: 8.h),
              const _RecentBookingsSection(),
              SizedBox(height: 8.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionLabel(label: 'ACCOUNT'),
                    SizedBox(height: 8.h),
                    _MenuCard(items: [
                      _MenuItem(
                        icon: Icons.person_outline_rounded,
                        label: 'Edit Profile',
                        onTap: () => _push(context, const EditProfilePage()),
                      ),
                      _MenuItem(
                        icon: Icons.lock_outline_rounded,
                        label: 'Change Password',
                        onTap: () => _push(context, const ChangePasswordPage()),
                      ),
                      _MenuItem(
                        icon: Icons.notifications_none_rounded,
                        label: 'Notifications',
                        trailing: _Badge(label: '3'),
                        onTap: () => _push(context, const NotificationsPage()),
                      ),
                      _MenuItem(
                        icon: Icons.language_rounded,
                        label: 'Language',
                        trailingText: 'English',
                        onTap: () => _push(context, const LanguagePage()),
                        isLast: true,
                      ),
                    ]),
                    SizedBox(height: 20.h),
                    const _SectionLabel(label: 'TRAVEL PREFERENCES'),
                    SizedBox(height: 8.h),
                    _MenuCard(items: [
                      _MenuItem(
                        icon: Icons.explore_outlined,
                        label: 'Interests',
                        trailingText: 'Nature, Wildlife',
                        onTap: () => _push(context, const InterestsPage()),
                      ),
                      _MenuItem(
                        icon: Icons.attach_money_rounded,
                        label: 'Budget Range',
                        trailingText: '\$100 – \$500',
                        onTap: () => _push(context, const BudgetRangePage()),
                      ),
                      _MenuItem(
                        icon: Icons.group_outlined,
                        label: 'Travel Style',
                        trailingText: 'Solo',
                        onTap: () => _push(context, const TravelStylePage()),
                        isLast: true,
                      ),
                    ]),
                    SizedBox(height: 20.h),
                    const _SectionLabel(label: 'SUPPORT'),
                    SizedBox(height: 8.h),
                    _MenuCard(items: [
                      _MenuItem(
                        icon: Icons.help_outline_rounded,
                        label: 'Help & FAQ',
                        onTap: () => _push(context, const HelpFaqPage()),
                      ),
                      _MenuItem(
                        icon: Icons.privacy_tip_outlined,
                        label: 'Privacy Policy',
                        onTap: () => _push(context, const PrivacyPolicyPage()),
                      ),
                      _MenuItem(
                        icon: Icons.info_outline_rounded,
                        label: 'About Keza',
                        onTap: () => _push(context, const AboutPage()),
                        isLast: true,
                      ),
                    ]),
                    SizedBox(height: 24.h),
                    GestureDetector(
                      onTap: () async {
                        await context.read<AuthProvider>().logout();
                        if (context.mounted) context.go('/login');
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 15.h),
                        decoration: BoxDecoration(
                          color: AppColors.errorSoft,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.logout_rounded,
                                color: AppColors.error, size: 18.w),
                            SizedBox(width: 8.w),
                            Text(
                              'Sign Out',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Center(
                      child: Text(
                        'Keza v1.0.0',
                        style: TextStyle(
                            fontSize: 11.sp, color: AppColors.textDisabled),
                      ),
                    ),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Hero header (centered) ────────────────────────────────────────────────────
class _ProfileHero extends StatelessWidget {
  final double top;
  const _ProfileHero({required this.top});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.aiGradient),
      child: Stack(
        children: [
          Positioned(
            right: -40.w,
            top: -40.w,
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            left: -30.w,
            bottom: -50.w,
            child: Container(
              width: 160.w,
              height: 160.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Center(
           child: Padding(
            padding: EdgeInsets.only(
                top: top + 24.h, left: 24.w, right: 24.w, bottom: 32.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar with edit button
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: 92.w,
                      height: 92.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/general/profile.png',
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: AppColors.primaryDark,
                            child: Icon(Icons.person_rounded,
                                color: Colors.white, size: 46.w),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: 28.w,
                          height: 28.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Icon(Icons.edit_rounded,
                              size: 14.w, color: AppColors.primaryDark),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Text(
                  'Afanyu Emmanuel',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'afanyu@example.com',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white.withOpacity(0.75),
                  ),
                ),
                SizedBox(height: 14.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                        color: Colors.white.withOpacity(0.3), width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified_rounded,
                          color: Colors.amber, size: 14.w),
                      SizedBox(width: 6.w),
                      Text(
                        'Keza Explorer · Member since 2024',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
           ),
          ),
        ],
      ),
    );
  }
}

// ── Stats row ─────────────────────────────────────────────────────────────────
class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return Consumer<TripsProvider>(
      builder: (context, provider, _) {
        return Transform.translate(
          offset: const Offset(0, -20),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                _StatCell(
                    value: '${provider.addedTrips.length}', label: 'Trips'),
                _StatDivider(),
                _StatCell(
                    value: '${provider.favourites.length}', label: 'Saved'),
                _StatDivider(),
                _StatCell(
                    value: '${provider.bookedTrips.length}', label: 'Booked'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCell extends StatelessWidget {
  final String value;
  final String label;
  const _StatCell({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeading)),
            SizedBox(height: 2.h),
            Text(label,
                style: TextStyle(
                    fontSize: 11.sp, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 36.h, color: AppColors.surfaceBorder);
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 0.8));
  }
}

// ── Menu card ─────────────────────────────────────────────────────────────────
class _MenuCard extends StatelessWidget {
  final List<_MenuItem> items;
  const _MenuCard({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(children: items),
    );
  }
}

// ── Menu item ─────────────────────────────────────────────────────────────────
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final String? trailingText;
  final VoidCallback onTap;
  final bool isLast;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.trailing,
    this.trailingText,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
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
                  child: Text(label,
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary)),
                ),
                if (trailingText != null)
                  Text(trailingText!,
                      style: TextStyle(
                          fontSize: 12.sp, color: AppColors.textSecondary)),
                if (trailing != null) trailing!,
                SizedBox(width: 6.w),
                Icon(Icons.chevron_right_rounded,
                    size: 18.w, color: AppColors.textDisabled),
              ],
            ),
          ),
          if (!isLast)
            Divider(height: 1, indent: 66.w, color: AppColors.surfaceBorder),
        ],
      ),
    );
  }
}

// ── Badge ─────────────────────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final String label;
  const _Badge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
      decoration: BoxDecoration(
          color: AppColors.error, borderRadius: BorderRadius.circular(10.r)),
      child: Text(label,
          style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold)),
    );
  }
}

// ── Recent bookings section ───────────────────────────────────────────────────
class _RecentBookingsSection extends StatelessWidget {
  const _RecentBookingsSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<TripsProvider>(
      builder: (context, provider, _) {
        final bookings = provider.bookedTrips;
        if (bookings.isEmpty) return const SizedBox.shrink();
        final recent = bookings.take(3).toList();
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const _SectionLabel(label: 'RECENT BOOKINGS'),
                  if (bookings.length > 3)
                    GestureDetector(
                      onTap: () => context.go('/'),
                      child: Text(
                        'See all',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
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
                  children: List.generate(recent.length, (i) {
                    final b = recent[i];
                    final isLast = i == recent.length - 1;
                    final (statusLabel, statusColor) = switch (b.status) {
                      BookingStatus.confirmed => ('Confirmed', AppColors.success),
                      BookingStatus.pending => ('Pending', AppColors.warning),
                      BookingStatus.completed => ('Completed', AppColors.textSecondary),
                    };
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10.r),
                                child: Image.network(
                                  b.image,
                                  width: 48.w,
                                  height: 48.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 48.w,
                                    height: 48.w,
                                    color: AppColors.shimmerBase,
                                    child: Icon(Icons.hotel_rounded, size: 20.w, color: AppColors.textDisabled),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      b.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textHeading,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      b.travelDate,
                                      style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    b.price,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                                    decoration: BoxDecoration(
                                      color: statusColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Text(
                                      statusLabel,
                                      style: TextStyle(
                                        fontSize: 9.sp,
                                        fontWeight: FontWeight.w700,
                                        color: statusColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        if (!isLast)
                          Divider(height: 1, indent: 74.w, color: AppColors.surfaceBorder),
                      ],
                    );
                  }),
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        );
      },
    );
  }
}
