import 'dart:typed_data';
import 'package:tsc_utils/tsc_utils.dart';
import 'package:image/image.dart' as img;

import '../tools/log_tool.dart';
import 'base_printer_service.dart';
import 'isolate/isolate_balance.dart';

class TscPrinterService extends BasePrinterService {
  final Uint8List imgData;

  TscPrinterService(
    this.imgData,
  );

  @override
  Future<List<List<int>>> getBytes() async {
    final cmd = <List<int>>[];
    final image = await ISOManager.loadBalanceFuture<img.Image, Uint8List>(
      ImageDecodeTool.cropImage,
      imgData,
    );
    final startTime = DateTime.now();
    final imageBytes = await ISOManager.loadBalanceFuture<List<int>, img.Image>(
      decodeBytes,
      image,
    );
    final endTime = DateTime.now();
    final diffTime = endTime.difference(startTime).inMilliseconds;
    LogTool.log(
      '图像转打印字节耗时：$diffTime 毫秒，width（${image.width}）height（${image.height}）',
    );
    cmd.add(imageBytes);
    return cmd;
  }

  static Future<List<int>> decodeBytes(img.Image image) async {
    final origin = image;
    final width = origin.width;
    final height = origin.height;
    img.Image targetImg = origin;
    if (width % 8 != 0) {
      targetImg = await ImageDecodeTool.resizeImage(
        origin,
        targetWidth: width ~/ 8 * 8,
        targetHeight: height,
      );
    }
    final targetWidth = targetImg.width;
    final targetHeight = targetImg.height;
    Generator generator = Generator();
    generator.addSize(width: targetWidth ~/ 8, height: targetHeight ~/ 8);
    generator.addGap(1);
    generator.addDensity(Density.density15);
    generator.addDirection(Direction.backWord);
    generator.addReference(2, 2);
    generator.addCls();
    generator.addImage(
      targetImg,
      needGrayscale: true,
    );
    generator.addPrint(1);
    return generator.byte;
  }
}
