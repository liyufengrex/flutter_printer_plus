import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';

// 标签样式 demo， （用于生成图片 - 打印）
class LabelStyleWidget extends StatelessWidget {
  const LabelStyleWidget({Key? key}) : super(key: key);

  Widget _title() {
    return Text(
      '588',
      style: TextStyle(fontSize: 62.w, fontWeight: FontWeight.w700, height: 1),
    );
  }

  Widget _subTitle() {
    return Row(
      verticalDirection: VerticalDirection.up,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '[外卖]',
          style:
              TextStyle(fontSize: 30.w, fontWeight: FontWeight.w700, height: 1),
        ),
        const Spacer(),
        Text(
          '30分钟内饮用口感更佳',
          style:
              TextStyle(fontSize: 14.w, fontWeight: FontWeight.w400, height: 1),
        ),
      ],
    );
  }

  Widget _productName() {
    return Text(
      '霸气手摇草莓',
      style: TextStyle(fontSize: 34.w, fontWeight: FontWeight.w700),
    );
  }

  Widget _productDes() {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        constraints: BoxConstraints(
          maxHeight: constraints.maxHeight,
        ),
        child: AutoSizeText.rich(
          TextSpan(
            text: '「去冰；500ml；七分糖；」',
            style: TextStyle(
              fontSize: 20.w,
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: '\n\n1/3杯',
                style: TextStyle(
                  fontSize: 18.w,
                  fontWeight: FontWeight.w400,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _tip() {
    return Text(
      '"嘿嘿嘿~\n①杯好茶①起喝',
      style: TextStyle(fontSize: 17.w, fontWeight: FontWeight.w400),
    );
  }

  Widget _storeInfo() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          '08-30 13:35',
          style: TextStyle(
            fontSize: 15.w,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text('杭州店',
            style: TextStyle(
              fontSize: 15.w,
              fontWeight: FontWeight.w400,
            )),
        Text('电话：123-1234-1234',
            style: TextStyle(
              fontSize: 15.w,
              fontWeight: FontWeight.w400,
            )),
      ],
    );
  }

  Widget _barCodeWidget() {
    return BarcodeWidget(
      barcode: Barcode.qrCode(
        errorCorrectLevel: BarcodeQRCorrectionLevel.low,
      ),
      data: 'https://pub.flutter-io.cn/packages/barcode_widget',
      width: 80,
      height: 80,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 28,
        top: 35,
        right: 75,
        bottom: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _title(),
          _subTitle(),
          const SizedBox(height: 16),
          const Divider(color: Color(0xff242524), height: 10, thickness: 3),
          const SizedBox(height: 8),
          _productName(),
          Expanded(
            child: _productDes(),
          ),
          _tip(),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.only(right: 98),
            child: Divider(color: Color(0xff242524), height: 10, thickness: 3),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 88,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(child: _storeInfo()),
                _barCodeWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
