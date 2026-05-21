import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import 'profile_page_scaffold.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  int get _strength {
    final p = _newCtrl.text;
    if (p.isEmpty) return 0;
    int s = 0;
    if (p.length >= 8) s++;
    if (RegExp(r'[A-Z]').hasMatch(p)) s++;
    if (RegExp(r'[0-9]').hasMatch(p)) s++;
    if (RegExp(r'[!@#\$%^&*]').hasMatch(p)) s++;
    return s;
  }

  Color get _strengthColor {
    switch (_strength) {
      case 1: return AppColors.error;
      case 2: return AppColors.warning;
      case 3: return const Color(0xFF4ADE80);
      case 4: return AppColors.primary;
      default: return AppColors.surfaceBorder;
    }
  }

  String get _strengthLabel {
    switch (_strength) {
      case 1: return 'Weak';
      case 2: return 'Fair';
      case 3: return 'Good';
      case 4: return 'Strong';
      default: return '';
    }
  }

  bool get _canSave =>
      _currentCtrl.text.isNotEmpty &&
      _newCtrl.text.length >= 8 &&
      _newCtrl.text == _confirmCtrl.text;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Change Password',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose a strong password to keep your account secure.',
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary, height: 1.5),
          ),
          SizedBox(height: 28.h),

          _PasswordField(
            label: 'Current Password',
            controller: _currentCtrl,
            show: _showCurrent,
            onToggle: () => setState(() => _showCurrent = !_showCurrent),
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: 16.h),

          _PasswordField(
            label: 'New Password',
            controller: _newCtrl,
            show: _showNew,
            onToggle: () => setState(() => _showNew = !_showNew),
            onChanged: (_) => setState(() {}),
          ),

          // ── Strength bar ──
          if (_newCtrl.text.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Row(
              children: [
                ...List.generate(4, (i) => Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 4.h,
                    margin: EdgeInsets.only(right: i < 3 ? 4.w : 0),
                    decoration: BoxDecoration(
                      color: i < _strength ? _strengthColor : AppColors.surfaceBorder,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                )),
                SizedBox(width: 10.w),
                Text(
                  _strengthLabel,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: _strengthColor,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Text(
              'Use 8+ characters with uppercase, numbers & symbols',
              style: TextStyle(fontSize: 11.sp, color: AppColors.textDisabled),
            ),
          ],

          SizedBox(height: 16.h),

          _PasswordField(
            label: 'Confirm New Password',
            controller: _confirmCtrl,
            show: _showConfirm,
            onToggle: () => setState(() => _showConfirm = !_showConfirm),
            onChanged: (_) => setState(() {}),
            errorText: _confirmCtrl.text.isNotEmpty && _confirmCtrl.text != _newCtrl.text
                ? 'Passwords do not match'
                : null,
          ),

          SizedBox(height: 36.h),

          GestureDetector(
            onTap: _canSave ? () => Navigator.pop(context) : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 15.h),
              decoration: BoxDecoration(
                color: _canSave ? AppColors.primary : AppColors.surfaceBorder,
                borderRadius: BorderRadius.circular(14.r),
                boxShadow: _canSave
                    ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                'Update Password',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: _canSave ? Colors.white : AppColors.textDisabled,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool show;
  final VoidCallback onToggle;
  final ValueChanged<String> onChanged;
  final String? errorText;

  const _PasswordField({
    required this.label,
    required this.controller,
    required this.show,
    required this.onToggle,
    required this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary)),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          obscureText: !show,
          onChanged: onChanged,
          style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.lock_outline_rounded, size: 18.w, color: AppColors.primary),
            suffixIcon: GestureDetector(
              onTap: onToggle,
              child: Icon(
                show ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 18.w,
                color: AppColors.textSecondary,
              ),
            ),
            errorText: errorText,
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.surfaceBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.surfaceBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: const BorderSide(color: AppColors.error),
            ),
          ),
        ),
      ],
    );
  }
}
