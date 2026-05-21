import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import 'profile_page_scaffold.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selected = 'English';

  static const _languages = [
    _Lang('English', 'EN', '🇬🇧'),
    _Lang('French', 'FR', '🇫🇷'),
    _Lang('Kinyarwanda', 'RW', '🇷🇼'),
    _Lang('Swahili', 'SW', '🌍'),
    _Lang('German', 'DE', '🇩🇪'),
    _Lang('Spanish', 'ES', '🇪🇸'),
    _Lang('Chinese', 'ZH', '🇨🇳'),
  ];

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Language',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose your preferred language for the Keza app.',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary, height: 1.5),
          ),
          SizedBox(height: 24.h),
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
              children: _languages.asMap().entries.map((e) {
                final i = e.key;
                final lang = e.value;
                final active = _selected == lang.name;
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _selected = lang.name),
                      behavior: HitTestBehavior.opaque,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        color: active ? AppColors.primarySoft.withOpacity(0.5) : Colors.transparent,
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        child: Row(
                          children: [
                            Text(lang.flag, style: TextStyle(fontSize: 22.sp)),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(lang.name,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: active ? AppColors.primaryDark : AppColors.textPrimary,
                                      )),
                                  Text(lang.code,
                                      style: TextStyle(fontSize: 11.sp, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 22.w,
                              height: 22.w,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: active ? AppColors.primary : Colors.transparent,
                                border: Border.all(
                                  color: active ? AppColors.primary : AppColors.surfaceBorder,
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(Icons.check_rounded,
                                  size: 12.w,
                                  color: active ? Colors.white : Colors.transparent),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (i < _languages.length - 1)
                      Divider(height: 1, indent: 56.w, color: AppColors.surfaceBorder),
                  ],
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 32.h),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text('Apply Language',
                  style: TextStyle(
                      fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Lang {
  final String name;
  final String code;
  final String flag;
  const _Lang(this.name, this.code, this.flag);
}
