import 'dart:typed_data';

import 'package:esc_utils/src/commands.dart';
import 'package:flutter_printer_plus/flutter_printer_plus.dart';
import 'package:print_image_generate_tool/print_image_generate_tool.dart';
import 'image_tool.dart';

abstract class PrinterCommandTool {
  /// 生成打印圖片指令
  /// singleByteSizeLimit: 单次写入的长度限制
  static Future<List<List<int>>> generatePrintCmd({
    String? imgPath,
    Uint8List? imgData,
    required PrintTypeEnum printType,
    int imgSizeLimit = 550 * 1000,
  }) async {
    if (imgPath == null && imgData == null) {
      throw Exception(
          'generatePrintCmd error : imgPath and imgData cannot be empty at the same time');
    }
    Uint8List imgBytes;
    if (imgData != null) {
      imgBytes = imgData;
    } else {
      imgBytes = await ImageTool.getImage(imgPath!);
    }
    final cmdData = printType == PrintTypeEnum.receipt
        ? await ESCPrinterService(
      imgBytes,
      imgSizeLimit: imgSizeLimit,
    ).getBytes()
        : await TscPrinterService(
      imgBytes,
    ).getBytes();
    return cmdData;
  }

  /// 开启钱箱
  static List<int> generateEscCashDrawerCmd() {
    return cCashDrawerPin2.codeUnits;
  }
}
