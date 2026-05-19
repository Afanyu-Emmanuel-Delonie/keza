import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/keza_app_bar.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
        child: Column(
          children: [
            // ── Empty state with logo watermark ──────────────
            Expanded(
              child: Center(
                child: Opacity(
                  opacity: 0.06,
                  child: SvgPicture.asset(
                    'assets/general/main-logo.svg',
                    width: 180.w,
                    height: 180.w,
                    colorFilter: const ColorFilter.mode(
                      AppColors.primaryDarker,
                      BlendMode.srcIn,
                    ),
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
