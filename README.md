## flutter_printer_plus

flutter 端 【小票、标签】打印能力实现，支持 USB、网口，支持 Android、Windows 平台。(无厂家SDK嵌入)

> 结合 `print_image_generate_tool` 库可直接使用 flutter-widget 布局进行打印票据的样式开发，widget 怎么写，打印出来的样式就是什么。

##### 使用方式一：单独使用 `flutter_printer_plus` 方式
###### 1. 图像数据（Uint8List） 转 TSC 、ESC

###### 第一步：获取 Uint8List
+ 方案一：
  使用 widget 绘制打印样式，通过 [print_image_generate_tool](https://github.com/liyufengrex/print_image_generate_tool) 库，将 widget 转 Uint8List （参考使用方式二、或直接查看example中使用方式）
+ 方案二：
  通过 `path_provider` 库，将本地图片转 Uint8List

###### 第二步：转 TSC 、ESC
```dart
// 转 TSC 字节，imageBytes 类型为 Uint8List
var printData = await PrinterCommandTool.generatePrintCmd(
imgData: imageBytes,
printType: PrintTypeEnum.label,
);
```
```dart
// 转 ESC 字节，imageBytes 类型为 Uint8List
var printData = await PrinterCommandTool.generatePrintCmd(
imgData: imageBytes,
printType: PrintTypeEnum.receipt,
);
```
###### 2. 获取可用的打印机
+ 提供能力获取USB打印机列表
  搜索 已连接(Android)/已安装驱动的(Windows) USB 打印机
```
// 返回 Future<List<UsbDeviceInfo>>
FlutterPrinterFinder.queryUsbPrinter()  
```
+ 提供能力获取网络打印机列表
```
// 返回 Future<List<String>>
FlutterPrinterFinder.queryPrinterIp()  
```

######  3. 发送打印字节
USB 传输 （USB打印机）
```
// usb 打印
final conn = UsbConn(usbDevice);
conn.writeMultiBytes(printData, 1024 * 3);
```
IP 传输（网口打印机）
example 内提供获取局域网内可用打印机样例
```
// IP 打印
final conn = NetConn(ip);
conn.writeMultiBytes(printData);
```


###### 使用方式二：结合 `print_image_generate_tool` 的使用方式
直接将 flutter widget 转图像数据进行打印

第一步：使用 `PrintImageGenerateWidget ` 作为根节点
```dart

MaterialApp(
  onGenerateTitle: (context) => '打印测试',
  home: Scaffold(
    body: PrintImageGenerateWidget(
        contentBuilder: (context) {
          return const HomePage();
        },
        onPictureGenerated: _onPictureGenerated,
    ),
  ),
)
```
第二步：在 `_onPictureGenerated ` 方法中监听打印图层生成，并对接打印转码
```dart
//打印图层生成成功
Future<void> _onPictureGenerated(PicGenerateResult data) async {
  final printTask = data.taskItem;

  //指定的打印机
  final printerInfo = printTask.params as PrinterInfo;
  //打印票据类型（标签、小票）
  final printTypeEnum = printTask.printTypeEnum;

  final imageBytes = await 
  data.convertUint8List(imageByteFormat:ImageByteFormat.rawRgba);
  //也可以使用 ImageByteFormat.png
  final argbWidth = data.imageWidth;
  final argbHeight = data.imageHeight;
  if (imageBytes == null) {
    return;
  }
  //只要 imageBytes 不是使用 ImageByteFormat.rawRgba 格式转换的 unit8List
  //argbWidthPx、argbHeightPx 不要传值，默认为空就行
  var printData = await PrinterCommandTool.generatePrintCmd(
    imgData: imageBytes,
    printType: printTypeEnum,
    argbWidthPx: argbWidth,
    argbHeightPx: argbHeight,
  );
  if (printerInfo.isUsbPrinter) {
    // usb 打印
    final conn = UsbConn(printerInfo.usbDevice!);
    conn.writeMultiBytes(printData, 1024 * 3);
  } else if (printerInfo.isNetPrinter) {
    // 网络 打印
    final conn = NetConn(printerInfo.ip!);
    conn.writeMultiBytes(printData);
  }
}
```
第三步：发送一个任务将`flutter - widget`转打印图层，生成成功后会在上诉方法中获取到图层
```dart
///例如：将 ReceiptStyleWidget 转打印图层
void doPrint() {
  // 生成打印图层任务，指定任务类型为小票
  PictureGeneratorProvider.instance.addPicGeneratorTask(
    PicGenerateTask<PrinterInfo>(
      tempWidget: ReceiptConstrainedBox(ReceiptStyleWidget()) as ATempWidget, //ReceiptConstrainedBox 封装了小票宽高的限制条件
      printTypeEnum: PrintTypeEnum.receipt,
      params: printerInfo, //params是一个透传值，可以是任意类型，example中 params 携带的是打印机数据，在 _onPictureGenerated 中跟随生成的打印图层可被获取到
    ),
  );
}

/// 使用widget编写需要的小票样式，以下是样例
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
      ],
    );
  }
}
```


### 附注：
具体实现逻辑可参考 example ，建议使用者将上层进行封装（维护队列），打印图层生成成功后先将图像保存本地，等待上一个打印任务结束后再从队列中获取本地图片进行下一个打印任务，避免造成内存抖动。

#### 方案详细说明链接：[flutter：小票标签打印](https://juejin.cn/post/7210688688921395237)

附上使用该库实现的，小票、标签打印实际效果图：

![image.png](https://p6-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/6bd714e181724eb9a385b428333f4635~tplv-k3u1fbpfcp-watermark.image?)

![image.png](https://p1-juejin.byteimg.com/tos-cn-i-k3u1fbpfcp/b6254215af644854b073944733e3b7b0~tplv-k3u1fbpfcp-watermark.image?)
