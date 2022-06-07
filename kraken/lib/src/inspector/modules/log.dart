import 'package:kraken/inspector.dart';
import 'package:kraken/dom.dart';
import '../module.dart';

class InspectLogModule extends InspectModule {
  final Inspector inspector;
  ElementManager get elementManager => inspector.elementManager;
  InspectLogModule(this.inspector);

  @override
  String get name => 'Log';

  @override
  void receiveFromFrontend(int id, String method, Map<String, dynamic> params) {
  } 
}