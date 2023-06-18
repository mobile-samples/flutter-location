import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_user/features/location/location_model.dart';
import 'package:flutter_user/features/location/location_service.dart';
import "package:collection/collection.dart";

import 'location-card.dart';
import 'location-detail.dart';

class LocationListWidget extends StatefulWidget {
  const LocationListWidget({Key? key}) : super(key: key);

  @override
  State<LocationListWidget> createState() => _LocationListWidgetState();
}

class _LocationListWidgetState extends State<LocationListWidget> {
  late List<Location> locations;
  late List<MapEntry<String, List<Location>>> list;
  late int total;
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    getLocation();
  }

  getLocation() async {
    final res = await LocationService.instance.search();
    setState(() {
      locations = res.list;
      total = res.total;
      _loading = false;
      list = res.list
          .groupListsBy((element) => element.type ?? '')
          .entries
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading == true) {
      return Center(
          child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        valueColor: new AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary),
      ));
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
            child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.menu),
                    Text("Location",
                        style: Theme.of(context).textTheme.titleLarge!),
                    Icon(Icons.search),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 200,
                child: PageView.builder(
                  controller:
                      PageController(viewportFraction: 0.90, initialPage: 3),
                  itemBuilder: (BuildContext context, int index) {
                    var location = locations[index % 3];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (BuildContext context) {
                              return LocationDetail(
                                locationId: location.id,
                              );
                            }),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            image: DecorationImage(
                              image: NetworkImage(location.imageURL ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Stack(
                            children: [
                              Opacity(
                                opacity: 0.3,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 16.0,
                                  right: 16.0,
                                  bottom: 16.0,
                                ),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    location.name ?? '',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                    maxLines: 2,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: locations.length,
                ),
              ),
              ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: list.length,
                padding: EdgeInsets.only(top: 10),
                itemBuilder: (context, indexP) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              list[indexP].key.toUpperCase(),
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                      Container(
                        height: 175,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: list[indexP].value.length,
                            padding: EdgeInsets.only(top: 5, bottom: 5),
                            itemBuilder: (context, indexC) {
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LocationDetail(
                                                    locationId: list[indexP]
                                                        .value[indexC]
                                                        .id)));
                                  },
                                  child: LocationCard(
                                    location: list[indexP].value[indexC],
                                  ));
                            }),
                      )
                    ],
                  );
                },
              ),
            ],
          ),
        )),
      );
    }
  }
}
