import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/models/Message.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var controller = TextEditingController();
  var messages = <Message>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Amplify Demo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(32.0),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Expanded(
          child: _buildChatHistory(),
        ),
        _buildChatInput(),
      ],
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
    //var user = await Amplify.Auth.getCurrentUser(); //FIXME
    var message = Message(
      user: 'Unknown User', //user.username, //FIXME
      timestamp: TemporalDateTime.now(),
      content: content,
    );
    Amplify.DataStore.save(message);
    _updateMessages();
  }
}
