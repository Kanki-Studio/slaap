// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final String lang;
  final Map<String, String> translations;
  final Timestamp timestamp;
  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.lang,
    required this.translations,
    required this.timestamp,
  });

  ChatMessage copyWith({
    String? id,
    String? senderId,
    String? text,
    String? lang,
    Map<String, String>? translations,
    Timestamp? timestamp,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      text: text ?? this.text,
      lang: lang ?? this.lang,
      translations: translations ?? this.translations,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'senderId': senderId,
      'text': text,
      'lang': lang,
      'translations': translations,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as String,
      senderId: map['senderId'] as String,
      text: map['text'] as String,
      lang: map['lang'] as String,
      translations: Map<String, String>.from((map['translations'])),
      timestamp: Timestamp.fromMillisecondsSinceEpoch(map['timestamp']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatMessage(id: $id, senderId: $senderId, text: $text, lang: $lang, translations: $translations, timestamp: $timestamp)';
  }

  @override
  bool operator ==(covariant ChatMessage other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.senderId == senderId &&
        other.text == text &&
        other.lang == lang &&
        mapEquals(other.translations, translations) &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        senderId.hashCode ^
        text.hashCode ^
        lang.hashCode ^
        translations.hashCode ^
        timestamp.hashCode;
  }
}
