import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/services/auth_service.dart';

class SignOutPage extends StatelessWidget {

  final String username;
  final Function onSignOut;

  const SignOutPage({Key key, this.username, this.onSignOut}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Signed in as',
            textAlign: TextAlign.center,
          ),
          Text(
            username,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold,),
          ),
          ElevatedButton(
            child: Text('Sign Out'),
            onPressed: () => _signOut(context),
          ),
        ],
      ),
    );
  }

  _signOut(BuildContext context) async {
    try {
      await AuthService.signOut( );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Successfully signed in'),
      ));
      onSignOut();
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}
