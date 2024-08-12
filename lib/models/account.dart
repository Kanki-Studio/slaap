// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:slaap/models/lang.dart';

class Account {
  final String id;
  final String email;
  final String name;
  final Lang lang;
  final String? photoURL;
  Account({
    required this.id,
    required this.email,
    required this.name,
    required this.lang,
    this.photoURL,
  });

  Account copyWith({
    String? id,
    String? email,
    String? name,
    Lang? lang,
    String? photoURL,
  }) {
    return Account(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      lang: lang ?? this.lang,
      photoURL: photoURL ?? this.photoURL,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'name': name,
      'lang': lang.toMap(),
      'photoURL': photoURL,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    return Account(
      id: map['id'] as String,
      email: map['email'] as String,
      name: map['name'] as String,
      lang: Lang.fromMap(map['lang'] as Map<String, dynamic>),
      photoURL: map['photoURL'] != null ? map['photoURL'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Account(id: $id, email: $email, name: $name, lang: $lang, photoURL: $photoURL)';
  }

  @override
  bool operator ==(covariant Account other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.email == email &&
        other.name == name &&
        other.lang == lang &&
        other.photoURL == photoURL;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        email.hashCode ^
        name.hashCode ^
        lang.hashCode ^
        photoURL.hashCode;
  }
}
