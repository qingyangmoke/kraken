import 'dart:collection';

import 'package:kraken/src/module/module_manager.dart';
import 'package:kraken/kraken.dart';

class ResourcesModule extends BaseModule {
  final SplayTreeMap<String, int> _jsSubModuleMap = SplayTreeMap();
  @override
  String get name => 'Resources';
  ResourcesModule(ModuleManager moduleManager) : super(moduleManager);

  @override
  void dispose() {}

  @override
  String invoke(String method, dynamic params, callback) {
    switch (method) {
      case 'loadModule':
        print('loadModule ${params}');
        onLoadModule(params as String)
            .then((dynamic value) => {callback(data: value)});
        break;
      default:
        callback(errmsg: 'not supported');
        break;
    }

    return '';
  }

  Future<bool> onLoadModule(moduleURL) async {
    bool succes = true;
    if (!_jsSubModuleMap.containsKey(moduleURL)) {
      try {
        final bundle = await KrakenBundle.getBundle(moduleURL);
        await bundle.eval(moduleManager.controller.view.contextId);
        _jsSubModuleMap[moduleURL] = 1;
      } catch (e, stack) {
        print(e);
        print(stack);
        succes = false;
      }
    }
    return succes;
  }
}
