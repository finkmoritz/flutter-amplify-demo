import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/models/Message.dart';

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
          Expanded(
            child: _buildChatHistory(),
          ),
          _buildChatInput(),
        ],
      ),
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
            _postMessage(controller.text);
            setState(() {
              controller.text = '';
            });
          },
        ),
      ],
    );
  }

  _updateMessages() async {
    messages = await Amplify.DataStore.query(
      Message.classType,
      sortBy: [Message.TIMESTAMP.ascending()],
    );
    setState(() {});
  }

  _postMessage(String content) async {
    var username = 'Guest';
    try{
      var user = await Amplify.Auth.getCurrentUser();
      username = user.username;
    } on SignedOutException {
      print('User is using guest access');
    }
    var message = Message(
      user: username,
      timestamp: TemporalDateTime.now(),
      content: content,
    );
    Amplify.DataStore.save(message);
  }
}
