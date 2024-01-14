import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as lat_long;
import 'package:flutter_map/flutter_map.dart';

class MapWidget extends StatefulWidget {
  const MapWidget(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.locationName});
  final double latitude;
  final double longitude;
  final String locationName;
  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.only(
          top: MediaQueryData.fromView(View.of(context))
              .padding
              .top
              ),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Theme.of(context)
                .scaffoldBackgroundColor, //change your color here
          ),
          title: Text(widget.locationName),
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
        ),
        body: FlutterMap(
          options: MapOptions(
            // screenSize: Size.fromHeight(300),
            initialCenter: lat_long.LatLng(
                (widget.latitude), (widget.longitude)),
            initialZoom: 17.0,
          ),
          children: [
            TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c']),
            MarkerLayer(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: lat_long.LatLng(
                      (widget.latitude), (widget.longitude)),
                  child: const Icon(
                      Icons.place,
                      color: Colors.red,
                      size: 24,
                    ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
