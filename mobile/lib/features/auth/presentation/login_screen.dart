import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/auth_provider.dart';
import 'widgets/auth_text_field.dart';
import 'widgets/social_auth_button.dart';
import 'widgets/auth_header.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _showPass = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await context
        .read<AuthProvider>()
        .loginWithEmail(_emailCtrl.text.trim(), _passCtrl.text);
    if (ok && mounted) context.go('/');
  }

  Future<void> _social(Future<bool> Function() fn) async {
    final ok = await fn();
    if (ok && mounted) context.go('/');
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
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 28.w),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 40.h),

                  const AuthHeader(
                    title: 'Welcome Back 👋',
                    subtitle: 'Sign in to continue exploring Rwanda',
                  ),
                  SizedBox(height: 36.h),

                  // ── Fields ──
                  AuthTextField(
                    label: 'Email Address',
                    controller: _emailCtrl,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    hint: 'you@example.com',
                    validator: (v) => v != null && v.contains('@') ? null : 'Enter a valid email',
                  ),
                  SizedBox(height: 14.h),
                  AuthTextField(
                    label: 'Password',
                    controller: _passCtrl,
                    icon: Icons.lock_outline_rounded,
                    obscure: !_showPass,
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() => _showPass = !_showPass),
                      child: Icon(
                        _showPass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 18.w,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    validator: (v) => v != null && v.length >= 6 ? null : 'Password too short',
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => context.push('/forgot-password'),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.h),

                  // ── Sign in button ──
                  Consumer<AuthProvider>(
                    builder: (_, auth, __) => _PrimaryButton(
                      label: 'Sign In',
                      loading: auth.isLoading,
                      onTap: _login,
                    ),
                  ),

                  Consumer<AuthProvider>(
                    builder: (_, auth, __) {
                      if (auth.error == null) return const SizedBox.shrink();
                      return Padding(
                        padding: EdgeInsets.only(top: 12.h),
                        child: _ErrorBanner(message: auth.error!),
                      );
                    },
                  ),

                  SizedBox(height: 32.h),
                  _OrDivider(),
                  SizedBox(height: 24.h),

                  // ── Social row ──
                  Consumer<AuthProvider>(
                    builder: (_, auth, __) => SocialAuthRow(
                      onGoogle: () => _social(auth.loginWithGoogle),
                      onFacebook: () => _social(auth.loginWithFacebook),
                      onApple: () => _social(auth.loginWithApple),
                    ),
                  ),

                  SizedBox(height: 40.h),

                  GestureDetector(
                    onTap: () => context.go('/register'),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
                        children: [
                          const TextSpan(text: "Don't have an account? "),
                          TextSpan(
                            text: 'Sign Up',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shared widgets ────────────────────────────────────────────────────────────
class _PrimaryButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.loading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: loading ? null : onTap,
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
        child: loading
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text(
                label,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.white),
              ),
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.surfaceBorder)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Text(
            'or continue with',
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
          ),
        ),
        Expanded(child: Divider(color: AppColors.surfaceBorder)),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  final String message;
  const _ErrorBanner({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.errorSoft,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline_rounded, size: 16.w, color: AppColors.error),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(message, style: TextStyle(fontSize: 12.sp, color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}
