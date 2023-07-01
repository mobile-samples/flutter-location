import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_user/features/film/widgets/films.dart';
import 'package:flutter_user/features/job/widgets/job_list.dart';
import 'package:flutter_user/router/router_constants.dart';

import 'account/widgets/account-list.dart';
import 'account/widgets/account.dart';
import 'auth/auth_service.dart';
import 'location/widgets/location-list.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  late String? userId = "";

  @override
  void initState() {
    super.initState();
    final storage = new FlutterSecureStorage();
    storage
        .read(key: 'userId')
        .then((data) => {
              if (data != '')
                {
                  setState(() {
                    userId = data;
                  })
                }
              else
                {Navigator.pushReplacementNamed(context, loginRoute)}
            })
        .catchError((e) {
      Navigator.pushReplacementNamed(context, loginRoute);
    });
  }

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
            label: 'Movies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Companies',
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
            if (index == 1) {
              return FilmListWidget();
            }
            if (index == 2) {
              return AccountListWidget();
            }
            if (index == 3) {
              return JobListWidget();
            }
            if (index == 4 && userId != '') {
              return AccountWidget(
                userId: userId ?? '',
              );
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
