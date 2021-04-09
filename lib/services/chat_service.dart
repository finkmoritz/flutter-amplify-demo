import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter_amplify_demo/models/Message.dart';
import 'package:flutter_amplify_demo/services/auth_service.dart';

class ChatService {
  static Future<List<Message>> getMessages() async {
    return Amplify.DataStore.query(
      Message.classType,
      sortBy: [Message.TIMESTAMP.ascending()],
    );
  }

  static Future<void> postMessage(String content) async {
    var user = await AuthService.getUser();
    var username = user?.username ?? 'Guest';
    var message = Message(
      user: username,
      timestamp: TemporalDateTime.now(),
      content: content,
    );
    Amplify.DataStore.save(message);
  }

  static Future<void> deleteAllMessages() async {
    List<Message> allMessages = await getMessages();
    allMessages.forEach((msg) {
      Amplify.DataStore.delete(msg);
    });
  }
}
