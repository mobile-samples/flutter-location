import 'package:flutter/material.dart';
import '../../common/dialog.dart';
import '../../services/auth.dart';
import '../../widget-helpers/circle-background.dart';
import 'login.dart';

class ChangePasswordWidget extends StatefulWidget {
  const ChangePasswordWidget({Key? key}) : super(key: key);

  @override
  State<ChangePasswordWidget> createState() => _ChangePasswordWidgetState();
}

class _ChangePasswordWidgetState extends State<ChangePasswordWidget> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  changePassword() async {
    if (newPasswordController.value.text !=
        confirmPasswordController.value.text) {
      return showDialogWithMsg(
          context, 'Alert', 'New password and password isn\'t match');
    }
    final int resBody = await AuthService.instance.isChangePassword(
        username: usernameController.value.text,
        password: newPasswordController.value.text,
        currentPassword: currentPasswordController.value.text);

    if (resBody == 1) {
      return Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginWidget()),
      );
    }
    return showDialogWithMsg(context, 'Alert', 'Change password failed');
  }

  gotoLoginScreen() {
    Navigator.pop(
      context,
      MaterialPageRoute(builder: (context) => const LoginWidget()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
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
                        "Change password",
                          style: Theme.of(context).textTheme.titleLarge,
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
                        controller: currentPasswordController,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          hintText: "Current password",
                          border: InputBorder.none,
                          fillColor: Colors.green,
                        ),
                      ),
                      TextField(
                        controller: newPasswordController,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          hintText: "New password",
                          border: InputBorder.none,
                          fillColor: Colors.green,
                        ),
                      ),
                      TextField(
                        controller: confirmPasswordController,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          hintText: "Confirm password",
                          border: InputBorder.none,
                          fillColor: Colors.green,
                        ),
                      ),
                      SizedBox(width: 0, height: 20),
                      ElevatedButton(
                        onPressed: () {
                          changePassword();
                        },
                        child: const Text('Change password'),
                      ),
                      SizedBox(width: 0, height: 20),
                      ElevatedButton(
                        onPressed: () {
                          gotoLoginScreen();
                        },
                        child: const Text('Sign in'),
                      ),
                      SizedBox(width: 0, height: 20),
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
