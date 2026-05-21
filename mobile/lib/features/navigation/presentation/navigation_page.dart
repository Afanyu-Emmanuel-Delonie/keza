import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../home_screen/presentation/HomeScreen.dart';
import '../../explore/presentation/ExploreScreen.dart';
import '../../trips/presentation/TripsScreen.dart';
import '../../ai/presentation/AiScreen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/skeleton.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  static void jumpToTab(BuildContext context, int index) {
    final state = context.findAncestorStateOfType<_NavigationPageState>();
    state?.jumpTo(index);
  }

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;
  bool _showSkeleton = true;
  bool _noInternet = false;

  void jumpTo(int index) => setState(() => _currentIndex = index);

  void _retry() {
    setState(() {
      _noInternet = false;
      _showSkeleton = true;
    });
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted && !_noInternet) setState(() => _showSkeleton = false);
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _showSkeleton) {
        setState(() {
          _showSkeleton = false;
          _noInternet = true;
        });
      }
    });
  }

  final List<Widget> _pages = [
    const HomeScreen(),
    const ExploreScreen(),
    const TripsScreen(),
    const AiScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // 5-second timeout: if still loading, show no-internet state
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && _showSkeleton) {
        setState(() {
          _showSkeleton = false;
          _noInternet = true;
        });
      }
    });
    // Simulate content ready (replace with real readiness signal if available)
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted && !_noInternet) setState(() => _showSkeleton = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            IndexedStack(
              index: _currentIndex,
              children: _pages,
            ),
            if (_noInternet)
              _NoInternetOverlay(onRetry: _retry),
            AnimatedOpacity(
              opacity: _showSkeleton ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 400),
              child: IgnorePointer(
                ignoring: !_showSkeleton,
                child: const HomeSkeletonScreen(),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _KezaNavBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
        ),
      ),
    );
  }
}

class _TabDef {
  final String label;
  final IconData? icon;
  final IconData? activeIcon;
  final bool isSvg;
  const _TabDef({required this.label, this.icon, this.activeIcon, this.isSvg = false});
}

const _tabs = [
  _TabDef(label: 'Home',    icon: Icons.home_outlined,        activeIcon: Icons.home_rounded),
  _TabDef(label: 'Explore', icon: Icons.explore_outlined,     activeIcon: Icons.explore_rounded),
  _TabDef(label: 'Trips',   icon: Icons.card_travel_outlined, activeIcon: Icons.card_travel_rounded),
  _TabDef(label: 'Keza AI', isSvg: true),
  _TabDef(label: 'Profile', icon: Icons.person_outline,       activeIcon: Icons.person_rounded),
];

class _KezaNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _KezaNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.surfaceBorder, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: EdgeInsets.only(bottom: bottomPadding > 0 ? bottomPadding : 8.h),
      child: Row(
        children: List.generate(_tabs.length, (i) => Expanded(
          child: _NavTab(
            tab: _tabs[i],
            isActive: currentIndex == i,
            onTap: () => onTap(i),
          ),
        )),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  final _TabDef tab;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTab({required this.tab, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ===== Active indicator tab =====
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOutCubic,
            height: 3.h,
            width: isActive ? 28.w : 0,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(3.r),
                bottomRight: Radius.circular(3.r),
              ),
            ),
          ),
          SizedBox(height: 8.h),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: tab.isSvg
                ? SvgPicture.asset(
                    isActive
                        ? 'assets/general/main-logo.svg'
                        : 'assets/general/main-logo-outlined.svg',
                    key: ValueKey(isActive),
                    width: 22.w,
                    height: 22.w,
                    colorFilter: ColorFilter.mode(
                      isActive ? AppColors.primary : AppColors.textSecondary,
                      BlendMode.srcIn,
                    ),
                  )
                : Icon(
                    key: ValueKey(isActive),
                    isActive ? tab.activeIcon! : tab.icon!,
                    size: 22.w,
                    color: isActive ? AppColors.primary : AppColors.textSecondary,
                  ),
          ),
          SizedBox(height: 4.h),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
            child: Text(tab.label),
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }
}

// ── No Internet overlay ───────────────────────────────────────────────────────────────
class _NoInternetOverlay extends StatelessWidget {
  final VoidCallback onRetry;
  const _NoInternetOverlay({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.wifi_off_rounded, size: 56.w, color: AppColors.textSecondary),
            SizedBox(height: 16.h),
            Text(
              'No Internet Connection',
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textHeading,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Check your connection and try again.',
              style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
            ),
            SizedBox(height: 24.h),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  'Retry',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
