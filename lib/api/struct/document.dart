import 'package:decemvir/api/struct/database.dart';
import 'package:decemvir/api/struct/object.dart';

class Document extends ApiObject {
  final Database _database;
  Document(this._database, super.root, super.json);

  Database get parent => _database;

  String get name => data['name'];
  String get markdown => data['markdown'] ?? '';

  List<Database> get directDatabases {
    return (data['databases'] as List? ?? []).map((json) {
      return Database(this, root, json);
    }).toList();
  }

  List<Database> get allDatabases {
    final result = directDatabases.toSet();

    for (final database in directDatabases) {
      result.addAll(database.allDatabases);
    }

    return result.toList();
  }

  void updateDatabase(String id, Database database) {
    final dbs = data['databases'] as List? ?? [];

    try {
      final dbObject = dbs.firstWhere((db) => db['id'] == id);
      dbObject['data'] = database.data;
    } catch (_) {}
  }

  @override
  void save() {
    parent.updateDocument(id, this);
    parent.save();
  }
}
