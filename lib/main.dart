import 'package:flutter/material.dart';
import 'package:flutter_user/common/app_theme.dart';
import 'package:flutter_user/features/auth/auth_service.dart';
import 'package:flutter_user/features/auth/widgets/login.dart';
import 'package:flutter_user/features/home.dart';

import 'routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Film',
      theme: getAppTheme(context, false),
      routes: routes,
      home: FutureBuilder(
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
              return HomeWidget();
            } else {
              return LoginWidget();
            }
          }
          return Center(
            child: Text("We got some issue"),
          );
        },
      ),
      // onUnknownRoute: (RouteSettings setting) {
      //   return new MaterialPageRoute(
      //               builder: (context) => NotFoundPage()
      //   );
      // }
    );
  }
}
