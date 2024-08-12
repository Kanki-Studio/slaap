// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

enum SupportedLang {
  english("english", "English"),
  french("french", "French"),
  spanish("spanish", "Spanish");

  final String value;
  final String displayText;

  const SupportedLang(this.value, this.displayText);

  static String displayName(String lang) {
    return values.firstWhereOrNull((e) => e.value == lang)?.displayText ??
        "Unknown";
  }
}

class Lang {
  final String send;
  final String receive;
  Lang({
    required this.send,
    required this.receive,
  });

  Lang.all(String lang) : this(send: lang, receive: lang);

  Lang copyWith({
    String? send,
    String? receive,
  }) {
    return Lang(
      send: send ?? this.send,
      receive: receive ?? this.receive,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'send': send,
      'receive': receive,
    };
  }

  factory Lang.fromMap(Map<String, dynamic> map) {
    return Lang(
      send: map['send'] as String,
      receive: map['receive'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Lang.fromJson(String source) =>
      Lang.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Lang(send: $send, receive: $receive)';

  @override
  bool operator ==(covariant Lang other) {
    if (identical(this, other)) return true;

    return other.send == send && other.receive == receive;
  }

  @override
  int get hashCode => send.hashCode ^ receive.hashCode;
}
