import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/keza_app_bar.dart';
import 'general_chat_screen.dart';
import 'explore_book/explore_book_ai_screen.dart';
import 'trip_builder/ai_trip_builder_screen.dart';

class AiScreen extends StatelessWidget {
  const AiScreen({super.key});

  void _openChat(BuildContext context, [String? prompt]) {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => GeneralChatScreen(initialPrompt: prompt)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: KezaAppBar(
        title: 'Keza AI',
        subtitle: 'Your Rwanda travel planner',
        showBack: false,
        actions: [
          AppBarAction(icon: Icons.history_rounded, onTap: () {}),
        ],
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),

              // ── Hero ──
              _HeroCard(),
              SizedBox(height: 24.h),

              // ── AI Modes ──
              _SectionLabel('What would you like to do?'),
              SizedBox(height: 12.h),
              _ModeCard(
                gradient: const LinearGradient(
                  colors: [Color(0xFF004B24), Color(0xFF00A651)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.auto_awesome_rounded,
                title: 'Explore & Book with AI',
                description: 'Describe what you want — AI finds destinations, hotels, and tours. You confirm, we book.',
                tag: 'SMART SEARCH',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ExploreBookAiScreen())),
              ),
              SizedBox(height: 12.h),
              _ModeCard(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A1A4B), Color(0xFF3B3E9E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.route_rounded,
                title: 'AI Trip Builder',
                description: 'AI reads your saved trips and preferences, then builds a full day-by-day itinerary.',
                tag: 'PERSONALIZED',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AiTripBuilderScreen())),
              ),
              SizedBox(height: 12.h),
              _ModeCard(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2D1B00), Color(0xFF8B5E00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                icon: Icons.chat_bubble_outline_rounded,
                title: 'General Chat',
                description: 'Ask anything about Rwanda — visa, safety, weather, culture, food, and more.',
                tag: 'OPEN CHAT',
                onTap: () => _openChat(context),
              ),

              SizedBox(height: 28.h),

              // ── Travel Info CTAs ──
              _SectionLabel('Rwanda Travel Info'),
              SizedBox(height: 4.h),
              Text('Tap any card to ask Keza AI',
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
              SizedBox(height: 14.h),

              // 2-column grid of info cards
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 1.15,
                children: [
                  _InfoCard(
                    emoji: '🛂',
                    title: 'Visa Checklist',
                    subtitle: 'Requirements, e-Visa & on-arrival info',
                    color: const Color(0xFFE8F5E9),
                    iconColor: AppColors.primary,
                    onTap: () => _openChat(context, 'Visa requirements for Rwanda'),
                  ),
                  _InfoCard(
                    emoji: '🛡️',
                    title: 'Safety Guide',
                    subtitle: 'Crime rates, emergency numbers & tips',
                    color: const Color(0xFFE3F2FD),
                    iconColor: AppColors.info,
                    onTap: () => _openChat(context, 'Is Rwanda safe for tourists?'),
                  ),
                  _InfoCard(
                    emoji: '🌤️',
                    title: 'Best Season',
                    subtitle: 'When to visit & what to expect',
                    color: const Color(0xFFFFF8E1),
                    iconColor: const Color(0xFFB06000),
                    onTap: () => _openChat(context, 'Best time to visit Rwanda'),
                  ),
                  _InfoCard(
                    emoji: '💵',
                    title: 'Money & Payments',
                    subtitle: 'Currency, ATMs & mobile money',
                    color: const Color(0xFFF3E5F5),
                    iconColor: const Color(0xFF7B1FA2),
                    onTap: () => _openChat(context, 'Currency and payments in Rwanda'),
                  ),
                  _InfoCard(
                    emoji: '🏥',
                    title: 'Health & Vaccines',
                    subtitle: 'Required vaccinations & health tips',
                    color: const Color(0xFFFFEBEE),
                    iconColor: AppColors.error,
                    onTap: () => _openChat(context, 'Health and vaccinations for Rwanda'),
                  ),
                  _InfoCard(
                    emoji: '📱',
                    title: 'SIM & Internet',
                    subtitle: 'Local SIM cards & connectivity',
                    color: const Color(0xFFE0F7FA),
                    iconColor: const Color(0xFF00838F),
                    onTap: () => _openChat(context, 'SIM card and internet in Rwanda'),
                  ),
                ],
              ),

              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Hero card ─────────────────────────────────────────────────────────────────
class _HeroCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: AppColors.aiGradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
              color: AppColors.primaryDarker.withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text('POWERED BY AI',
                      style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5)),
                ),
                SizedBox(height: 10.h),
                Text('Plan your Rwanda\nadventure',
                    style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                        letterSpacing: -0.5)),
                SizedBox(height: 6.h),
                Text('Explore, plan, and book — all in one place.',
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.75),
                        height: 1.5)),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Opacity(
            opacity: 0.25,
            child: SvgPicture.asset('assets/general/main-logo.svg',
                width: 72.w,
                height: 72.w,
                colorFilter:
                    const ColorFilter.mode(Colors.white, BlendMode.srcIn)),
          ),
        ],
      ),
    );
  }
}

// ── Mode card ─────────────────────────────────────────────────────────────────
class _ModeCard extends StatelessWidget {
  final LinearGradient gradient;
  final IconData icon;
  final String title;
  final String description;
  final String tag;
  final VoidCallback onTap;

  const _ModeCard({
    required this.gradient,
    required this.icon,
    required this.title,
    required this.description,
    required this.tag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(18.w),
        decoration: BoxDecoration(
            gradient: gradient, borderRadius: BorderRadius.circular(16.r)),
        child: Row(
          children: [
            Container(
              width: 46.w,
              height: 46.w,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: Colors.white, size: 22.w),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tag,
                      style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.white.withOpacity(0.6),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.4)),
                  SizedBox(height: 3.h),
                  Text(title,
                      style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  SizedBox(height: 4.h),
                  Text(description,
                      style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.45)),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14.w, color: Colors.white.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}

// ── Info card ─────────────────────────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;
  final Color iconColor;
  final VoidCallback onTap;

  const _InfoCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Center(
                child: Text(emoji, style: TextStyle(fontSize: 20.sp)),
              ),
            ),
            SizedBox(height: 10.h),
            Text(title,
                style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeading)),
            SizedBox(height: 3.h),
            Text(subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                    height: 1.4)),
          ],
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textHeading,
            letterSpacing: -0.2));
  }
}
