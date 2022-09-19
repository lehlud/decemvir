enum DBType {
  int,
  float,
  string,
  reference,
  date,
}

String dbTypeToString(DBType dbType) {
  switch (dbType) {
    case DBType.int:
      return 'Ganzzahl';
    case DBType.float:
      return 'Gleitkommazahl';
    case DBType.string:
      return 'Text';
    case DBType.reference:
      return 'Referenz';
    case DBType.date:
      return 'Datum';
  }
}

class Type {
  final bool isArray;
  final DBType type;
  final Map<String, dynamic> extra;

  Type({required this.type, this.isArray = false, this.extra = const {}});

  Map<String, dynamic> toJson() => {
        'isArray': isArray,
        'type': type.name,
        'extra': extra,
      };

  static Type fromJson(Map<String, dynamic> json) {
    return Type(
      type: DBType.values.byName(json['type']),
      isArray: json['isArray'],
      extra: json['extra'],
    );
  }
}
