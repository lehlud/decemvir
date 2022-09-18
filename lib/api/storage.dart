import 'dart:convert';
import 'dart:io';

import 'package:decemvir/api/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class MyStorageData {
  final Uint8List _data;

  MyStorageData(this._data);

  Uint8List get asBytes => _data;
  String get asString => utf8.decode(_data.toList());

  dynamic get asJson => jsonDecode(asString);
}

class MyStorage {
  // disallows instances to be created
  MyStorage._();

  /// returns the path to the application's documents directory
  static Future<String> get _localPath async {
    return (await getApplicationDocumentsDirectory()).path;
  }

  /// base64 encodes the [key]
  static String _keyFromString(String key) {
    return b64Encode(key);
  }

  /// throws an [Exception] if file does not exist
  static Future<MyStorageData> get(String key) async {
    key = _keyFromString(key);
    final file = File('${await _localPath}/$key');
    final bytes = await file.readAsBytes();
    return MyStorageData(bytes);
  }

  /// [data] is required to be of type [Uint8List] or [String]
  static Future<void> set(String key, dynamic data) async {
    assert(data is String || data is Uint8List);

    key = _keyFromString(key);

    late final Uint8List bytes;
    if (data is String) {
      bytes = Uint8List.fromList(utf8.encode(data));
    } else {
      bytes = data as Uint8List;
    }

    await File('${await _localPath}/$key').writeAsBytes(bytes);
  }

  static Future<List<String>> listFiles() async {
    final entries = Directory(await _localPath).listSync();

    final files = <String>[];
    for (final entry in entries) {
      try {
        if (entry is! File) continue;

        var filename = entry.uri.pathSegments.last;
        filename = b64Decode(filename);
        files.add(filename);
      } catch (_) {}
    }

    return files;
  }
}
