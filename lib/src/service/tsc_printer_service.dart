import 'dart:typed_data';
import 'package:tsc_utils/tsc_utils.dart';
import 'package:image/image.dart' as img;

import '../tools/log_tool.dart';
import 'base_printer_service.dart';
import 'isolate/isolate_balance.dart';

class TscPrinterService extends BasePrinterService {
  final Uint8List imgData;
  final int? argbWidthPx; // imgData 类型为 ARGB Uint8List 时，需要传入 图像的像素宽度
  final int? argbHeightPx; // imgData 类型为 ARGB Uint8List 时，需要传入 图像的像素高度

  TscPrinterService(
    this.imgData, {
    this.argbWidthPx,
    this.argbHeightPx,
  });

  Future decodeImageFunction() {
    if (argbHeightPx != null && argbWidthPx != null) {
      return ISOManager.loadBalanceFuture<img.Image, List<dynamic>>(
        ImageDecodeTool.createImageWithARGB0,
        [
          imgData,
          argbWidthPx,
          argbHeightPx,
        ],
      );
    } else {
      return ISOManager.loadBalanceFuture<img.Image, Uint8List>(
        ImageDecodeTool.createImageWithUni8List,
        imgData,
      );
    }
  }

  @override
  Future<List<List<int>>> getBytes() async {
    final cmd = <List<int>>[];
    final image = await decodeImageFunction();
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
