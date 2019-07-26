import 'dart:async';
import 'dart:ui';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
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

  GlobalKey _mapKey = GlobalKey();
  Completer<GoogleMapController> _mapsController = Completer();
  Property _propertyCardMap;

  Null Function(AnimationStatus status) _statusListener;
  Size _mapSize = Size(0, 0);

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

    WidgetsBinding.instance.addPostFrameCallback(_getSizes);
  }

  //user pub to get size after build https://pub.dartlang.org/packages/after_layout
  _getSizes(_) {
    final RenderBox renderBoxRed = _mapKey.currentContext.findRenderObject();
    _mapSize = renderBoxRed.size;
  }

  Future<void> _goToMarker(double lat, double lng) async {
    final GoogleMapController controller = await _mapsController.future;

    //map screen size
    var mapHeight = _mapSize.height;
    var mapWidth = _mapSize.width;

    //computed the NortEast and SouthWest LatLng bounds of the (visible) map
    var bounds = await controller.getVisibleRegion();
    var neBounds = bounds.northeast;
    var swBounds = bounds.southwest;

    //lat/lng range of screen
    var latRange = (neBounds.latitude - swBounds.latitude).abs();
    var lngRange = (swBounds.longitude - neBounds.longitude).abs();

    //number of pixels in 1 lat/lng (scale)
    var scaleX = mapWidth / latRange;
    var scaleY = mapHeight / lngRange;

    //scroll to target screen coordinates
    var targetX = (mapWidth / 2);
    var targetY = (mapHeight / 4);

    //screen coordinates of maker
    var markerX = (swBounds.longitude - lng).abs() * scaleX;
    var markerY = (neBounds.latitude -lat).abs() * scaleY;

    //scroll by coordinates
    var deltaX = markerX - targetX;
    var deltaY = markerY - targetY;

    await controller.animateCamera(CameraUpdate.scrollBy(deltaX, deltaY));
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
                  setState(() {
                    _propertyCardMap = p;
                    _slideController.forward();
                  });

                  await _goToMarker(p.location[0], p.location[1]);
                },
                consumeTapEvents: true,
                markerId: MarkerId(p.id),
                position: LatLng(p.location[0], p.location[1]));
          }).toSet();

    final propertiesMaps = Container(
        child: Stack(children: <Widget>[
      GoogleMap(
        key: _mapKey,
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

    return propertiesMaps;
  }
}
