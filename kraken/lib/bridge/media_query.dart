import 'dart:async';
import 'base.dart';
import 'package:flutter/material.dart';

class MediaQueryBridgeMethod extends BaseBridgeMethod {
  final BuildContext context;
  MediaQueryBridgeMethod(this.context): super('media.query');
  @override
  Future<dynamic> handleJavascriptMethod(dynamic arguments) {
    Completer completer = Completer<String>();
    final MediaQueryData queryData = MediaQuery.of(context);
    final result = getSuccessResult({
      "orientation": queryData.orientation == Orientation.landscape
          ? 'landscape'
          : 'portrait',
      "platformBrightness":
          (queryData.platformBrightness == Brightness.dark) ? 'dark' : 'light',
      "devicePixelRatio": queryData.devicePixelRatio,
      "viewport": {
        'width': queryData.size.width,
        'height': queryData.size.height,
      },
      "safeArea": {
        'top': queryData.padding.top,
        'left': queryData.padding.left,
        'right': queryData.padding.right,
        'bottom': queryData.padding.bottom,
      },
    });
    completer.complete(result);
    return completer.future;
  }
}
