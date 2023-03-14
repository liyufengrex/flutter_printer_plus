import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: depend_on_referenced_packages
import 'package:print_image_generate_tool/print_image_generate_tool.dart';

///小票固定大小限制的容器 (生成尺寸 宽80 的小票)
class ReceiptConstrainedBox extends StatelessWidget with ATempWidget {
  final Widget child;

  const ReceiptConstrainedBox(this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 550.w,
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
  int get pixelPagerWidth => 550;

  @override
  double get pixelRatio => 1 / 1.w;
}
