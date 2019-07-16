import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PropertiesMapsPage extends GoogleMap {
  
}

class PropertyMapsListPage extends StatefulWidget {
  PropertyMapsListPage({Key key}) : super(key: key);

  _PropertyMapsListPageState createState() => _PropertyMapsListPageState();
}

class _PropertyMapsListPageState extends State<PropertyMapsListPage> {
  //Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _initPosition = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: _initPosition,
      // onMapCreated: (GoogleMapController controller) {
      //   _controller.complete(controller);
      // },
    ));
  }
}
