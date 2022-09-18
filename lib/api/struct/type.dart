enum DBType {
  int,
  float,
  string,
  reference,
  date,
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
