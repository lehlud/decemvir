import 'package:decemvir/api/struct/document.dart';
import 'package:decemvir/api/struct/object.dart';
import 'package:decemvir/api/struct/type.dart';

class Database extends ApiObject {
  final Document? _document;
  Database(this._document, super.root, super.json);

  Document? get parent => _document;

  String get name => data['name'];

  Map<String, Type> get props {
    return (data['props'] as Map? ?? {}).map((key, value) {
      return MapEntry(key, Type.fromJson(value));
    }).cast();
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

  void addProp(String name, Type type) {
    final props = (data['props'] as Map? ?? {});
    props[name] = type.toJson();
    updateData('props', props);
  }

  void updateDocument(String id, Document document) {
    final docs = data['documents'] as List? ?? [];

    try {
      final docObject = docs.firstWhere((doc) => doc['id'] == id);
      docObject['data'] = document.data;
    } catch (_) {}
  }

  @override
  void save() {
    if (parent != null) {
      parent!.updateDatabase(id, this);
      parent!.save();
    } else {
      root.updateDatabase(id, this);
      root.save();
    }
  }
}
