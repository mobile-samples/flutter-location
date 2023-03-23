import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_user/models/location.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({Key? key, required this.location}) : super(key: key);
  final Location location;
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
                color: Color(0xffDDDDDD),
                blurRadius: 2.0,
                spreadRadius: 2.0,
                offset: Offset(
                  2.0, // Move to right 7.0 horizontally
                  2.0, // Move to bottom 8.0 Vertically
                ))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                height: 125,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Image(
                  image: NetworkImage(location.imageURL ?? ''),
                )),
            Padding(
                padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Container(
                    child: Text(
                  location.name ?? '',
                  style: TextStyle(fontWeight: FontWeight.w500),
                )))
          ],
        ));
  }
}
