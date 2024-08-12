// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:slaap/models/chat_message.dart';

class ChatStatus {
  final ChatMessage? lastMessage;
  final Timestamp? lastSeen;
  final int unreadCount;
  ChatStatus({
    required this.lastMessage,
    required this.lastSeen,
    required this.unreadCount,
  });

  ChatStatus copyWith({
    ChatMessage? lastMessage,
    Timestamp? lastSeen,
    int? unreadCount,
  }) {
    return ChatStatus(
      lastMessage: lastMessage ?? this.lastMessage,
      lastSeen: lastSeen ?? this.lastSeen,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'lastMessage': lastMessage?.toMap(),
      'lastSeen': lastSeen?.millisecondsSinceEpoch,
      'unreadCount': unreadCount,
    };
  }

  factory ChatStatus.fromMap(Map<String, dynamic> map) {
    return ChatStatus(
      lastMessage: map['lastMessage'] != null
          ? ChatMessage.fromMap(map['lastMessage'] as Map<String, dynamic>)
          : null,
      lastSeen: map['lastSeen'] != null
          ? Timestamp.fromMillisecondsSinceEpoch(map['lastSeen'])
          : null,
      unreadCount: map['unreadCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatStatus.fromJson(String source) =>
      ChatStatus.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'ChatStatus(lastMessage: $lastMessage, lastSeen: $lastSeen, unreadCount: $unreadCount)';

  @override
  bool operator ==(covariant ChatStatus other) {
    if (identical(this, other)) return true;

    return other.lastMessage == lastMessage &&
        other.lastSeen == lastSeen &&
        other.unreadCount == unreadCount;
  }

  @override
  int get hashCode =>
      lastMessage.hashCode ^ lastSeen.hashCode ^ unreadCount.hashCode;
}
