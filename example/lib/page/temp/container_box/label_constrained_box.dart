import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: depend_on_referenced_packages
import 'package:print_image_generate_tool/print_image_generate_tool.dart';

///标签固定大小限制的容器 (生成尺寸 45 * 70 的标签)
class LabelConstrainedBox extends StatelessWidget with ATempWidget {
  final Widget child;

  const LabelConstrainedBox(this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 360.w,
      height: 560.w,
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
  int get pixelPagerWidth => 360;

  @override
  int get pixelPagerHeight => 560;

  @override
  double get pixelRatio => 1 / 1.w;
}
