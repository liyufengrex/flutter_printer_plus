import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 小票样式 demo， （用于生成图片 - 打印）
class ReceiptStyleWidget extends StatefulWidget {
  const ReceiptStyleWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TempReceiptWidgetState();
}

class _TempReceiptWidgetState extends State<ReceiptStyleWidget> {
  @override
  Widget build(BuildContext context) {
    return _homeBody();
  }

  Widget _homeBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '测试打印小票',
          style: TextStyle(
            color: Colors.black,
            fontSize: 34.w,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 5.w,
        ),
        Text(
          '测试打印1',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.w,
          ),
        ),
        Text(
          '测试打印2',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.w,
          ),
        ),
        Text(
          '测试打印3',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.w,
          ),
        ),
        Text(
          '123456',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24.w,
          ),
        ),
      ],
    );
  }
}
