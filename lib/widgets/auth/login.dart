import 'package:flutter/material.dart';
import 'package:flutter_user/models/auth.dart';
import 'package:flutter_user/services/auth.dart';
import 'package:flutter_user/widget-helpers/circle-background.dart';
import 'package:flutter_user/widgets/auth/signup.dart';
import 'package:flutter_user/widgets/home.dart';
import '../../common/dialog.dart';
import 'change-password.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  handleLogin() async {
    final String username = userNameController.value.text;
    final String password = passwordController.value.text;
    if (username == "" || password == "") {
      return showDialogWithMsg(
          context, 'Alert', 'Please input your username or password');
    }
    final AuthResponse res = await AuthService.instance
        .authenticate(username: username, password: password);
    if (res.user.token != '') {
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleBackground(
                child: Theme(
                    data:
                        Theme.of(context).copyWith(primaryColor: Colors.green),
                    child: Container(
                        width: double.infinity,
                        height: 300,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 32, fontWeight: FontWeight.w700),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 10, 0, 0),
                              child: Text(
                                "Please sigin to continue",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                              child: SizedBox(
                                width: 200,
                                child: TextField(
                                  controller: userNameController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.account_box),
                                    hintText: "User name",
                                    border: InputBorder.none,
                                    fillColor: Colors.green,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                              child: SizedBox(
                                width: 200,
                                child: TextField(
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
                              ),
                            ),
                            GestureDetector(
                              onTap: () => {handleLogin()},
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(20, 5, 5, 5),
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Sign in",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            IconButton(
                                              onPressed: () {},
                                              icon: Icon(Icons.arrow_right),
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ]),
                            )
                          ],
                        ))))
          ],
        ));
  }
}
