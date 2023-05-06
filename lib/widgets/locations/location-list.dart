import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_user/models/location.dart';
import 'package:flutter_user/services/location.dart';
import 'package:flutter_user/widgets/locations/location-card.dart';
import "package:collection/collection.dart";
import 'package:flutter_user/widgets/locations/location-detail.dart';

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
  late TextEditingController _textController;
  @override
  void initState() {
    super.initState();
    getLocation();
    _textController = TextEditingController(text: '');
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
      return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Search Locations",
                      style: Theme.of(context).textTheme.headlineMedium),
                  CupertinoSearchTextField(controller: _textController),
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
                          Text(
                            list[indexP].key.toUpperCase(),
                            style: Theme.of(context).textTheme.titleMedium,
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
