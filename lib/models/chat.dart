// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:slaap/models/lang.dart';
import 'package:slaap/utils/helpers.dart';

class Chat {
  final String id;
  final Map<String, bool> accounts;
  final Map<String, Lang> accountLangs;
  final bool isGroup;
  Chat({
    required this.id,
    required this.accounts,
    required this.accountLangs,
    this.isGroup = false,
  });

  Chat copyWith({
    String? id,
    Map<String, bool>? accounts,
    Map<String, Lang>? accountLangs,
    bool? isGroup,
  }) {
    return Chat(
      id: id ?? this.id,
      accounts: accounts ?? this.accounts,
      accountLangs: accountLangs ?? this.accountLangs,
      isGroup: isGroup ?? this.isGroup,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'accounts': accounts,
      'accountLangs': accountLangs.map(mapValue((value) => value.toMap())),
      'isGroup': isGroup,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as String,
      accounts:
          Map<String, bool>.from((map['accounts'] as Map<String, dynamic>)),
      accountLangs: Map<String, Lang>.from(
        (map['accountLangs'] as Map<String, dynamic>)
            .map(mapValue((value) => Lang.fromMap(value))),
      ),
      isGroup: map['isGroup'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Chat(id: $id, accounts: $accounts, accountLangs: $accountLangs, isGroup: $isGroup)';
  }

  @override
  bool operator ==(covariant Chat other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        mapEquals(other.accounts, accounts) &&
        mapEquals(other.accountLangs, accountLangs) &&
        other.isGroup == isGroup;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        accounts.hashCode ^
        accountLangs.hashCode ^
        isGroup.hashCode;
  }
}
