import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_amplify_demo/services/auth_service.dart';

class PasswordChangePage extends StatefulWidget {
  @override
  _PasswordChangePageState createState() => _PasswordChangePageState();
}

class _PasswordChangePageState extends State<PasswordChangePage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  int _stepIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
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
              if (_stepIndex < 1) {
                setState(() {
                  _stepIndex++;
                });
              }
            },
            onStepTapped: (index) {
              if (_stepIndex != index && index < 1) {
                setState(() {
                  _stepIndex = index;
                });
              }
            },
            steps: [
              Step(
                title: Text('Change Password'),
                content: _buildChangePasswordForm(),
                isActive: _stepIndex == 0,
                state: _stepIndex > 0 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: Text('Done'),
                content: Text('Your password was successfully reset.'),
                isActive: _stepIndex == 1,
                state: _stepIndex == 1 ? StepState.complete : StepState.indexed,
              ),
            ],
            controlsBuilder: (BuildContext context,
                {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
              switch (_stepIndex) {
                case 0:
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: _changePassword,
                        child: const Text('Change Password'),
                      ),
                    ],
                  );
                case 1:
                  return Container();
                default:
                  throw Exception('Index out of bounds: $_stepIndex');
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChangePasswordForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextFormField(
          controller: _oldPasswordController,
          obscureText: true,
          decoration: InputDecoration(
              icon: Icon(Icons.lock),
              hintText: 'Enter your old password',
              labelText: 'Old password'
          ),
        ),
        TextFormField(
          controller: _newPasswordController,
          obscureText: true,
          decoration: InputDecoration(
              icon: Icon(Icons.lock),
              hintText: 'Enter your new password',
              labelText: 'New password'
          ),
        ),
      ],
    );
  }

  _changePassword() async {
    try {
      await AuthService.changePassword(
        oldPassword: _oldPasswordController.text.trim(),
        newPassword: _newPasswordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Successfully changed password'),
      ));
      setState(() {
        _stepIndex = 1;
      });
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }
}
