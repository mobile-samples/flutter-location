import 'package:flutter/material.dart';
import 'package:flutter_user/features/auth/widgets/login.dart';
import 'package:flutter_user/features/home.dart';
import 'package:flutter_user/features/job/widgets/Job_detail.dart';
import 'package:flutter_user/features/landing.dart';

import 'router_constants.dart';

final Map<String, WidgetBuilder> routes = {
  landingRoute: (context) => const LandingWidget(),
  homeRoute: (context) => const HomeWidget(),
  loginRoute: (context) => const LoginWidget(),
};

MaterialPageRoute<dynamic>? generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case jobDetail:
      final args = settings.arguments as String;
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => JobDetail(
          id: args,
        ),
      );
    default:
      return new MaterialPageRoute(builder: (context) => LandingWidget());
  }
}
