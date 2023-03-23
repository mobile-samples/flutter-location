import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_user/models/location.dart';
import 'package:flutter_user/services/location.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_user/widgets/helpers/map-widget.dart';
import 'package:flutter_user/widgets/locations/location-comment.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocationDetail extends StatefulWidget {
  const LocationDetail({Key? key, required this.locationId}) : super(key: key);
  final locationId;
  @override
  State<LocationDetail> createState() => _LocationDetailState();
}

class _LocationDetailState extends State<LocationDetail> {
  late Location location;
  late bool _loading = true;
  late final WebViewController controller;
  @override
  void initState() {
    super.initState();
    getLocationDetail();
  }

  getLocationDetail() async {
    final res =
        await LocationService.instance.getLocationDetail(widget.locationId);
    setState(() {
      location = res;
      _loading = false;
    });
  }

  Widget getListStarWidgets(LocationInfo? info) {
    List<Widget> list = [];
    final infoMap = info?.toMap();
    for (var i = 5; i > 0; i--) {
      final per = infoMap?['rate' + i.toString()] ?? 0;
      list.add(Row(
        children: [
          RatingBar.builder(
            initialRating: double.parse(i.toString()),
            minRating: 1,
            direction: Axis.horizontal,
            itemCount: i,
            itemSize: 16,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {},
          ),
          Container(
              width: 150,
              child: LinearProgressIndicator(
                backgroundColor: Colors.grey,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.amber,
                ),
                value:
                    ((per * 100) / (info?.count == 0 ? 1 : info?.count)) ?? 0,
              )),
        ],
      ));
    }
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.end, children: list);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          title: Text("Location"),
          backgroundColor: Colors.green,
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      image: DecorationImage(
                          image: NetworkImage(location.imageURL ?? ''),
                          fit: BoxFit.cover)),
                  height: 220),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              location.name ?? '',
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.w700),
                            ),
                            Text(
                              location.description ?? '',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 14),
                            )
                          ],
                        ),
                        Spacer(),
                        TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.green,
                            textStyle: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20.0))),
                                builder: (BuildContext buildContext) {
                                  return MapWidget(
                                      latitude: location.latitude,
                                      longitude: location.longitude,
                                      locationName: location.name);
                                });
                          },
                          child: Text('View Map'),
                        ),
                      ],
                    ),
                    Divider(),
                    Text(
                      'Rating & Reviews',
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                location.info?.score ?? '0',
                                style: TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'out of 5',
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              getListStarWidgets(location.info),
                            ],
                          ),
                        ],
                      ),
                    ),
                    LocationComment(
                      locationId: location.id ?? '',
                      getLocationDetail: getLocationDetail,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
