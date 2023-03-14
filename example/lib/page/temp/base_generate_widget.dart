import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class BaseGenerateWidget extends StatefulWidget {
  Widget child();

  void doPrint();

  const BaseGenerateWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BaseGenerateWidgetState();
}

class _BaseGenerateWidgetState extends State<BaseGenerateWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('票据样式'),
      ),
      backgroundColor: Colors.black12,
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {
                      widget.doPrint();
                    },
                    child: const Text(
                      "点击生成打印任务",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.w),
              widget.child(),
            ],
          ),
        ),
      ),
    );
  }
}
