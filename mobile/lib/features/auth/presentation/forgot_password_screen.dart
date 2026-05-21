import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import 'widgets/auth_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await context.read<AuthProvider>().forgotPassword(_emailCtrl.text.trim());
    if (ok && mounted) setState(() => _sent = true);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // ── Back button ──
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w, top: 8.h),
                  child: GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          size: 16.w, color: AppColors.textHeading),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 28.w),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    child: _sent
                        ? _SuccessView(key: const ValueKey('success'), email: _emailCtrl.text.trim())
                        : _FormView(
                            key: const ValueKey('form'),
                            emailCtrl: _emailCtrl,
                            formKey: _formKey,
                            onSend: _send,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FormView extends StatelessWidget {
  final TextEditingController emailCtrl;
  final GlobalKey<FormState> formKey;
  final VoidCallback onSend;

  const _FormView({super.key, required this.emailCtrl, required this.formKey, required this.onSend});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 40.h),

          // icon
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              gradient: AppColors.aiGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(Icons.lock_reset_rounded, size: 34.w, color: Colors.white),
          ),
          SizedBox(height: 24.h),

          Text(
            'Forgot Password?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textHeading,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Enter your email and we\'ll send\na link to reset your password.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary, height: 1.55),
          ),
          SizedBox(height: 36.h),

          AuthTextField(
            label: 'Email Address',
            controller: emailCtrl,
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            hint: 'you@example.com',
            validator: (v) => v != null && v.contains('@') ? null : 'Enter a valid email',
          ),
          SizedBox(height: 28.h),

          Consumer<AuthProvider>(
            builder: (_, auth, __) => GestureDetector(
              onTap: auth.isLoading ? null : onSend,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF007D3D), Color(0xFF00A651)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.32),
                      blurRadius: 16,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: auth.isLoading
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text('Send Reset Link',
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ),
          SizedBox(height: 24.h),

          GestureDetector(
            onTap: () => context.pop(),
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
                children: [
                  const TextSpan(text: 'Remember your password? '),
                  TextSpan(
                    text: 'Sign In',
                    style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
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

class _SuccessView extends StatelessWidget {
  final String email;
  const _SuccessView({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 60.h),
        Container(
          width: 80.w,
          height: 80.w,
          decoration: BoxDecoration(
            gradient: AppColors.aiGradient,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(Icons.mark_email_read_rounded, color: Colors.white, size: 38.w),
        ),
        SizedBox(height: 28.h),
        Text(
          'Check Your Email',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textHeading,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 12.h),
        Text(
          'We sent a password reset link to\n$email',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary, height: 1.6),
        ),
        SizedBox(height: 40.h),
        GestureDetector(
          onTap: () => context.go('/login'),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF007D3D), Color(0xFF00A651)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.32),
                  blurRadius: 16,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Text('Back to Sign In',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ),
        SizedBox(height: 16.h),
        TextButton(
          onPressed: () {},
          child: Text(
            'Resend email',
            style: TextStyle(fontSize: 13.sp, color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
