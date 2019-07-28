import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:retail_realestate_flutter/models/propertyDetails.dart';

class DetailMapsView extends StatefulWidget {
  DetailMapsView({Key key, this.property}) : super(key: key);

  final PropertyDetails property;

  _DetailMapsViewState createState() => _DetailMapsViewState();
}

class _DetailMapsViewState extends State<DetailMapsView> {
  Completer<GoogleMapController> _mapsController = Completer();

  @override
  Widget build(BuildContext context) {
    final location =
        {widget.property.location[0], widget.property.location[1]}.toList();

    final CameraPosition _initPosition = CameraPosition(
      target: LatLng(location[0], location[1]),
      zoom: 12.73,
    );

    Set<Marker> _propertyMarkers = {
      Marker(
          consumeTapEvents: true,
          markerId: MarkerId(widget.property.id),
          position: LatLng(location[0], location[1]))
    }.toSet();

    final segments =
        Map<String, Widget>.fromIterable({"normal", "satelite", "terrein"},
            key: (item) => item.toString(),
            value: (item) => Container(
                  padding: const EdgeInsets.all(4),
                  child: Text(item.toString().toUpperCase(), 
                  style: Theme.of(context).textTheme.subtitle.copyWith(color: Colors.white),),
                ));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        elevation: 0.1,
        centerTitle: true,
        title: CupertinoSegmentedControl<String>(
          borderColor: Colors.white,
          selectedColor: Colors.white,
          unselectedColor: Colors.black,
          children: segments,
          onValueChanged: (map) => {},
        ),
        actions: <Widget>[
          InkWell(
            child: Icon(Icons.cancel),
            onTap: () => Navigator.pop(context),
          )
        ],
      ),
      body: Container(
          child: GoogleMap(
        initialCameraPosition: _initPosition,
        mapType: MapType.normal,
        markers: _propertyMarkers,
        onMapCreated: (GoogleMapController controller) {
          _mapsController.complete(controller);
        },
      )),
    );
  }
}
