import 'package:example/page/temp/label_temp.dart';
import 'package:example/page/temp/receipt_temp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: depend_on_referenced_packages
import 'package:print_image_generate_tool/print_image_generate_tool.dart';
import '../module/printer_info.dart';
import 'temp/container_box/label_constrained_box.dart';
import 'temp/container_box/receipt_constrained_box.dart';
import 'temp/demo/label_temp_demo.dart';
import 'temp/demo/receipt_temp_demo.dart';

///打印机详情页
class PrinterContentWidget extends StatelessWidget {
  final PrinterInfo printerInfo;

  const PrinterContentWidget(
    this.printerInfo, {
    Key? key,
  }) : super(key: key);

  List<FuncEnum> get funcs => [
        FuncEnum.previewReceipt,
        FuncEnum.previewLabel,
        FuncEnum.printReceipt,
        FuncEnum.printLabel,
      ];

  Widget _title(BuildContext context) {
    return Text(
      '已选中打印机（${printerInfo.name}）功能列表如下：',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(context),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: funcs.length,
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(height: 10);
          },
          itemBuilder: (BuildContext context, int index) {
            final func = funcs[index];
            return Center(
              child: TextButton(
                onPressed: () {
                  func.performCommand(context, printerInfo);
                },
                child: Text(func.label),
              ),
            );
          },
        ),
      ),
    );
  }
}

enum FuncEnum {
  previewReceipt,
  previewLabel,
  printReceipt,
  printLabel,
}

extension ExFuncEnum on FuncEnum {
  String get label {
    switch (this) {
      case FuncEnum.previewReceipt:
        return '预览打印小票';
      case FuncEnum.previewLabel:
        return '预览打印标签';
      case FuncEnum.printReceipt:
        return '打印小票';
      case FuncEnum.printLabel:
        return '打印标签';
    }
  }

  ///执行对应的命令行
  void performCommand(
    BuildContext context,
    PrinterInfo printerInfo,
  ) {
    switch (this) {
      case FuncEnum.previewReceipt:
        // 预览小票
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ReceiptTempWidget(
                printerInfo,
                receiptWidth: 550,
              );
            },
          ),
        );
        break;
      case FuncEnum.previewLabel:
        // 预览标签
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LabelTempWidget(
                printerInfo,
                labelWidth: 360,
                labelHeight: 560,
              );
            },
          ),
        );
        break;
      case FuncEnum.printReceipt:
        // 直接打印小票
        PictureGeneratorProvider.instance.addPicGeneratorTask(
          PicGenerateTask<PrinterInfo>(
            tempWidget: const ReceiptConstrainedBox(
              ReceiptStyleWidget(),
              pageWidth: 550,
            ),
            printTypeEnum: PrintTypeEnum.receipt,
            params: printerInfo,
          ),
        );
        break;
      case FuncEnum.printLabel:
        // 直接打印标签
        PictureGeneratorProvider.instance.addPicGeneratorTask(
          PicGenerateTask<PrinterInfo>(
            tempWidget: const LabelConstrainedBox(
              LabelStyleWidget(),
              pageWidth: 360,
              pageHeight: 560,
            ),
            printTypeEnum: PrintTypeEnum.label,
            params: printerInfo,
          ),
        );
        break;
    }
  }
}
