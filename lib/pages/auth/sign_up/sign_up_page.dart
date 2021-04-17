import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/services/auth_service.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmationCodeController = TextEditingController();

  int _stepIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400, maxHeight: 700),
          child: Stepper(
            currentStep: _stepIndex,
            onStepCancel: () {
              if (_stepIndex > 0) {
                setState(() {
                  _stepIndex--;
                });
              }
            },
            onStepContinue: () {
              if (_stepIndex < 2) {
                setState(() {
                  _stepIndex++;
                });
              }
            },
            onStepTapped: (index) {
              if (_stepIndex != index && index < 2) {
                setState(() {
                  _stepIndex = index;
                });
              }
            },
            steps: [
              Step(
                title: Text('Sign Up'),
                content: _buildSignUpForm(),
                isActive: _stepIndex == 0,
                state: _stepIndex > 0 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: Text('Confirm'),
                content: _buildConfirmationForm(),
                isActive: _stepIndex == 1,
                state: _stepIndex > 1 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: Text('Done'),
                content: Text('You successfully signed up.'),
                isActive: _stepIndex == 2,
                state: _stepIndex == 2 ? StepState.complete : StepState.indexed,
              ),
            ],
            controlsBuilder: (BuildContext context,
                {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
              switch (_stepIndex) {
                case 0:
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: onStepContinue,
                        child: const Text('Skip'),
                      ),
                      ElevatedButton(
                        onPressed: _signUp,
                        child: const Text('Sign Up'),
                      ),
                    ],
                  );
                case 1:
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: onStepCancel,
                        child: const Text('Back'),
                      ),
                      TextButton(
                        onPressed: _resend,
                        child: const Text('Resend Code'),
                      ),
                      ElevatedButton(
                        onPressed: _confirm,
                        child: const Text('Confirm'),
                      ),
                    ],
                  );
                case 2:
                  return ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/'),
                    child: const Text('Sign In'),
                  );
                default:
                  throw Exception('Index out of bounds: $_stepIndex');
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          controller: _emailController,
          decoration: InputDecoration(
              icon: Icon(Icons.mail),
              hintText: 'Enter your email address',
              labelText: 'Email address'
          ),
        ),
        TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Choose your username',
              labelText: 'Username'
          ),
        ),
        TextFormField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
              icon: Icon(Icons.lock),
              hintText: 'Choose your password',
              labelText: 'Password'
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmationForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            'We sent you an email with your confirmation code. Please check your inbox.'),
        TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Enter your username',
              labelText: 'Username'
          ),
        ),
        TextFormField(
          controller: _confirmationCodeController,
          decoration: InputDecoration(
              icon: Icon(Icons.check),
              hintText: 'Enter your confirmation code',
              labelText: 'Confirmation code'
          ),
        ),
      ],
    );
  }

  _signUp() async {
    try {
      await AuthService.signUp(
        email: _emailController.text.trim(),
        username: _usernameController.text.trim(),
        password: _passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Successfully signed up'),
      ));
      setState(() {
        _stepIndex = 1;
      });
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  _resend() async {
    try {
      await AuthService.resendConfirmationCode(
        username: _usernameController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Sent confirmation code'),
      ));
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  _confirm() async {
    try {
      SignUpResult result = await AuthService.confirmSignUp(
        username: _usernameController.text.trim(),
        confirmationCode: _confirmationCodeController.text.trim(),
      );
      if (result != null && result.isSignUpComplete) {
        setState(() {
          _stepIndex = 2;
        });
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}
