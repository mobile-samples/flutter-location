import 'package:flutter/material.dart';
import 'package:flutter_user/features/auth/auth_service.dart';
import 'package:flutter_user/router/router_constants.dart';

class LandingWidget extends StatelessWidget {
  const LandingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.instance.tryAutoLogin(),
      builder: (context, authResult) {
        if (authResult.connectionState == ConnectionState.done) {
          Future.microtask(() => Navigator.pushNamed(
              context, authResult.data == true ? homeRoute : loginRoute));
        }
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            valueColor: new AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary),
          ),
        );
      },
    );
  }
}
