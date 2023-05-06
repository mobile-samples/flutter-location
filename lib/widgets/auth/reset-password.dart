import 'package:flutter/material.dart';
import 'package:flutter_user/widgets/auth/forgot-password.dart';

import '../../common/dialog.dart';
import '../../services/auth.dart';
import '../../widget-helpers/circle-background.dart';
import 'login.dart';

class ResetPasswordWidget extends StatefulWidget {
  const ResetPasswordWidget({Key? key}) : super(key: key);

  @override
  State<ResetPasswordWidget> createState() => _ResetPasswordWidget();
}

class _ResetPasswordWidget extends State<ResetPasswordWidget> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passcodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  resetPW() async {
    final String username = usernameController.value.text;
    final String passcode = passcodeController.value.text;
    final String password = passwordController.value.text;

    final int resBody = await AuthService.instance.resetPassword(
      username: username,
      passcode: passcode,
      password: password,
    );
    if (resBody == 1) {
      return Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginWidget()),
      );
    }
    return showDialogWithMsg(context, 'Alert', 'Reset password failed');
  }

  sendEmail(String contract) async {
    final isSend =
        await AuthService.instance.sendEmailForgotPW(contact: contract);
    if (!isSend) {
      return showDialogWithMsg(context, 'Alert', 'Send email error');
    }
    return showDialogWithMsg(context, 'Alert', 'Send email success');
  }

  @override
  Widget build(BuildContext context) {
    final contract = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          CircleBackground(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Column(
                    children: [
                      Text(
                        "Reset password",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(width: 0, height: 20),
                      Text(
                        "Please input your passcode in email, username and new password",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(width: 0, height: 20),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.account_box),
                          hintText: "Username",
                          border: InputBorder.none,
                          fillColor: Colors.green,
                        ),
                      ),
                      TextField(
                        controller: passcodeController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.numbers),
                          hintText: "Passcode",
                          border: InputBorder.none,
                          fillColor: Colors.green,
                        ),
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          hintText: "Password",
                          border: InputBorder.none,
                          fillColor: Colors.green,
                        ),
                      ),
                      SizedBox(width: 0, height: 20),
                      Row(
                        children: [
                          new Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                sendEmail(contract as String);
                              },
                              child: const Text('Resend email'),
                            ),
                          ),
                          SizedBox(width: 10, height: 0),
                          new Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                resetPW();
                              },
                              child: const Text('Reset'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 0, height: 20),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordWidget()),
                          );
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
