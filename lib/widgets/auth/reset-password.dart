import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_user/widgets/auth/forgot-password.dart';

import '../../widget-helpers/circle-background.dart';

class ResetPasswordWidget extends StatefulWidget {
  const ResetPasswordWidget({Key? key}) : super(key: key);

  @override
  State<ResetPasswordWidget> createState() => _ResetPasswordWidget();
}

class _ResetPasswordWidget extends State<ResetPasswordWidget> {
  TextEditingController contactController = TextEditingController();

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
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Column(
                    children: [
                      Text(
                        "Reset password",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(width: 0, height: 20),
                      Text(
                        "Please input your contact and we will send the code to your email",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      SizedBox(width: 0, height: 20),
                      TextField(
                        controller: contactController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.contact_mail),
                          hintText: "Contact",
                          border: InputBorder.none,
                          fillColor: Colors.green,
                        ),
                      ),
                      SizedBox(width: 0, height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // resetPW();
                        },
                        child: const Text('Send'),
                      ),
                      SizedBox(width: 0, height: 20),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ForgotPasswordWidget()),
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
