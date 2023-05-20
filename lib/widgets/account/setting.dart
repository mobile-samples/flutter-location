import 'package:flutter/material.dart';
import 'package:flutter_user/services/auth.dart';
import 'package:flutter_user/widgets/auth/login.dart';

class SettingWidget extends StatefulWidget {
  const SettingWidget({Key? key}) : super(key: key);

  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  bool isShowMyProfile = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context)
                .scaffoldBackgroundColor, //change your color here
          ),
          title: Text("Setting"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Hide/ Show my profile"),
                  Switch(
                      activeColor: Colors.green,
                      value: isShowMyProfile,
                      onChanged: (bool value) {
                        setState(() {
                          isShowMyProfile = value;
                        });
                      })
                ],
              ),
              Spacer(),
              ElevatedButton(onPressed: () {}, child: Text("Save")),
              SizedBox(
                height: 10,
              ),
              OutlinedButton(
                onPressed: () async {
                  final res = await AuthService.instance.logout();
                  if (res) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginWidget()),
                    );
                  }
                },
                child: Text("Logout"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
