import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:kraken/kraken.dart';
import 'base.dart';
import 'not_found.dart';
import 'native.dart';
import 'media_query.dart';
import 'log.dart';

class BridgeMethodManagerError extends Error {
  /** Message describing the assertion error. */
  final String message;

  BridgeMethodManagerError(this.message);

  String toString() {
    if (message != null) {
      return "BridgeMethodManager Error: ${message}";
    }
    return "BridgeMethodManagerError";
  }
}

class BridgeMethodManager {
  static BridgeMethodManager _singleton = BridgeMethodManager();
  static BridgeMethodManager get instance {
    return _singleton;
  }

  final Map<String, BaseBridgeMethod> _bridgeMaps =
      Map<String, BaseBridgeMethod>();
  bool _inited = false;
  final BaseBridgeMethod _notFoundBridge = NotFoundBridgeMethod();

  // 用来实现dart 和 native的通信 https://flutter.dev/docs/development/platform-integration/platform-channels
  final MethodChannel nativeChannel =
      MethodChannel('kraken_js_dart_native_channel');

  // 用来实现js 和 dart的通信 https://openkraken.com/guide/advanced/communicate-with-native
  // KrakenJavaScriptChannel _javaScriptChannel;
  // KrakenJavaScriptChannel get javaScriptChannel {
  //   return _javaScriptChannel;
  // }

  BuildContext _context;

  BuildContext get context => _context;
 
  void bootstrap(BuildContext context) {
    if (_inited) {
      print('bridge mananger already bootstrap');
      return;
    }
    _inited = true;
    _context = context;
    nativeChannel.setMethodCallHandler((MethodCall call) async {
      try {
        dynamic arguments = json.decode(call.arguments as String);
        final contextId = int.parse(arguments["contextId"] ?? '-1');
        print(
            'kraken_js_dart_native_channel method=${call.method}, contextId=${contextId}');
        return invokeJavascriptMethod(contextId, call.method, arguments);
      } catch (e) {
        print('kraken_js_dart_native_channel method=${call.method}, error');
      }
    });

    // registerBridgeMethod(LogBridgeMethod());
    // registerBridgeMethod(MediaQueryBridgeMethod(context));
    registerBridgeMethod(NativeBridgeMethod('alert', nativeChannel));
  }

  KrakenJavaScriptChannel createJavaScriptChannel() {
    final channel = KrakenJavaScriptChannel();
    channel.onMethodCall = (String method, dynamic arguments) async {
      return handleJavascriptMethod(method, arguments);
    };
    return channel;
  }

  void registerBridgeMethod(BaseBridgeMethod bridge) {
    _bridgeMaps[bridge.methodName] = bridge;
  }

  void invokeJavascriptMethod(int contextId, String method, dynamic arguments) {
    final keys = KrakenController.getControllerMap().keys.join(',');
    print('invokeJavascriptMethod method=${method}, keys=${keys}');
    KrakenController.getControllerMap().values.forEach((controller) {
      if (-1 == contextId || controller.view.contextId == contextId) {
        (controller.methodChannel as KrakenJavaScriptChannel)
            .invokeMethod(method, arguments);
      }
    });
  }

  Future<dynamic> handleJavascriptMethod(String method, dynamic arguments) {
    if (_bridgeMaps.containsKey(method)) {
      return _bridgeMaps[method].handleJavascriptMethod(arguments);
    }
    return _notFoundBridge.handleJavascriptMethod(arguments);
  }
}
