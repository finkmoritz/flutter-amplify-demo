import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/models/Message.dart';
import 'package:flutter_amplify_demo/services/chat_service.dart';

class DataStorePage extends StatefulWidget {
  @override
  _DataStorePageState createState() => _DataStorePageState();
}

class _DataStorePageState extends State<DataStorePage> {
  TextEditingController _controller;
  Future<List<Message>> _messages;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _subscribe();
    _updateMessages();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
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
    return FutureBuilder(
      future: _messages,
      builder: (context, snapshot) {
        List<Message> messages = snapshot.data;
        if(snapshot.connectionState == ConnectionState.done) {
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
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _buildChatInput() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _controller,
          ),
        ),
        IconButton(
          icon: Icon(Icons.send,),
          onPressed: () {
            ChatService.postMessage(_controller.text);
            setState(() {
              _controller.text = '';
            });
          },
        ),
      ],
    );
  }

  _updateMessages() {
    setState(() {
      _messages = ChatService.getMessages();
    });
  }
}
