import 'package:flutter/material.dart';
import 'package:flutter_user/common/widgets/circle_background.dart';
import 'package:flutter_user/common/widgets/dialog.dart';
import 'package:flutter_user/features/auth/auth_service.dart';

import 'reset_password.dart';

class ForgotPasswordWidget extends StatefulWidget {
  const ForgotPasswordWidget({super.key});

  @override
  State<ForgotPasswordWidget> createState() => _ForgotPasswordWidget();
}

class _ForgotPasswordWidget extends State<ForgotPasswordWidget> {
  TextEditingController contactController = TextEditingController();

  sendEmail() async {
    final isSend = await AuthService.instance
        .sendEmailForgotPW(contact: contactController.value.text);
    if (!context.mounted) return;
    if (!isSend) {
      return showDialogWithMsg(context, 'Alert', 'Send email error');
    }
    return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ResetPasswordWidget(),
          settings: RouteSettings(
            arguments: contactController.value.text,
          )),
    );
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
                        "Forgot password",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(width: 0, height: 20),
                      Text(
                        "Please input your contact and we will send the code to your email",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 0, height: 20),
                      TextField(
                        controller: contactController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.contact_mail),
                          hintText: "Contact",
                          border: InputBorder.none,
                          fillColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 0, height: 20),
                      ElevatedButton(
                        onPressed: () {
                          sendEmail();
                        },
                        child: const Text('Send'),
                      ),
                      const SizedBox(width: 0, height: 20),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ResetPasswordWidget(),
                            ),
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
