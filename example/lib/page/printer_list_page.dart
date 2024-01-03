import 'dart:async';

import 'package:example/page/printer_content_page.dart';
import 'package:flutter/material.dart';

// ignore: depend_on_referenced_packages
import 'package:flutter_printer_plus/flutter_printer_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../module/printer_info.dart';
import '../widget/loading_widget.dart';

class PrinterListPage extends StatefulWidget {
  final SearchType searchType;

  const PrinterListPage(this.searchType, {Key? key}) : super(key: key);

  @override
  State<PrinterListPage> createState() => _PrinterListPageState();
}

class _PrinterListPageState extends State<PrinterListPage> {
  //查询本地USB打印机列表
  Future<List<PrinterInfo>> queryLocalUSBPrinter() {
    return FlutterPrinterFinder.queryUsbPrinter().then(
      (value) => value.map((e) => PrinterInfo.fromUsbDevice(e)).toList(),
    );
  }

  //搜索网络打印机
  Future<List<PrinterInfo>> queryNetPrinters() async {
    return FlutterPrinterFinder.queryPrinterIp().then(
      (value) => value.map((e) => PrinterInfo(ip: e)).toList(),
    );
  }

  Future<List<PrinterInfo>> queryPrinter() {
    if (widget.searchType == SearchType.usb) {
      return queryLocalUSBPrinter();
    } else {
      return queryNetPrinters();
    }
  }

  Widget _printerList(List<PrinterInfo> data) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: data.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 10);
        },
        itemBuilder: (BuildContext context, int index) {
          return _PrinterItemWidget(data[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('usb打印机列表'),
      ),
      body: FutureBuilder(
        future: queryPrinter(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              //查询出错了
              return const Center(
                child: Text('查询出错了'),
              );
            } else {
              return _printerList(snapshot.data);
            }
          } else {
            return const LoadingWidget();
          }
        },
      ),
    );
  }
}

class _PrinterItemWidget extends StatelessWidget {
  final PrinterInfo printerInfo;

  const _PrinterItemWidget(
    this.printerInfo, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(printerInfo.name)),
        TextButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PrinterContentWidget(printerInfo),
              ),
            );
          },
          child: const Text('点击使用'),
        ),
        const SizedBox(width: 100),
      ],
    );
  }
}

enum SearchType {
  net,
  usb,
}
