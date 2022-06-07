import 'package:kraken/src/module/module_manager.dart';
import 'package:kraken/kraken.dart';
export 'package:kraken/src/inspector/types.dart';
class ConsoleModule extends BaseModule {
  @override
  String get name => 'Console';
  ConsoleModule(ModuleManager moduleManager) : super(moduleManager);
 
  @override
  void dispose() {}

  @override
  String invoke(String method, dynamic params, callback) {
    print('【Console】 $method ${params}');
    InspectorLogEntryLevel level = InspectorLogEntryLevel.verbose;
    switch(method) {
      case 'debug':
        level = InspectorLogEntryLevel.info;
        break;
      case 'info':
        level = InspectorLogEntryLevel.info;
        break;
      case 'warn':
        level = InspectorLogEntryLevel.warning;
        break;
      case 'error':
        level = InspectorLogEntryLevel.error;
        break;
    }
    final entry =
        InspectorLogEntry(level: level, text: params as String);
    moduleManager.controller.view.inspector?.onLogEntryAdded(entry);
    callback();
    return '';
  }
}