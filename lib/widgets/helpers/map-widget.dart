import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:flutter_map/flutter_map.dart';

class MapWidget extends StatefulWidget {
  const MapWidget(
      {Key? key,
      required this.latitude,
      required this.longitude,
      required this.locationName})
      : super(key: key);
  final latitude;
  final longitude;
  final locationName;
  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: EdgeInsets.only(
          top: MediaQueryData.fromWindow(WidgetsBinding.instance!.window)
              .padding
              .top),
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
            center: latLng.LatLng(
                (widget.latitude ?? '0'), (widget.longitude ?? '0')),
            zoom: 17.0,
          ),
          layers: [
            TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 80.0,
                  height: 80.0,
                  point: latLng.LatLng(
                      (widget.latitude ?? 0), (widget.longitude ?? 0)),
                  builder: (ctx) => Container(
                    child: Icon(
                      Icons.place,
                      color: Colors.red,
                      size: 24,
                    ),
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
