import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import 'profile_page_scaffold.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameCtrl = TextEditingController(text: 'Afanyu Emmanuel');
  final _emailCtrl = TextEditingController(text: 'afanyu@example.com');
  final _phoneCtrl = TextEditingController(text: '+250 788 000 000');
  final _bioCtrl = TextEditingController(text: 'Passionate traveller exploring the beauty of Rwanda.');

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ProfilePageScaffold(
      title: 'Edit Profile',
      child: Column(
        children: [
          // Avatar
          Center(
            child: Stack(
              children: [
                Container(
                  width: 90.w,
                  height: 90.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2.5),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/general/profile.png',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: AppColors.primarySoft,
                        child: Icon(Icons.person_rounded,
                            color: AppColors.primary, size: 44.w),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 28.w,
                    height: 28.w,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(Icons.camera_alt_rounded,
                        size: 13.w, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Center(
            child: Text('Change photo',
                style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600)),
          ),
          SizedBox(height: 28.h),
          _Field(label: 'Full Name', controller: _nameCtrl, icon: Icons.person_outline_rounded),
          SizedBox(height: 16.h),
          _Field(label: 'Email Address', controller: _emailCtrl, icon: Icons.email_outlined, keyboardType: TextInputType.emailAddress),
          SizedBox(height: 16.h),
          _Field(label: 'Phone Number', controller: _phoneCtrl, icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
          SizedBox(height: 16.h),
          _Field(label: 'Bio', controller: _bioCtrl, icon: Icons.edit_note_rounded, maxLines: 3),
          SizedBox(height: 32.h),
          _SaveButton(onTap: () => Navigator.pop(context)),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;
  final int maxLines;

  const _Field({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
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
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18.w, color: AppColors.primary),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
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
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SaveButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                offset: const Offset(0, 4)),
          ],
        ),
        alignment: Alignment.center,
        child: Text('Save Changes',
            style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }
}
