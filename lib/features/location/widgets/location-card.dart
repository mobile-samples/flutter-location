import 'package:flutter/material.dart';
import 'package:flutter_user/features/location/location_model.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({Key? key, required this.location}) : super(key: key);
  final Location location;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 12,
      ),
      child: Container(
        width: 150,
        height: 300,
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
              padding: EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 16.0,
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  location.name ?? '',
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 2,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
