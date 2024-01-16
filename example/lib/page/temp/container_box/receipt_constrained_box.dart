import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: depend_on_referenced_packages
import 'package:print_image_generate_tool/print_image_generate_tool.dart';

///小票固定大小限制的容器 (生成尺寸 宽80 的小票)
class ReceiptConstrainedBox extends StatelessWidget with ATempWidget {
  final Widget child;

  // 传入小票的限制宽度(单位像素)
  final int pageWidth;

  const ReceiptConstrainedBox(
    this.child, {
    Key? key,
    required this.pageWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: pageWidth.w,
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
  double get pixelRatio => 1 / 1.w;
}
