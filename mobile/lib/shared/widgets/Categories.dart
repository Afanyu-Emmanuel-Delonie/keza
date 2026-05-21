import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';

class CategoriesSection extends StatefulWidget {
  final List<Map<String, dynamic>> categories;
  final ValueChanged<Map<String, dynamic>>? onCategorySelected;

  const CategoriesSection({
    super.key,
    required this.categories,
    this.onCategorySelected,
  });

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  // Always start with 'all' selected (index 0 if 'all' is first, else -1 means none)
  String _selectedId = 'all';

  @override
  Widget build(BuildContext context) {
    // Ensure 'All' is always the first chip
    final cats = widget.categories;
    final hasAll = cats.any((c) => c['id'] == 'all');
    final items = hasAll
        ? cats
        : [
            {'id': 'all', 'name': 'All', 'icon': Icons.apps_rounded},
            ...cats,
          ];

    return SizedBox(
      height: 36.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final category = items[index];
          final id = category['id'] as String;
          final isActive = _selectedId == id;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedId = id);
              widget.onCategorySelected?.call(category);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 10.w),
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(30.r),
                boxShadow: [
                  BoxShadow(
                    color: isActive
                        ? AppColors.primary.withOpacity(0.25)
                        : Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category['icon'] as IconData? ?? Icons.place,
                    size: 15.w,
                    color: isActive ? Colors.white : AppColors.primary,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    category['name'] as String? ?? '',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: isActive ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
