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
      resizeToAvoidBottomInset: true,
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
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                        ),
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
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.green),
                          minimumSize: MaterialStatePropertyAll<Size>(
                              Size(double.infinity, 50)),
                          padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                              EdgeInsets.fromLTRB(15, 0, 15, 0)),
                        ),
                        child: const Text('Change password'),
                      ),
                      SizedBox(width: 0, height: 20),
                      ElevatedButton(
                        onPressed: () {
                          gotoLoginScreen();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.green),
                          minimumSize: MaterialStatePropertyAll<Size>(
                              Size(double.infinity, 50)),
                          padding: MaterialStatePropertyAll<EdgeInsetsGeometry>(
                              EdgeInsets.fromLTRB(15, 0, 15, 0)),
                        ),
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
