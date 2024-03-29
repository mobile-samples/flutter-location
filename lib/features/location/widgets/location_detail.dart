import 'package:flutter/material.dart';
import 'package:flutter_user/features/location/location_model.dart';
import 'package:flutter_user/features/location/location_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_user/features/location/widgets/map_widget.dart';

import 'location_comment.dart';

class LocationDetail extends StatefulWidget {
  const LocationDetail({super.key, required this.locationId});
  final String locationId;
  @override
  State<LocationDetail> createState() => _LocationDetailState();
}

class _LocationDetailState extends State<LocationDetail> {
  late Location location;
  late bool _loading = true;
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

  Widget getListStarWidgets(LocationInfo? info, BuildContext context) {
    List<Widget> list = [];
    final infoMap = info?.toMap();
    for (var i = 5; i > 0; i--) {
      final per = infoMap?['rate$i'] ?? 0;
      list.add(Row(
        children: [
          RatingBar.builder(
            initialRating: double.parse(i.toString()),
            minRating: 1,
            direction: Axis.horizontal,
            itemCount: i,
            itemSize: 16,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            onRatingUpdate: (rating) {},
          ),
          SizedBox(
              width: 150,
              child: LinearProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.tertiary,
                ),
                value: ((per * 100) / 5) ?? 0,
              )),
        ],
      ));
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.end, children: list);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary),
        ),
      );
    }
    return Scaffold(
      body: SizedBox(
        height: double.maxFinite,
        child: Stack(
          children: [
            Image(
              image: NetworkImage(location.imageURL ?? ''),
              fit: BoxFit.cover,
              height: 300,
              width: MediaQuery.of(context).size.width,
            ),
            Positioned(
              top: 40,
              left: 10,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    iconSize: 32,
                    icon: const Icon(Icons.chevron_left),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 270,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32)),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
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
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium),
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
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20.0))),
                                    builder: (BuildContext buildContext) {
                                      return MapWidget(
                                          latitude: location.latitude ?? 0,
                                          longitude: location.longitude ?? 0,
                                          locationName: location.name ?? '');
                                    });
                              },
                              child: const Text('View Map'),
                            ),
                          ],
                        ),
                        const Divider(),
                        Text(
                          'Rating & Reviews',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
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
                            const Spacer(),
                            Row(
                              children: [
                                getListStarWidgets(location.info, context),
                              ],
                            ),
                          ],
                        ),
                        LocationComment(
                          locationId: location.id ?? '',
                          getLocationDetail: getLocationDetail,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    // return Scaffold(
    //   resizeToAvoidBottomInset: false,
    //   body: SingleChildScrollView(
    //     child: Column(
    //       children: [
    //         Image(
    //           image: NetworkImage(location.imageURL ?? ''),
    //           fit: BoxFit.cover,
    //           height: 220,
    //           width: MediaQuery.of(context).size.width,
    //         ),
    //         Padding(
    //           padding: EdgeInsets.all(10),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text(location.name ?? '',
    //                           style:
    //                               Theme.of(context).textTheme.headlineMedium),
    //                       Text(
    //                         location.description ?? '',
    //                         style: Theme.of(context).textTheme.labelSmall,
    //                       )
    //                     ],
    //                   ),
    //                   TextButton(
    //                     style: Theme.of(context).textButtonTheme.style,
    //                     onPressed: () {
    //                       showModalBottomSheet(
    //                           context: context,
    //                           isScrollControlled: true,
    //                           shape: RoundedRectangleBorder(
    //                               borderRadius: BorderRadius.vertical(
    //                                   top: Radius.circular(20.0))),
    //                           builder: (BuildContext buildContext) {
    //                             return MapWidget(
    //                                 latitude: location.latitude,
    //                                 longitude: location.longitude,
    //                                 locationName: location.name);
    //                           });
    //                     },
    //                     child: Text('View Map'),
    //                   ),
    //                 ],
    //               ),
    //               Divider(),
    //               Text(
    //                 'Rating & Reviews',
    //                 style: Theme.of(context).textTheme.titleMedium,
    //               ),
    //               SizedBox(
    //                 height: 10,
    //               ),
    //               Row(
    //                 children: [
    //                   Column(
    //                     children: [
    //                       Text(
    //                         location.info?.rate.toString() ?? '0',
    //                         style: Theme.of(context).textTheme.titleLarge,
    //                       ),
    //                       Text(
    //                         'out of 5',
    //                         style: Theme.of(context).textTheme.labelSmall,
    //                       )
    //                     ],
    //                   ),
    //                   Spacer(),
    //                   Row(
    //                     children: [
    //                       getListStarWidgets(location.info, context),
    //                     ],
    //                   ),
    //                 ],
    //               ),
    //               LocationComment(
    //                 locationId: location.id ?? '',
    //                 getLocationDetail: getLocationDetail,
    //               )
    //             ],
    //           ),
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }
}
