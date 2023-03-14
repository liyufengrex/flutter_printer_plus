// ignore: depend_on_referenced_packages
import 'package:android_usb_printer/android_usb_printer.dart';

class PrinterInfo {
  final String? ip;
  final UsbDeviceInfo? usbDevice;

  PrinterInfo({
    this.ip,
    this.usbDevice,
  });

  String get name {
    if (ip != null) {
      return '网口打印机: $ip';
    } else {
      return 'usb打印机：${usbDevice!.productName}-${usbDevice!.vId}-${usbDevice!.pId}-${usbDevice!.sId}';
    }
  }

  bool get isNetPrinter => ip != null;

  bool get isUsbPrinter => usbDevice != null;

  factory PrinterInfo.fromUsbDevice(UsbDeviceInfo usbDeviceInfo) {
    return PrinterInfo(usbDevice: usbDeviceInfo);
  }

  factory PrinterInfo.fromIp(String ip) {
    return PrinterInfo(ip: ip);
  }
}
