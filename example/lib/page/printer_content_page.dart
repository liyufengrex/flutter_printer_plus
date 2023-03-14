import 'package:example/page/temp/label_temp.dart';
import 'package:example/page/temp/receipt_temp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../module/printer_info.dart';

///打印机详情页
class PrinterContentWidget extends StatelessWidget {
  final PrinterInfo printerInfo;

  const PrinterContentWidget(
    this.printerInfo, {
    Key? key,
  }) : super(key: key);

  List<FuncEnum> get funcs => [
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
  printReceipt,
  printLabel,
}

extension ExFuncEnum on FuncEnum {
  String get label {
    switch (this) {
      case FuncEnum.printReceipt:
        return '预览打印小票';
      case FuncEnum.printLabel:
        return '预览打印标签';
    }
  }

  ///执行对应的命令行
  void performCommand(BuildContext context, PrinterInfo printerInfo) {
    switch (this) {
      case FuncEnum.printReceipt:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return ReceiptTempWidget(printerInfo);
        }));
        break;
      case FuncEnum.printLabel:
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return LabelTempWidget(printerInfo);
        }));
        break;
    }
  }
}
