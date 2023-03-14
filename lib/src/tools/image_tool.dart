import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import 'log_tool.dart';

abstract class ImageTool {

  static Future<String> saveImage(Uint8List byteData) async {
    final directory = (await getTemporaryDirectory()).path;
    String path = '$directory/${DateTime.now().millisecondsSinceEpoch}.png';
    final imgFile = File(path);
    try {
      await imgFile.writeAsBytes(byteData);
      LogTool.log('saveSuccess：$path');
    } catch (_) {
      path = '';
    }
    return Future.value(path);
  }

  static Future<Uint8List> getImage(String imgPath) async {
    final imgFile = File(imgPath);
    final exist = await imgFile.exists();
    if (exist) {
      return imgFile.readAsBytes();
    } else {
      throw Exception('print imgFile is not exist');
    }
  }

  static Future<bool> deleteImage(String imgPath) async {
    bool result = false;
    final imgFile = File(imgPath);
    try {
      final exist = await imgFile.exists();
      if (exist) {
        await imgFile.delete();
        result = true;
      }
    } catch (e) {
      log('deleteImage error : ${e.toString()}');
    }
    return result;
  }
}
