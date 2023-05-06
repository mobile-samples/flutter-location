import 'package:flutter/material.dart';
import 'package:flutter_user/models/location.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({Key? key, required this.location}) : super(key: key);
  final Location location;
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        height: double.maxFinite,
        width: 200,
        child: Card(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
              image: NetworkImage(location.imageURL ??
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png'),
              width: double.infinity,
              height: 125,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
              child: Text(
                location.name ?? '',
              ),
            )
          ],
        )));
  }
}
