import 'dart:async';

import 'dart:convert';

abstract class BaseBridgeMethod {
  final String methodName;
  Future<dynamic> handleJavascriptMethod(dynamic data);
  BaseBridgeMethod(this.methodName);

  dynamic getSuccessResult(dynamic result) {
    return jsonEncode({
      "code": 0,
      "result": result,
    });
  }

  dynamic getErrorResult(int code, String message) {
    return jsonEncode({
      "code": code ?? -1,
      "msg": message ?? 'error',
    });
  }
}
