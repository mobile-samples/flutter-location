import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_user/widgets/locations/location-list.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      resizeToAvoidBottomInset: false,
      tabBar: CupertinoTabBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.location_fill),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.film_fill),
            label: 'Movíe',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_fill),
            label: 'Account',
          ),
        ],
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            if (index == 0) {
              return LocationListWidget();
            }
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.background,
                valueColor: new AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary),
              ),
            );
          },
        );
      },
    );
  }
}
