import 'package:flutter/material.dart';
import 'package:flutter_user/features/home.dart';

final Map<String, WidgetBuilder> routes = {
  HomeWidget.routeName: (context) => const HomeWidget(),
};

MaterialPageRoute<dynamic>? generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case HomeWidget.routeName:
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => HomeWidget(),
      );
    default:
      return null;
  }
}
