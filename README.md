## flutter_printer_plus

flutter 端 【小票、标签】打印能力实现，直接将 flutter widget 转图像数据进行打印。

支持传输方式：usb连接、网络连接。

### 使用方式

#### 1. 图像数据（Uint8List） 转 TSC 、ESC

###### 第一步：获取 Uint8List
+ 方案一：通过 `print_image_generate_tool` 库，可将 widget 转 Uint8List
+ 方案二：通过 `path_provider` 库，将本地图片转 Uint8List

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
#### 2. 发送打印字节
###### USB 传输 （USB打印机）
通过 `android_usb_printer` 库，获取当前已连接的打印机列表，列表内每一个元素类型为 usbDevice。
```
// usb 打印
        final conn = UsbConn(usbDevice);
        conn.writeMultiBytes(printData, 1024 * 3);
```
###### IP 传输（网口打印机）
example 内提供获取局域网内可用打印机样例
```
// IP 打印
        final conn = NetConn(ip);
        conn.writeMultiBytes(printData);
```
#### 附注：
具体实现逻辑可参考 example ，建议使用者将上层进行封装（维护队列），打印图层生成成功后先将图像保存本地，等待上一个打印任务结束后再从队列中获取本地图片进行下一个打印任务，避免造成内存抖动。

#### ：[flutter：小票标签打印](https://juejin.cn/post/7210688688921395237)