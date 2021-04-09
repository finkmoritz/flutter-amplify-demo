import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/pages/auth/sign_in/sign_in_page.dart';
import 'package:flutter_amplify_demo/pages/auth/sign_out/sign_out_page.dart';
import 'package:flutter_amplify_demo/services/auth_service.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Future<AuthUser> authUser;

  @override
  void initState() {
    super.initState();
    authUser = AuthService.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: authUser,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          if(snapshot.data == null) {
            return SignInPage(
              onSignIn: () {
                setState(() {
                  authUser = AuthService.getUser();
                });
              },
            );
          } else {
            return SignOutPage(
              username: snapshot.data.username,
              onSignOut: () {
                setState(() {
                  authUser = AuthService.getUser();
                });
              },
            );
          }
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
