// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:slaap/models/lang.dart';
import 'package:slaap/utils/helpers.dart';

class Chat {
  final String id;
  final ChatType type;
  final Map<String, bool> accounts;
  final Map<String, Lang> langs;
  Chat({
    required this.id,
    required this.type,
    required this.accounts,
    required this.langs,
  });

  Chat copyWith({
    String? id,
    ChatType? type,
    Map<String, bool>? accounts,
    Map<String, Lang>? langs,
  }) {
    return Chat(
      id: id ?? this.id,
      type: type ?? this.type,
      accounts: accounts ?? this.accounts,
      langs: langs ?? this.langs,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type.name,
      'accounts': accounts,
      'langs': langs.map(mapValue((value) => value.toMap())),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as String,
      type: ChatType.fromJson(map['type']),
      accounts:
          Map<String, bool>.from((map['accounts'] as Map<String, dynamic>)),
      langs: Map<String, Lang>.from(
        (map['langs'] as Map<String, dynamic>)
            .map(mapValue((value) => Lang.fromMap(value))),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chat(id: $id, type: $type, accounts: $accounts, langs: $langs)';
  }

  @override
  bool operator ==(covariant Chat other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.type == type &&
        mapEquals(other.accounts, accounts) &&
        mapEquals(other.langs, langs);
  }

  @override
  int get hashCode {
    return id.hashCode ^ type.hashCode ^ accounts.hashCode ^ langs.hashCode;
  }
}

enum ChatType {
  dm,
  self,
  group;

  String toJson() => json.encode(name);

  factory ChatType.fromJson(String source) =>
      values.firstWhere((element) => element.name == source);
}
