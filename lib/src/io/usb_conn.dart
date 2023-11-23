import 'dart:io';

import 'package:android_usb_printer/android_usb_printer.dart';
import 'package:windows_usb_printer/windows_usb_printer.dart';
import 'base_conn.dart';

/// android 平台使用的 usb 传输
class UsbConn extends PrintBaseConn {
  final UsbDeviceInfo usbDevice;

  UsbConn(this.usbDevice);

  Future<int> writeMultiBytes(
    List<List<int>> data,
    int singleWriteLimit,
  ) async {
    int writeCount = 0;
    for (int index = 0; index < data.length; index++) {
      final itemBytes = data[index];
      final resultCount = await writeBytes(itemBytes, singleWriteLimit);
      if (resultCount <= 0) {
        throw Exception('Print transmission interrupted');
      }
      writeCount += resultCount;
    }
    return writeCount;
  }

  // 写入数据
  Future<int> writeBytes(
    List<int> data,
    int singleWriteLimit,
  ) async {
    if (Platform.isAndroid) {
      return writeBytesWithAndroid(
        data,
        singleWriteLimit,
      );
    } if (Platform.isWindows) {
      return writeBytesWithWindows(data);
    } else {
      throw Exception('The platform is not supported temporarily');
    }
  }

  // android 平台写入
  Future<int> writeBytesWithAndroid(
    List<int> bytes,
    int singleWriteLimit,
  ) {
    return AndroidUsbPrinterPlatform.instance.writeBytes(
      usbDevice,
      bytes,
      singleLimit: singleWriteLimit,
    );
  }

  // windows 平台写入
  Future<int> writeBytesWithWindows(List<int> bytes,) {
    return WindowsUsbPrinterProvider.usbWrite(usbDevice.productName, bytes);
  }

}
