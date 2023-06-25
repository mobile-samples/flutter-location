import 'package:flutter/material.dart';
import 'package:flutter_user/features/auth/auth_service.dart';
import 'package:flutter_user/router/router_constants.dart';

class LandingWidget extends StatelessWidget {
  const LandingWidget({super.key});

  goto(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.instance.tryAutoLogin(),
      builder: (context, authResult) {
        if (authResult.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          );
        }
        if (authResult.connectionState == ConnectionState.done) {
          if (authResult.data == true) {
            return goto(context, homeRoute);
          } else {
            return goto(context, loginRoute);
          }
        }
        return Center(
          child: Text("We got some issue"),
        );
      },
    );
  }
}
