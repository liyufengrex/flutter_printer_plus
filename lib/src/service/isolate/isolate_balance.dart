import 'dart:async';

import 'package:isolates/isolates.dart';

abstract class ISOManager {
  static int isoBalanceSize = 4;

  //LoadBalancer 4个单位的线程池
  static final Future<LoadBalancer> _loadBalancer =
      LoadBalancer.create(isoBalanceSize, IsolateRunner.spawn);

  //通过iso在新的线程中执行future内容体
  //R 为Future返回泛型，P 为方法入参泛型
  //function 必须为 static 方法
  static Future<R> loadBalanceFuture<R, P>(
    FutureOr<R> Function(P argument) function,
    P params,
  ) async {
    final lb = await _loadBalancer;
    return lb.run<R, P>(
      function,
      params,
    );
  }
}
