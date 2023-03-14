import 'dart:developer';
import 'dart:io';

import 'base_conn.dart';

class NetConn extends PrintBaseConn {
  final String address;
  Socket? _socket;
  bool _isConnect = false;

  NetConn(this.address);

  bool get connected => _isConnect;

  // 断开重连
  Future<bool> reset() async {
    try {
      await disconnect();
      await connect(throwError: true);
      return _isConnect;
    } catch (e) {
      rethrow;
    }
  }

  // 连接
  Future<bool> connect({
    int port = 9100,
    Duration? timeout = const Duration(seconds: 5),
    bool throwError = false,
  }) async {
    if (_socket != null && _isConnect) {
      return true;
    }
    try {
      _socket = await Socket.connect(
        address,
        port,
        timeout: timeout,
      );
      _isConnect = true;
    } catch (e) {
      _isConnect = false;
      if (throwError) {
        rethrow;
      }
    }
    return _isConnect;
  }

  // 断开连接
  Future<bool> disconnect() async {
    try {
      await _socket?.flush();
      await _socket?.close();
    } catch (e) {
      log('netConn disconnect error : ${e.toString()}');
    }
    _isConnect = false;
    return !_isConnect;
  }

  Future<int> writeMultiBytes(
    List<List<int>> data, {
    bool isDisconnect = true,
  }) async {
    int writeCount = 0;
    for (int index = 0; index < data.length; index++) {
      final itemBytes = data[index];
      final resultCount = await writeBytes(
        itemBytes,
        isDisconnect: isDisconnect,
      );
      if (resultCount <= 0) {
        throw Exception('Print transmission interrupted');
      }
      writeCount += resultCount;
    }
    return writeCount;
  }

  // 写入数据
  Future<int> writeBytes(
    List<int> data, {
    bool isDisconnect = true,
  }) async {
    try {
      if (!_isConnect) {
        await connect();
      }
      if (!_isConnect) {
        throw Exception('printer connect error ( ip: $address)');
      }
      _socket?.add(data);
      if (isDisconnect) {
        await disconnect();
      }
      return data.length;
    } catch (e) {
      _isConnect = false;
      return -1;
    }
  }
}
