import 'dart:typed_data';
import 'package:image/image.dart' as img;
import '../tools/log_tool.dart';

abstract class BasePrinterService {
  Future<List<List<int>>> getBytes();
}

abstract class ImageDecodeTool {

  static img.Image createImageWithUni8List(
    Uint8List imgData,
  ) {
    return img.decodeImage(imgData)!;
  }

  static img.Image createImageWithARGB(
    Uint8List imgData, {
    required int widthPx,
    required int heightPx,
  }) {
    return img.Image.fromBytes(
      widthPx,
      heightPx,
      imgData,
    );
  }

  static img.Image createImageWithARGB0(List<dynamic> params) {
    final imgData = params[0];
    final widthPx = params[1];
    final heightPx = params[2];
    return img.Image.fromBytes(
      widthPx,
      heightPx,
      imgData,
    );
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
    final img.Image image = createImageWithUni8List(imgData);
    return decodeImage(
      image,
      imgSizeLimit: limitSize,
    );
  }

  //这个效率更高，因为 image 库 解析 unit8List 非常慢
  static Future<List<img.Image>> decodeARGB0(List<dynamic> params) async {
    Uint8List argbData = params[0];
    int widthPx = params[1];
    int heightPx = params[2];
    int limitSize = params[3];
    final img.Image image = createImageWithARGB(
      argbData,
      widthPx: widthPx,
      heightPx: heightPx,
    );
    return decodeImage(
      image,
      imgSizeLimit: limitSize,
    );
  }

  static Future<List<img.Image>> decodeImage(
    img.Image originImage, {
    int imgSizeLimit = 550 * 1000,
  }) async {
    final imageWidth = originImage.width;
    img.Image targetImg = originImage;
    if (imageWidth % 8 != 0) {
      targetImg = await resizeImage(
        originImage,
        targetWidth: imageWidth ~/ 8 * 8,
        targetHeight: originImage.height,
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
          originImage,
          0,
          splitItemHeight * splitCount,
          targetWidth,
          lastItemHeight,
        );
        result.add(lastItem);
        LogTool.log('切图 * 1 份 width（$targetWidth） height（$lastItemHeight）');
      }
    } else {
      result.add(originImage);
      LogTool.log('esc 无需切割 width（$targetWidth） height（$targetHeight）');
    }
    return result;
  }
}
