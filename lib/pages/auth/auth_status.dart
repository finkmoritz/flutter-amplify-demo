import 'dart:async';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/services/auth_service.dart';

class AuthStatus extends StatefulWidget {
  @override
  _AuthStatusState createState() => _AuthStatusState();
}

class _AuthStatusState extends State<AuthStatus> {
  Future<AuthUser> authUser;

  @override
  void initState() {
    super.initState();
    authUser = AuthService.getUser();
    _subscribe();
  }

  _subscribe() {
    Amplify.Hub.listen([HubChannel.Auth], (event) {
      if(['SIGNED_IN', 'SIGNED_OUT', 'SESSION_EXPIRED'].contains(event.eventName)) {
        setState(() {
          authUser = AuthService.getUser();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authUser,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          var username = 'Guest';
          if(snapshot.data != null) {
            username = snapshot.data.username;
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(username, style: TextStyle(color: Colors.black),)
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
