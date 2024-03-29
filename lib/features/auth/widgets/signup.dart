import 'package:flutter/material.dart';
import 'package:flutter_user/common/widgets/circle_background.dart';
import 'package:flutter_user/common/widgets/dialog.dart';
import 'package:flutter_user/features/auth/auth_model.dart';

import '../auth_service.dart';
import 'login.dart';

class SignupWidget extends StatefulWidget {
  const SignupWidget({super.key});

  @override
  State<SignupWidget> createState() => _SignupWidgetState();
}

class _SignupWidgetState extends State<SignupWidget> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();

  handleSignup() async {
    final String username = userNameController.value.text;
    final String password = passwordController.value.text;
    final String contact = contactController.value.text;
    final String firstName = firstnameController.value.text;
    final String lastName = lastnameController.value.text;

    final AuthResponse authRes = await AuthService.instance.signup(
      username: username,
      password: password,
      contact: contact,
      firstName: firstName,
      lastName: lastName,
    );

    if (!mounted) return;
    
    if (authRes.status == 1) {
      return Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginWidget()),
      );
    }

    String msg = '';
    authRes.errors?.forEach((err) {
      msg += '${err.field} ${err.code} \n';
    });

    return showDialogWithMsg(context, 'Alert', 'Signup failed\n$msg');
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
                        "Signup",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextField(
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
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.password),
                          hintText: "Password",
                          border: InputBorder.none,
                          fillColor: Colors.green,
                        ),
                      ),
                      TextField(
                        controller: contactController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.contact_mail),
                          hintText: "Contact",
                          border: InputBorder.none,
                          fillColor: Colors.green,
                        ),
                      ),
                      TextField(
                        controller: firstnameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: "First name",
                          border: InputBorder.none,
                          fillColor: Colors.green,
                        ),
                      ),
                      TextField(
                        controller: lastnameController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: "Last name",
                          border: InputBorder.none,
                          fillColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 0, height: 20),
                      ElevatedButton(
                        onPressed: () {
                          handleSignup();
                        },
                        child: const Text('Sign up'),
                      ),
                      const SizedBox(width: 0, height: 20),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginWidget()),
                          );
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
