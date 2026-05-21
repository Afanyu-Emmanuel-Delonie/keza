import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class AiInputBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSend;
  final bool isLoading;
  final String hintText;

  const AiInputBar({
    super.key,
    required this.controller,
    required this.onSend,
    this.isLoading = false,
    this.hintText = 'Where do you want to go?',
  });

  @override
  State<AiInputBar> createState() => _AiInputBarState();
}

class _AiInputBarState extends State<AiInputBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final has = widget.controller.text.trim().isNotEmpty;
    if (has != _hasText) setState(() => _hasText = has);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _send() {
    final text = widget.controller.text.trim();
    if (text.isEmpty || widget.isLoading) return;
    widget.onSend(text);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, bottom > 0 ? bottom + 6.h : 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.surfaceBorder)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      // ── Same pill style as CustomSearchBar ──
      child: Container(
        padding: EdgeInsets.only(left: 14.w, right: 6.w, top: 6.h, bottom: 6.h),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(50.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // AI spark icon on left (mirrors search icon in CustomSearchBar)
            Icon(Icons.auto_awesome_rounded,
                color: AppColors.primary, size: 20.w),
            SizedBox(width: 8.w),
            // Text field
            Expanded(
              child: TextField(
                controller: widget.controller,
                maxLines: 1,
                style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                      fontSize: 13.sp, color: AppColors.textSecondary),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            SizedBox(width: 4.w),
            // Send button — green circle (mirrors filter button in CustomSearchBar)
            GestureDetector(
              onTap: _send,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: _hasText && !widget.isLoading
                      ? AppColors.primary
                      : AppColors.surfaceBorder,
                  shape: BoxShape.circle,
                ),
                child: widget.isLoading
                    ? SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : Icon(
                        Icons.arrow_upward_rounded,
                        color: _hasText ? Colors.white : AppColors.textDisabled,
                        size: 16.w,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
