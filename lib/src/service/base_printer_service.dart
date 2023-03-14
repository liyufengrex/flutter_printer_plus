import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../tools/log_tool.dart';

abstract class BasePrinterService {
  Future<List<List<int>>> getBytes();
}

abstract class ImageDecodeTool {
  static Future<img.Image> cropImage(
    Uint8List imgData, {
    int requireCutWidth = 0,
  }) async {
    final img.Image origin = img.decodeImage(imgData)!;
    int targetWidth = origin.width;
    int targetHeight = origin.height;
    if (requireCutWidth < origin.width && requireCutWidth > 0) {
      targetWidth = requireCutWidth;
    }
    //切白邊
    final img.Image crop = img.copyCrop(
      origin,
      0,
      0,
      targetWidth,
      targetHeight,
    );
    return crop;
  }

  static Future<img.Image> resizeImage(
    img.Image image, {
    required int targetWidth,
    required int targetHeight,
  }) async {
    return img.copyResize(
      image,
      width: targetWidth,
      height: targetHeight,
    );
  }

  static Future<List<img.Image>> decodeImage0(List<dynamic> params) async {
    Uint8List imgData = params[0];
    int limitSize = params[1];
    return decodeImage(
      imgData,
      imgSizeLimit: limitSize,
    );
  }

  static Future<List<img.Image>> decodeImage(
    Uint8List imgData, {
    int imgSizeLimit = 550 * 1000,
  }) async {
    final img.Image crop = await cropImage(
      imgData,
    );
    final cropWidth = crop.width;
    img.Image targetImg = crop;
    if (cropWidth % 8 != 0) {
      targetImg = await resizeImage(
        crop,
        targetWidth: cropWidth ~/ 8 * 8,
        targetHeight: crop.height,
      );
    }
    final targetWidth = targetImg.width;
    final targetHeight = targetImg.height;
    final result = <img.Image>[];
    if (targetWidth * targetHeight > imgSizeLimit) {
      LogTool.log('esc 长图开启切割');
      int splitItemHeight = imgSizeLimit ~/ targetWidth;

      int splitCount = targetHeight ~/ splitItemHeight;

      int lastItemHeight = targetHeight % splitItemHeight;

      for (int index = 0; index < splitCount; index++) {
        final splitItem = img.copyCrop(
          targetImg,
          0,
          splitItemHeight * index,
          targetWidth,
          splitItemHeight,
        );
        result.add(splitItem);
      }
      LogTool.log(
          '切图 * $splitCount 份 width（$targetWidth） height（$splitItemHeight）');

      if (lastItemHeight > 0) {
        final lastItem = img.copyCrop(
          crop,
          0,
          splitItemHeight * splitCount,
          targetWidth,
          lastItemHeight,
        );
        result.add(lastItem);
        LogTool.log('切图 * 1 份 width（$targetWidth） height（$lastItemHeight）');
      }
    } else {
      result.add(crop);
      LogTool.log('esc 无需切割 width（$targetWidth） height（$targetHeight）');
    }
    return result;
  }
}
