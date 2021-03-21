import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var controller = TextEditingController();
  var messages = <String>[
    'Hello World!',
    'Hi :)'
  ];

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
          title: Text('User'),
          subtitle: Text(messages[index]),
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
            setState(() {
              messages.add(controller.text);
              controller.text = '';
            });
          },
        ),
      ],
    );
  }
}
