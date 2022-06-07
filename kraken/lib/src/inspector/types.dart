
import 'package:meta/meta.dart';
abstract class JSONEncodable {
  Map toJson();
}

@immutable
class InspectorEvent implements JSONEncodable {
  final String method;
  final JSONEncodable params;
  InspectorEvent(this.method, this.params) : assert(method != null);

  Map toJson() {
    return {
      'method': method,
      'params': params?.toJson() ?? {},
    };
  }
}

class JSONEncodableMap extends JSONEncodable {
  Map map;
  JSONEncodableMap(this.map);

  Map toJson() => map;
}

enum InspectorLogEntryLevel { verbose, info, warning, error }

class InspectorLogEntry implements JSONEncodable {
  final String text;
  final InspectorLogEntryLevel level;
  final String source;
  final String url;
  final int lineNumber;
  final InspectorRuntimeStackTrace stackTrace;
  InspectorLogEntry(
      {this.level,
      this.text,
      this.source,
      this.url,
      this.lineNumber,
      this.stackTrace});

  Map toJson() {
    return {
      'text': text,
      'source': source,
      'level': level.toString().split('.')[1],
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'url': url,
      'lineNumber': lineNumber,
      'stackTrace': stackTrace?.toJson(),
    };
  }
}

class InspectorRuntimeStackTrace implements JSONEncodable {
  final String description;
  final InspectorRuntimeStackTrace parent;
  final List<InspectorRuntimeCallFrame> callFrames;
  final String parentId;
  InspectorRuntimeStackTrace(this.description, this.parent,
      {this.callFrames = const [], this.parentId = ''});

  Map toJson() {
    return {
      'description': description,
      'parent': parent,
      'callFrames': callFrames?.map((e) => e.toJson()),
      'parentId': parentId.isNotEmpty ? {'id': parentId} : null
    };
  }
}

class InspectorRuntimeCallFrame implements JSONEncodable {
  final String functionName;
  final String url;
  final int lineNumber;
  final int columnNumber;
  final String scriptId;
  InspectorRuntimeCallFrame(this.functionName,
      {this.url = '',
      this.lineNumber = 0,
      this.columnNumber = 0,
      this.scriptId = ''});

  Map toJson() {
    return {
      'functionName': functionName,
      'url': url,
      'lineNumber': lineNumber,
      'columnNumber': columnNumber,
      'scriptId': scriptId,
    };
  }
}
