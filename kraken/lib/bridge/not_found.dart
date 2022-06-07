import 'dart:async';
import 'base.dart';

class NotFoundBridgeMethod extends BaseBridgeMethod {
  NotFoundBridgeMethod() : super('notfound');
  @override
  Future<dynamic> handleJavascriptMethod(dynamic arguments) {
    Completer completer = Completer<String>();
    completer.complete(getErrorResult(-1, 'method not found'));
    return completer.future;
  }
}
