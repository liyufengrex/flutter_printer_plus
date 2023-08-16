import 'dart:ui';

import 'package:example/module/printer_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_printer_plus/flutter_printer_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// ignore: depend_on_referenced_packages
import 'package:print_image_generate_tool/print_image_generate_tool.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  //打印图层生成成功
  Future<void> _onPictureGenerated(PicGenerateResult data) async {
    final printTask = data.taskItem;

    //指定的打印机
    final printerInfo = printTask.params as PrinterInfo;
    //打印票据类型（标签、小票）
    final printTypeEnum = printTask.printTypeEnum;

    final imageBytes = await data.convertUint8List(imageByteFormat:ImageByteFormat.rawRgba);
    //也可以使用 ImageByteFormat.png
    final argbWidth = data.imageWidth;
    final argbHeight = data.imageHeight;
    if (imageBytes == null) {
      return;
    }
    //只要 imageBytes 不是使用 ImageByteFormat.rawRgba 格式转换的 unit8List
    //argbWidthPx、argbHeightPx 不要传值，默认为空就行
    var printData = await PrinterCommandTool.generatePrintCmd(
      imgData: imageBytes,
      printType: printTypeEnum,
      argbWidthPx: argbWidth,
      argbHeightPx: argbHeight,
    );
    if (printerInfo.isUsbPrinter) {
      // usb 打印
      final conn = UsbConn(printerInfo.usbDevice!);
      conn.writeMultiBytes(printData, 1024 * 3);
    } else if (printerInfo.isNetPrinter) {
      // 网络 打印
      final conn = NetConn(printerInfo.ip!);
      conn.writeMultiBytes(printData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(960, 540),
      builder: (context, child) {
        return MaterialApp(
          onGenerateTitle: (context) => '打印测试',
          home: Scaffold(
            body: PrintImageGenerateWidget(
              contentBuilder: (context) {
                return const HomePage();
              },
              onPictureGenerated: _onPictureGenerated,
            ),
          ),
        );
      },
    );
  }
}
