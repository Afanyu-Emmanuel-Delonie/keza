import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../home_screen/presentation/HomeScreen.dart';
import '../../explore/presentation/ExploreScreen.dart';
import '../../trips/presentation/TripsScreen.dart';
import '../../ai/presentation/AiScreen.dart';
import '../../../core/theme/app_colors.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({super.key});

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const ExploreScreen(),
    const TripsScreen(),
    const AiScreen(),
    const Center(child: Text('Profile')),
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _pages,
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
