import 'package:flutter/material.dart';
import 'package:flutter_user/features/auth/auth_service.dart';
import 'package:flutter_user/features/auth/widgets/login.dart';
import 'package:flutter_user/features/home.dart';

class LandingWidget extends StatelessWidget {
  const LandingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService.instance.tryAutoLogin(),
      builder: (context, authResult) {
        if (authResult.connectionState == ConnectionState.done) {
          Future.microtask(() => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => authResult.data == true
                      ? const HomeWidget()
                      : const LoginWidget())));
        }
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary),
          ),
        );
      },
    );
  }
}
