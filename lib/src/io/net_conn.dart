import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'base_conn.dart';

class NetConn extends PrintBaseConn {
  final String address;
  Socket? _socket;
  bool _isConnect = false;
  int? _sourcePort;

  NetConn(this.address);

  bool get connected => _isConnect;

  StreamSubscription? _socketSubscription;

  Future<bool> reset() async {
    try {
      await disconnect();
      await connect(throwError: true);
      return _isConnect;
    } catch (e) {
      rethrow;
    }
  }

  void _close() {
    _isConnect = false;
    _socket = null;
    try {
      _socketSubscription?.cancel();
    } catch (e) {
      //暂无处理
    }
    _socketSubscription = null;
  }

  Future<bool> connect({
    int port = 9100,
    Duration? timeout = const Duration(seconds: 5),
    bool canRetry = true,
    bool throwError = false,
  }) async {
    if (_socket != null && _isConnect) {
      return true;
    }
    _close();
    try {
      _socket = await Socket.connect(
        address,
        port,
        sourcePort: _sourcePort ?? 0,
        timeout: timeout,
      );
      _isConnect = true;
      _sourcePort = _socket?.port;
      _socketSubscription = _socket?.listen(
            (event) {
          //暂无处理
        },
        onDone: () {
          _close();
        },
        onError: (e) {
          _close();
        },
      );
    } catch (e) {
      _close();
      if (canRetry) {
        final isInUseException =
        e.toString().contains('Address already in use');
        if (isInUseException) {
          //需要使用新的 sourcePort
          _sourcePort = null;
        }
        return connect(
          port: port,
          timeout: timeout,
          canRetry: false,
          throwError: throwError,
        );
      } else {
        if (throwError) {
          rethrow;
        }
      }
    }
    return _isConnect;
  }

  Future<bool> disconnect() async {
    if (_socket == null || !_isConnect) {
      return true;
    }
    void onDisCon(
        Completer completer,
        bool result,
        ) {
      if (!completer.isCompleted) {
        _close();
        _sourcePort = null;
        completer.complete(result);
      }
    }

    final completer = Completer<bool>();
    try {
      _socket?.done.then(
            (value) {
          onDisCon(completer, true);
        },
      );
      await _socket?.flush();
      await _socket?.close();
      Future.delayed(
        const Duration(seconds: 2),
            () {
          onDisCon(completer, true);
        },
      );
    } catch (e) {
      log(
        'netConn disconnect error : ${e.toString()}',
      );
      onDisCon(completer, false);
    }
    return completer.future;
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
