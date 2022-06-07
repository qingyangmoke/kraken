import 'dart:async';
import 'base.dart';
import 'package:flutter/services.dart';

class NativeBridgeMethod extends BaseBridgeMethod {
  final MethodChannel nativeChannel;
  NativeBridgeMethod(String name, this.nativeChannel) : super(name);

  @override
  Future<dynamic> handleJavascriptMethod(dynamic arguments) {
    return nativeChannel.invokeMethod(methodName, arguments);
  }
}
