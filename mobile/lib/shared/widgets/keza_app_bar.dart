import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/animated_card_item.dart';
import '../../features/notifications/presentation/notifications_page.dart';

// ========== Keza App Bar ================================
class KezaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBack;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final bool centerTitle;
  final bool showNotification;
  final bool hasUnreadNotifications;

  const KezaAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = true,
    this.actions,
    this.backgroundColor,
    this.centerTitle = false,
    this.showNotification = true,
    this.hasUnreadNotifications = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(subtitle != null ? 68.h : 56.h);

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppColors.background;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Container(
        color: bg,
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top,
          left: showBack ? 4.w : 20.w,
          right: 8.w,
        ),
        child: SizedBox(
          height: subtitle != null ? 68.h : 56.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ========== Back Button ================================
              if (showBack)
                _BackButton(backgroundColor: bg),

              // ========== Title Block ================================
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: showBack ? 4.w : 0,
                    right: 4.w,
                  ),
                  child: centerTitle
                      ? Center(child: _TitleBlock(title: title, subtitle: subtitle))
                      : _TitleBlock(title: title, subtitle: subtitle),
                ),
              ),

              // ========== Actions ================================
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showBack && showNotification)
                    NotificationIconButton(hasBadge: hasUnreadNotifications),
                  if (actions != null) ...actions!,
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TitleBlock extends StatelessWidget {
  final String title;
  final String? subtitle;

  const _TitleBlock({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
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
        if (subtitle != null) ...[
          SizedBox(height: 1.h),
          Text(
            subtitle!,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}

class _BackButton extends StatelessWidget {
  final Color backgroundColor;

  const _BackButton({required this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.maybePop(context),
      child: Container(
        width: 38.w,
        height: 38.w,
        margin: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: AppColors.surfaceBorder.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 16.w,
          color: AppColors.textHeading,
        ),
      ),
    );
  }
}

// ========== App Bar Action Button ================================
class AppBarAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool hasBadge;

  const AppBarAction({
    super.key,
    required this.icon,
    required this.onTap,
    this.iconColor,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            margin: EdgeInsets.only(left: 8.w),
            decoration: BoxDecoration(
              color: AppColors.surfaceBorder.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              size: 18.w,
              color: iconColor ?? AppColors.textHeading,
            ),
          ),
          if (hasBadge)
            Positioned(
              top: 6,
              right: 6,
              child: Container(
                width: 8.w,
                height: 8.w,
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ========== Notification Icon Button ================================
// Standalone reusable widget — call it anywhere in the widget tree.
// Navigates to NotificationsPage and shows a red dot badge when [hasBadge] is true.
class NotificationIconButton extends StatelessWidget {
  final bool hasBadge;
  final Color? iconColor;
  final Color? backgroundColor;

  const NotificationIconButton({
    super.key,
    this.hasBadge = true,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBarAction(
      icon: Icons.notifications_outlined,
      hasBadge: hasBadge,
      iconColor: iconColor,
      onTap: () => Navigator.push(
        context,
        SmoothPageRoute(page: const NotificationsPage()),
      ),
    );
  }
}
