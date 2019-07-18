import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:retail_realestate_flutter/models/property.dart';
import 'package:retail_realestate_flutter/propertyListItem.dart';
import 'package:rxdart/rxdart.dart';

class PropertyMapsListPage extends StatefulWidget {
  PropertyMapsListPage({Key key, this.properties}) : super(key: key);

  final List<Property> properties;

  _PropertyMapsListPageState createState() => _PropertyMapsListPageState();
}

class _PropertyMapsListPageState extends State<PropertyMapsListPage>
    with SingleTickerProviderStateMixin {
  AnimationController _slideController;
  Animation<Offset> _animation;

  Completer<GoogleMapController> _mapsController = Completer();
  Property _propertyCardMap;

  Null Function(AnimationStatus status) _statusListener;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 250),
        reverseDuration: const Duration(milliseconds: 150));

    Animation curve = CurvedAnimation(
      parent: _slideController,
      curve: Curves.fastOutSlowIn,
    );

    _animation =
        Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero).animate(curve);

    _statusListener = (status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          _propertyCardMap = null;
        });
      }
    };

    _slideController.addStatusListener(_statusListener);

    onTapMarkerSubject.stream
        .switchMap((p) => Observable.fromFuture(_goToMarkerDelegate()))
        .listen((property) {
      print("Updated maps camera!");
    });
  }

  PublishSubject<Property> onTapMarkerSubject = PublishSubject<Property>();
  int i = 0;

  Future<void> Function() _goToMarkerDelegate;

  Future<void> _goToMarker(double dx, double dy) async {
    final GoogleMapController controller = await _mapsController.future;

    var scrollX = dx - (MediaQuery.of(context).size.width / 2);
    var scrollY = dy - (MediaQuery.of(context).size.height / 4);

    await controller.animateCamera(CameraUpdate.scrollBy(scrollX, scrollY));
  }

  @override
  Widget build(BuildContext context) {
    final CameraPosition _initPosition = CameraPosition(
      target: LatLng(52.0690814, 4.2777256),
      zoom: 12.73,
    );

    Set<Marker> _propertyMarkers = widget.properties == null
        ? Set<Marker>()
        : widget.properties.map((p) {
            return Marker(
                onTap: () async {
                  print("${i++}: MARKER");

                  setState(() {
                    _propertyCardMap = p;
                    _slideController.forward();
                  });
                  //await Future.delayed(Duration(milliseconds: 500));
                  onTapMarkerSubject.add(p);
                },
                consumeTapEvents: true,
                markerId: MarkerId(p.id),
                position: LatLng(p.location[0], p.location[1]));
          }).toSet();

    final propertiesMaps = Container(
        child: Stack(children: <Widget>[
      GoogleMap(
          onTap: (latLang) => setState(() {
                _slideController.reverse();
              }),
          markers: _propertyMarkers,
          onMapCreated: (GoogleMapController controller) {
            _mapsController.complete(controller);
          },
          mapType: MapType.normal,
          initialCameraPosition: _initPosition),
      Positioned(
          bottom: 35.0,
          left: 0.0,
          right: 0.0,
          child: SlideTransition(
            position: _animation,
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: (_propertyCardMap != null)
                  ? RetailPropertyItem(property: _propertyCardMap)
                  : Container(),
            ),
          )),
    ]));

    return GestureDetector(
        onTapDown: (details) {
          // var newOffset = Offset.fromDirection(
          //     details.localPosition.direction, details.localPosition.distance);
          // localX = newOffset.dx;
          // localY = newOffset.dy;

          var dx = details.globalPosition.dx;
          var dy = details.globalPosition.dy;

          _goToMarkerDelegate = () async => await _goToMarker(
              details.localPosition.dx, details.localPosition.dy);

          print("${i++}: GESTUREDETECTOR --> $dx - $dy");
        },
        child: propertiesMaps);
  }
}
