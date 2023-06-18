import 'package:flutter/material.dart';
import 'package:flutter_user/features/home.dart';
import 'package:flutter_user/features/job/widgets/detail.dart';

final Map<String, WidgetBuilder> routes = {
  HomeWidget.routeName: (context) => const HomeWidget(),
};

MaterialPageRoute<dynamic>? generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case JobDetail.routeName:
      final args = settings.arguments as String;
      return MaterialPageRoute<dynamic>(
        settings: settings,
        builder: (context) => JobDetail(
          id: args,
        ),
      );
    default:
      return null;
  }
}
