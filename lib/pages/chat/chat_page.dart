import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/models/Message.dart';
import 'package:flutter_amplify_demo/services/chat_service.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var controller = TextEditingController();
  var messages = <Message>[];

  @override
  void initState() {
    super.initState();
    _subscribe();
    _updateMessages();
  }

  _subscribe() {
    Amplify.DataStore
      .observe(Message.classType)
      .listen(
          (event) {
            _updateMessages();
          }
      );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          _buildClearButton(),
          Expanded(
            child: _buildChatHistory(),
          ),
          _buildChatInput(),
        ],
      ),
    );
  }

  Widget _buildClearButton() {
    return TextButton(
      child: Text('Delete all messages', style: TextStyle(color: Colors.red,),),
      onPressed: () => ChatService.deleteAllMessages(),
    );
  }

  Widget _buildChatHistory() {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(messages[index].user),
          subtitle: Text(messages[index].content),
        );
      }
    );
  }

  Widget _buildChatInput() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
          ),
        ),
        IconButton(
          icon: Icon(Icons.send,),
          onPressed: () {
            ChatService.postMessage(controller.text);
            setState(() {
              controller.text = '';
            });
          },
        ),
      ],
    );
  }

  _updateMessages() async {
    messages = await ChatService.getMessages();
    setState(() {});
  }
}
