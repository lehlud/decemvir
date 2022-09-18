import 'dart:convert';
import 'dart:io';

import 'package:decemvir/api/storage.dart';
import 'package:decemvir/api/struct/database.dart';
import 'package:decemvir/api/utils.dart';
import 'package:flutter/services.dart';

class DataRoot {
  final String _name;
  final Map<String, dynamic> _json;
  DataRoot(this._name, this._json);

  List<Database> get directDatabases {
    return (_json['databases'] as List? ?? []).map((json) {
      return Database(null, this, json);
    }).toList();
  }

  List<Database> get allDatabases {
    final result = directDatabases.toSet();
    for (final database in directDatabases) {
      result.addAll(database.allDatabases);
    }

    return result.toList();
  }

  void createDatabase(String name) {
    final dbs = (_json['databases'] as List? ?? []);
    dbs.add({
      'id': generateRandomId(),
      'data': {'name': name}
    });

    _json['databases'] = dbs;
    save();
  }

  Future<void> save() async {
    final bytes = utf8.encode(jsonEncode(_json));
    final gzip = GZipCodec().encoder.convert(bytes);
    await MyStorage.set('$_name.dvir', Uint8List.fromList(gzip));
  }

  static Future<DataRoot> load([String name = 'db']) async {
    try {
      final gzip = (await MyStorage.get('$name.dvir')).asBytes.toList();
      final bytes = GZipCodec().decoder.convert(gzip);
      final json = jsonDecode(utf8.decode(bytes));
      return DataRoot(name, json);
    } catch (_) {
      return DataRoot(name, {});
    }
  }
}
