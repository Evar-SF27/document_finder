// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String sender;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp dateTime;
  Message({
    required this.sender,
    required this.senderEmail,
    required this.receiverId,
    required this.message,
    required this.dateTime,
  });

  Message copyWith({
    String? sender,
    String? senderEmail,
    String? receiverId,
    String? message,
    Timestamp? dateTime,
  }) {
    return Message(
      sender: sender ?? this.sender,
      senderEmail: senderEmail ?? this.senderEmail,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      dateTime: dateTime ?? this.dateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sender': sender,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'dateTime': dateTime,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      sender: map['sender'] as String,
      senderEmail: map['senderEmail'] as String,
      receiverId: map['receiverId'] as String,
      message: map['message'] as String,
      dateTime: map['dateTime'] as Timestamp,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(sender: $sender, senderEmail: $senderEmail, receiverId: $receiverId, message: $message, dateTime: $dateTime)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;

    return other.sender == sender &&
        other.senderEmail == senderEmail &&
        other.receiverId == receiverId &&
        other.message == message &&
        other.dateTime == dateTime;
  }

  @override
  int get hashCode {
    return sender.hashCode ^
        senderEmail.hashCode ^
        receiverId.hashCode ^
        message.hashCode ^
        dateTime.hashCode;
  }
}
