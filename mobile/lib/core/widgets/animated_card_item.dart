import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedCardItem extends StatefulWidget {
  final Widget child;
  final int index;

  const AnimatedCardItem({
    super.key, 
    required this.child, 
    required this.index,
  });

  @override
  State<AnimatedCardItem> createState() => _AnimatedCardItemState();
}

class _AnimatedCardItemState extends State<AnimatedCardItem> {
  bool _isAnimated = false;

  @override
  void initState() {
    super.initState();
    // Introduces a slight, staggered delay so items don't all jump at once
    Future.delayed(Duration(milliseconds: 100 * widget.index), () {
      if (mounted) {
        setState(() {
          _isAnimated = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      opacity: _isAnimated ? 1.0 : 0.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        // Translates layout upward by 20 density units until state flips true
        transform: Matrix4.translationValues(0, _isAnimated ? 0 : 20.h, 0),
        child: widget.child,
      ),
    );
  }
}
