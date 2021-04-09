import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
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
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _usernameController,
              validator: (value) {
                if (value.length < 5) {
                  return 'Username too short';
                }
                return null;
              },
              decoration: InputDecoration(hintText: 'Enter your username'),
            ),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              validator: (value) {
                if (value.length < 8) {
                  return 'Password too short';
                }
                return null;
              },
              decoration: InputDecoration(hintText: 'Enter your password'),
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
      ),
    );
  }

  _signIn() async {
    if (_formKey.currentState.validate()) {
      var username = _usernameController.text.trim();
      var password = _passwordController.text.trim();
      try {
        SignInResult result = await AuthService.signIn(
          username: username,
          password: password,
        );
        print(result.isSignedIn);
        print((await Amplify.Auth.fetchAuthSession()).isSignedIn);
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
}
