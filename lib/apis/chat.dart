import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finder/models/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatAPIProvider = Provider((ref) {
  return ChatAPI(db: FirebaseFirestore.instance);
});

class ChatAPI {
  final FirebaseFirestore db;
  ChatAPI({required this.db});

  void sendMessage(Message msg) async {
    List<String> ids = [msg.sender, msg.receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    await db
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(msg.toMap());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(
      String userId, String receiverId) {
    List<String> ids = [userId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    final docs = db
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();

    return docs;
  }
}
