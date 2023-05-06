import 'package:flutter/material.dart';
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
              color: Theme.of(context).colorScheme.tertiary,
            ),
            onRatingUpdate: (rating) {},
          ),
          Container(
              width: 150,
              child: LinearProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.tertiary,
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
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          valueColor: new AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary),
        ),
      );
    }
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context)
                .scaffoldBackgroundColor, //change your color here
          ),
          title: Text("Location"),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image(
                image: NetworkImage(location.imageURL ?? ''),
                fit: BoxFit.cover,
                height: 220,
                width: MediaQuery.of(context).size.width,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(location.name ?? '',
                                style:
                                    Theme.of(context).textTheme.headlineMedium),
                            Text(
                              location.description ?? '',
                              style: Theme.of(context).textTheme.labelSmall,
                            )
                          ],
                        ),
                        TextButton(
                          style: Theme.of(context).textButtonTheme.style,
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
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Column(
                            children: [
                              Text(
                                location.info?.rate.toString() ?? '0',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              Text(
                                'out of 5',
                                style: Theme.of(context).textTheme.labelSmall,
                              )
                            ],
                          ),
                          Spacer(),
                          Row(
                            children: [
                              getListStarWidgets(location.info, context),
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
