// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatRoom {
  String userId;
  String currentId;
  ChatRoom({
    required this.userId,
    required this.currentId,
  });

  ChatRoom copyWith({
    String? userId,
    String? currentId,
  }) {
    return ChatRoom(
      userId: userId ?? this.userId,
      currentId: currentId ?? this.currentId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'currentId': currentId,
    };
  }

  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      userId: map['userId'] as String,
      currentId: map['currentId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatRoom.fromJson(String source) =>
      ChatRoom.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ChatRoom(userId: $userId, currentId: $currentId)';

  @override
  bool operator ==(covariant ChatRoom other) {
    if (identical(this, other)) return true;

    return other.userId == userId && other.currentId == currentId;
  }

  @override
  int get hashCode => userId.hashCode ^ currentId.hashCode;
}
