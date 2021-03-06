import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/pages/auth/password_management/password_reset_page.dart';
import 'package:flutter_amplify_demo/pages/auth/sign_up/sign_up_page.dart';
import 'package:flutter_amplify_demo/services/auth_service.dart';

class SignInPage extends StatefulWidget {
  final Function onSignIn;

  const SignInPage({Key key, this.onSignIn}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Enter your username',
              labelText: 'Username'
            ),
          ),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(
                icon: Icon(Icons.lock),
                hintText: 'Enter your password',
                labelText: 'Password'
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: Text('Sign Up'),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
              ),
              TextButton(
                child: Text(
                  'Reset Password',
                ),
                onPressed: () {
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => PasswordResetPage()),
                  );
                },
              ),
              ElevatedButton(
                child: Text('Sign In'),
                onPressed: _signIn,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _signIn() async {
    var username = _usernameController.text.trim();
    var password = _passwordController.text.trim();
    try {
      SignInResult result = await AuthService.signIn(
        username: username,
        password: password,
      );
      if(result != null && result.isSignedIn) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Successfully signed in'),
        ));
        widget.onSignIn();
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}
