import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'common/app_theme.dart';
import 'router/router_constants.dart';
import 'router/routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.title,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: getAppTheme(context, false),
      routes: routes,
      onGenerateRoute: generateRoutes,
      initialRoute: landingRoute,
      // home: FutureBuilder(
      //   future: AuthService.instance.tryAutoLogin(),
      //   builder: (context, authResult) {
      //     if (authResult.connectionState == ConnectionState.waiting) {
      //       return CircularProgressIndicator(
      //         valueColor: AlwaysStoppedAnimation<Color>(
      //           Theme.of(context).colorScheme.primary,
      //         ),
      //       );
      //     }
      //     if (authResult.connectionState == ConnectionState.done) {
      //       if (authResult.data == true) {
      //         return HomeWidget();
      //       } else {
      //         return LoginWidget();
      //       }
      //     }
      //     return Center(
      //       child: Text("We got some issue"),
      //     );
      //   },
      // ),
    );
  }
}
