import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: depend_on_referenced_packages
import 'package:print_image_generate_tool/print_image_generate_tool.dart';

///标签固定大小限制的容器 (生成尺寸 45 * 70 的标签)
class LabelConstrainedBox extends StatelessWidget with ATempWidget {
  final Widget child;

  // 传入标签的限制宽度、高度(单位像素)
  final int pageWidth, pageHeight;

  const LabelConstrainedBox(
    this.child, {
    Key? key,
    required this.pageWidth,
    required this.pageHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: pageWidth.w,
      height: pageHeight.w,
      child: ColorFiltered(
        colorFilter: const ColorFilter.mode(
          Colors.black,
          BlendMode.srcIn,
        ),
        child: child,
      ),
    );
  }

  @override
  int get pixelPagerWidth => pageWidth;

  @override
  int get pixelPagerHeight => pageHeight;

  @override
  double get pixelRatio => 1 / 1.w;
}
