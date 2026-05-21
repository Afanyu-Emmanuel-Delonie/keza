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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPass = false;
  bool _showConfirm = false;
  bool _agreed = false;

  int get _strength {
    final p = _passCtrl.text;
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

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the Terms & Privacy Policy')),
      );
      return;
    }
    final ok = await context.read<AuthProvider>().registerWithEmail(
          _nameCtrl.text.trim(),
          _emailCtrl.text.trim(),
          _passCtrl.text,
        );
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
                  SizedBox(height: 36.h),

                  const AuthHeader(
                    title: 'Create Account ✨',
                    subtitle: 'Join Keza and start exploring Rwanda',
                  ),
                  SizedBox(height: 32.h),

                  AuthTextField(
                    label: 'Full Name',
                    controller: _nameCtrl,
                    icon: Icons.person_outline_rounded,
                    hint: 'e.g. Amina Uwase',
                    validator: (v) => v != null && v.trim().length >= 2 ? null : 'Enter your full name',
                  ),
                  SizedBox(height: 14.h),
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
                    validator: (v) => v != null && v.length >= 8 ? null : 'Minimum 8 characters',
                  ),

                  if (_passCtrl.text.isNotEmpty) ...[
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        ...List.generate(4, (i) => Expanded(
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            height: 3.h,
                            margin: EdgeInsets.only(right: i < 3 ? 4.w : 0),
                            decoration: BoxDecoration(
                              color: i < _strength ? _strengthColor : AppColors.surfaceBorder,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        )),
                        SizedBox(width: 10.w),
                        Text(_strengthLabel,
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: _strengthColor)),
                      ],
                    ),
                  ],

                  SizedBox(height: 14.h),
                  AuthTextField(
                    label: 'Confirm Password',
                    controller: _confirmCtrl,
                    icon: Icons.lock_outline_rounded,
                    obscure: !_showConfirm,
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() => _showConfirm = !_showConfirm),
                      child: Icon(
                        _showConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        size: 18.w,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    validator: (v) => v == _passCtrl.text ? null : 'Passwords do not match',
                  ),
                  SizedBox(height: 18.h),

                  // ── Terms ──
                  GestureDetector(
                    onTap: () => setState(() => _agreed = !_agreed),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: _agreed ? AppColors.primary : Colors.white,
                            borderRadius: BorderRadius.circular(5.r),
                            border: Border.all(
                              color: _agreed ? AppColors.primary : AppColors.surfaceBorder,
                              width: 1.5,
                            ),
                          ),
                          child: _agreed
                              ? Icon(Icons.check_rounded, size: 13.w, color: Colors.white)
                              : null,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary, height: 1.5),
                              children: [
                                const TextSpan(text: 'I agree to the '),
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  Consumer<AuthProvider>(
                    builder: (_, auth, __) => _PrimaryButton(
                      label: 'Create Account',
                      loading: auth.isLoading,
                      onTap: _register,
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

                  SizedBox(height: 28.h),
                  _OrDivider(),
                  SizedBox(height: 24.h),

                  Consumer<AuthProvider>(
                    builder: (_, auth, __) => SocialAuthRow(
                      onGoogle: () => _social(auth.loginWithGoogle),
                      onFacebook: () => _social(auth.loginWithFacebook),
                      onApple: () => _social(auth.loginWithApple),
                    ),
                  ),

                  SizedBox(height: 36.h),

                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary),
                        children: [
                          const TextSpan(text: 'Already have an account? '),
                          TextSpan(
                            text: 'Sign In',
                            style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
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
            : Text(label,
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.white)),
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
          child: Text('or sign up with',
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
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
          Expanded(child: Text(message, style: TextStyle(fontSize: 12.sp, color: AppColors.error))),
        ],
      ),
    );
  }
}
