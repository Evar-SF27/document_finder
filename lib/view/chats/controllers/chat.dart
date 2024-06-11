import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finder/apis/auth.dart';
import 'package:finder/apis/chat.dart';
import 'package:finder/models/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatControllerProvider =
    StateNotifierProvider<ChatAPIController, bool>((ref) {
  return ChatAPIController(
      chatAPI: ref.watch(chatAPIProvider), authAPI: ref.watch(authAPIProvider));
});

class ChatAPIController extends StateNotifier<bool> {
  final ChatAPI chatAPI;
  final AuthAPI authAPI;
  ChatAPIController({required this.chatAPI, required this.authAPI})
      : super(false);

  Future<void> sendMessage(String receiverId, String message) async {
    final currentUser = await authAPI.currentUser();
    final String currentUserId = currentUser!.uid;
    final String currentUserEmail = currentUser.email!;
    final Timestamp timestamp = Timestamp.now();

    Message newMessage = Message(
        sender: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverId,
        message: message,
        dateTime: timestamp);

    // chatAPI.sendMessage(newMessage, receiverId);
  }

  Future<Stream<QuerySnapshot>> getMessages(
      String userId, String receiverId) async {
    final stream = chatAPI.getMessages(userId, receiverId);

    return stream;
  }

  // Future<List<Message>> getMessage(String userId, String receiverId) {
  //   final stream = chatAPI.getMessages(userId, receiverId);
  //   final messages = stream.map((msg) => msg).toList();

  //   return messages;
  // }
}
