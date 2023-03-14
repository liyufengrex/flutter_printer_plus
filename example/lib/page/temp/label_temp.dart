import 'package:flutter/material.dart';
import '../../module/printer_info.dart';
import 'base_generate_widget.dart';

// ignore: depend_on_referenced_packages
import 'package:print_image_generate_tool/print_image_generate_tool.dart';

import 'container_box/label_constrained_box.dart';
import 'demo/label_temp_demo.dart';

// 预览标签
class LabelTempWidget extends BaseGenerateWidget {
  final PrinterInfo printerInfo;

  const LabelTempWidget(this.printerInfo, {Key? key}) : super(key: key);

  @override
  void doPrint() {
    // 生成打印图层任务，指定任务类型为标签
    PictureGeneratorProvider.instance.addPicGeneratorTask(
      PicGenerateTask<PrinterInfo>(
        tempWidget: child() as ATempWidget,
        printTypeEnum: PrintTypeEnum.label,
        params: printerInfo,
      ),
    );
  }

  @override
  Widget child() {
    return const LabelConstrainedBox(
      LabelStyleWidget(),
    );
  }
}
