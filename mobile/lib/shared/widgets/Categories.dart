import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/theme/app_colors.dart';

class CategoriesSection extends StatefulWidget {
  final List<Map<String, String>> categories;
  final ValueChanged<Map<String, String>>? onCategorySelected;

  const CategoriesSection({
    super.key,
    required this.categories,
    this.onCategorySelected,
  });

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: widget.categories.length,
        itemBuilder: (context, index) {
          final category = widget.categories[index];
          final isActive = _selected == index;

          return GestureDetector(
            onTap: () {
              setState(() => _selected = index);
              widget.onCategorySelected?.call(category);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: EdgeInsets.only(right: 10.w),
              padding: EdgeInsets.only(right: 12.w),
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.r),
                    child: CachedNetworkImage(
                      imageUrl: category['image'] ?? '',
                      width: 36.h,
                      height: 36.h,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        width: 36.h,
                        height: 36.h,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image, size: 14, color: Colors.grey),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    category['name'] ?? '',
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
