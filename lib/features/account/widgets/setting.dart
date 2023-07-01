import 'package:flutter/material.dart';
import 'package:flutter_user/features/auth/auth_service.dart';
import 'package:flutter_user/router/router_constants.dart';

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
                    Navigator.of(context, rootNavigator: true)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
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
