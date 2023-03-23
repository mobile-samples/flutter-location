import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      total = int.parse(res.total);
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
        backgroundColor: Colors.white,
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
      ));
    } else {
      return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Text("Search Locations",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w700))),
                    CupertinoSearchTextField(controller: _textController),
                    ListView.builder(
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context, indexP) {
                        return Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                                  child: Text(
                                    list[indexP].key.toUpperCase(),
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  )),
                              Container(
                                height: 172,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemCount: list[indexP].value.length,
                                    itemBuilder: (context, indexC) {
                                      return Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(5, 5, 5, 5),
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LocationDetail(
                                                              locationId: list[
                                                                      indexP]
                                                                  .value[indexC]
                                                                  .id)));
                                            },
                                            child: LocationCard(
                                              location:
                                                  list[indexP].value[indexC],
                                            )),
                                      );
                                    }),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )),
      );
    }
  }
}
