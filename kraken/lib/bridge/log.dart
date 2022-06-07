import 'dart:async';
import 'base.dart';
import 'package:kraken/kraken.dart';

class LogBridgeMethod extends BaseBridgeMethod {
  LogBridgeMethod() : super('core.log');
  @override
  Future<dynamic> handleJavascriptMethod(dynamic arguments) {
    Completer completer = Completer<String>();
    var message = arguments[1]['msg'];
    var contextId = int.parse(arguments[1]['contextId']);
    final controller = KrakenController.getControllerOfJSContextId(contextId);
    final entry =
        InspectorLogEntry(level: InspectorLogEntryLevel.info, text: message);
    controller.view.inspector.onLogEntryAdded(entry);
    print('core.log: ' + message);
    // print('$start      test   $end');
    completer.complete(getSuccessResult(''));
    return completer.future;
  }
}