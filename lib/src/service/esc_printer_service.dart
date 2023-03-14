import 'dart:typed_data';
import 'package:esc_utils/esc_utils.dart';
import 'package:image/image.dart' as img;

import '../tools/log_tool.dart';
import 'base_printer_service.dart';
import 'isolate/isolate_balance.dart';

class ESCPrinterService extends BasePrinterService {
  final Uint8List imgData;
  final int imgSizeLimit; //长图需要进行切割

  ESCPrinterService(
    this.imgData, {
    required this.imgSizeLimit,
  });

  @override
  Future<List<List<int>>> getBytes() async {
    final cmd = <List<int>>[];
    final startTime = DateTime.now();
    final images =
        await ISOManager.loadBalanceFuture<List<img.Image>, List<dynamic>>(
      ImageDecodeTool.decodeImage0,
      [
        imgData,
        imgSizeLimit,
      ],
    );
    final endTime = DateTime.now();
    final diffTime = endTime.difference(startTime).inMilliseconds;
    LogTool.log(
      'image库解析图片耗时：$diffTime 毫秒',
    );
    final startTime1 = DateTime.now();
    for (int index = 0; index < images.length; index++) {
      final image = images[index];
      final imageBytes =
          await ISOManager.loadBalanceFuture<List<int>, img.Image>(
        decodeBytes,
        image,
      );
      List<int> bytes = [];
      bytes += imageBytes;
      if (index == images.length - 1) {
        Generator generator = Generator();
        bytes += generator.feed(2);
        bytes += generator.cut();
      }
      cmd.add(bytes);
    }
    final endTime1 = DateTime.now();
    final diffTime1 = endTime1.difference(startTime1).inMilliseconds;
    LogTool.log(
      '图像转打印字节耗时：$diffTime1 毫秒，切图总数：${images.length}',
    );
    return cmd;
  }

  static Future<List<int>> decodeBytes(img.Image image) async {
    Generator generator = Generator();
    List<int> bytes = [];
    final imageByte = generator.imageRaster(
      image,
      needGrayscale: false,
    );
    bytes += generator.reset();
    bytes += imageByte;
    return bytes;
  }
}
