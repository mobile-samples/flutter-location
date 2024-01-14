import 'package:flutter/material.dart';
import 'package:flutter_user/features/auth/auth_service.dart';
import 'package:flutter_user/features/auth/widgets/login.dart';


class SettingWidget extends StatefulWidget {
  const SettingWidget({super.key});

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
          title: const Text("Setting"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  const Text("Hide/ Show my profile"),
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
              const Spacer(),
              ElevatedButton(onPressed: () {}, child: const Text("Save")),
              const SizedBox(
                height: 10,
              ),
              OutlinedButton(
                onPressed: () async {
                  final res = await AuthService.instance.logout();
                  if (!context.mounted) return;
                  if (res) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginWidget()),
                    );
                  }
                },
                child: const Text("Logout"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
