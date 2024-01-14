import 'package:flutter/material.dart';
import 'package:flutter_user/common/widgets/circle_background.dart';
import 'package:flutter_user/common/widgets/dialog.dart';
import 'package:flutter_user/common/widgets/hyberlink.dart';
import 'package:flutter_user/features/home.dart';

import '../auth_model.dart';
import '../auth_service.dart';
import 'change_password.dart';
import 'forgot_password.dart';
import 'signup.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  changePwWidget() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordWidget()),
    );
  }

  signupWidget() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupWidget()),
    );
  }

  forgotPwWidget() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordWidget()),
    );
  }

  handleLogin() async {
    final String username = userNameController.value.text;
    final String password = passwordController.value.text;
    if (username == "" || password == "") {
      return showDialogWithMsg(
          context, 'Alert', 'Please input your username or password');
    }
    final AuthResponse res = await AuthService.instance
        .authenticate(username: username, password: password);
    if (!mounted) return;
    if (res.user?.token != '') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeWidget()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          CircleBackground(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Column(
                    children: [
                      Text(
                        "Login",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(width: 0, height: 20),
                      Text(
                        "Please sigin to continue",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      TextField(
                        style: const TextStyle(color: Colors.black),
                        controller: userNameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.account_box),
                          hintText: "Username",
                          border: InputBorder.none,
                          fillColor: Colors.green,
                        ),
                      ),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          hintText: "Password",
                          border: InputBorder.none,
                          fillColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 0, height: 20),
                      ElevatedButton(
                        onPressed: () {
                          handleLogin();
                        },
                        child: Text(
                          'Sign in', 
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      const SizedBox(width: 0, height: 20),
                      getHyberLink('Sign up', signupWidget),
                      const SizedBox(width: 0, height: 20),
                      getHyberLink('Change password', changePwWidget),
                      const SizedBox(width: 0, height: 20),
                      getHyberLink('Forgot password', forgotPwWidget),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: null,
    );
  }
}
