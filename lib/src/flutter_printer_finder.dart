import 'dart:async';
import 'dart:io';

import 'package:android_usb_printer/android_usb_printer.dart';
import 'package:flutter_printer_plus/src/tools/ping_discover.dart';
import 'package:r_get_ip/r_get_ip.dart';
import 'package:windows_usb_printer/windows_usb_printer.dart';

/// 提供打印机搜索能力
abstract class FlutterPrinterFinder {
  /// 搜索 已连接(Android)/已安装驱动的(Windows) USB 打印机
  static Future<List<UsbDeviceInfo>> queryUsbPrinter() async {
    if (Platform.isAndroid) {
      return AndroidUsbPrinterPlatform.instance.queryLocalUsbDevice();
    } else if (Platform.isWindows) {
      final result = <UsbDeviceInfo>[];
      final windowsPrinterList =
          await WindowsUsbPrinterProvider.queryLocalUsbDevice();
      if (windowsPrinterList != null && windowsPrinterList.isNotEmpty) {
        for (var element in windowsPrinterList) {
          result.add(UsbDeviceInfo(
            productName: element.pPrinterName,
            vId: 0,
            pId: 0,
            sId: element.pPrinterName,
          ));
        }
      }
      return result;
    } else {
      return Future(() => <UsbDeviceInfo>[]);
    }
  }

  /// 搜索可用的网络打印机设备
  static Future<List<String>> queryPrinterIp() async {
    final completer = Completer<List<String>>();
    final printerIps = <String>[];
    final localIp = await RGetIp.internalIP ?? '';
    final subnet = localIp.substring(0, localIp.lastIndexOf('.'));
    const port = 9100;
    final stream = PingDiscoverTool.discover(
      subnet,
      port,
      timeout: const Duration(milliseconds: 2000),
    );
    List<String> selectIpArr = <String>[];
    stream.listen((NetworkAddress addr) {
      if (addr.exists) {
        selectIpArr.add(addr.ip);
      }
    }).onDone(() {
      printerIps.addAll(selectIpArr);
      completer.complete(printerIps);
    });
    return completer.future;
  }
}
