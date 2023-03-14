import 'dart:developer' as dev;

abstract class LogTool {
  static void log(String message) {
    dev.log("rex: pdPrinter - $message");
  }
}
