import 'package:decemvir/api/struct/data_root.dart';
import 'package:decemvir/api/utils.dart';

class ApiObject {
  final DataRoot _root;
  final Map<String, dynamic> _json;
  ApiObject(this._root, this._json);

  DataRoot get root => _root;

  String get id => _json['id'];

  DateTime get creationDate {
    return dateFromMillis(_json['creationDate']);
  }

  DateTime get lastUpdateDate {
    final int? millis = _json['lastUpdateDate'];
    return millis != null ? dateFromMillis(millis) : creationDate;
  }

  DateTime get lastOpenDate {
    final int? millis = _json['lastOpenDate'];
    return millis != null ? dateFromMillis(millis) : lastUpdateDate;
  }

  Map<String, dynamic> get data => _json['data'] ?? {};
}
