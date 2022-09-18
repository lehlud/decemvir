import 'package:decemvir/api/struct/document.dart';
import 'package:decemvir/api/struct/object.dart';
import 'package:decemvir/api/struct/type.dart';

class Database extends ApiObject {
  final Document? _document;
  Database(this._document, super.root, super.json);

  Document? get parent => _document;

  String get name => data['name'];

  Map<String, Type> get props {
    return (data['props'] ?? {}).map((key, value) {
      return MapEntry(key, Type.fromJson(value));
    });
  }

  List<Document> get documents {
    return (data['documents'] as List? ?? []).map((json) {
      return Document(this, root, json);
    }).toList();
  }

  List<Database> get allDatabases {
    final result = <Database>{};
    for (final document in documents) {
      result.addAll(document.allDatabases);
    }

    return result.toList();
  }
}
