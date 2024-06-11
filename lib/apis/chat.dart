import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finder/models/chat.dart';
import 'package:finder/models/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatAPIProvider = Provider((ref) {
  return ChatAPI(db: FirebaseFirestore.instance, auth: FirebaseAuth.instance);
});

class ChatAPI {
  final FirebaseFirestore db;
  final FirebaseAuth auth;
  ChatAPI({required this.db, required this.auth});

  Future<bool> doesChatRoomExist(String chatRoomId) async {
    try {
      DocumentSnapshot doc =
          await db.collection('chat_rooms').doc(chatRoomId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking chat room existence: $e');
      return false;
    }
  }

  Future<void> sendMessage(String message, String receiverId) async {
    final String currentUserId = auth.currentUser!.uid;
    final String currentUserEmail = auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        sender: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        dateTime: timestamp);

    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    final exists = await doesChatRoomExist(chatRoomId);
    if (!exists) {
      ChatRoom chat = ChatRoom(userId: currentUserId, currentId: receiverId);
      await db.collection('chats').doc(chatRoomId).set(chat.toMap());
    }

    await db
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  Future<List<dynamic>> getChatRoomsForUser(String userId) async {
    try {
      final docs = await db.collection('chats').get();

      List<DocumentSnapshot> userChatRooms = docs.docs.where((doc) {
        List<String> ids = doc.id.split('_');
        return ids.contains(userId);
      }).toList();

      final rooms = userChatRooms
          .map((room) => ChatRoom.fromMap(room.data() as Map<String, dynamic>))
          .toList();

      return rooms;
    } catch (e) {
      print('Error getting chat rooms: $e');
      return [];
    }
  }

  Stream<QuerySnapshot> getMessages(String userId, String receiverId) {
    List<String> ids = [userId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    final docs = db
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('dateTime', descending: false)
        .snapshots();

    // Listen to the stream and print the documents
    docs.listen((snapshot) {
      if (snapshot.docs.isEmpty) {
        print('No messages found.');
      }
    });

    return docs;
  }
}
