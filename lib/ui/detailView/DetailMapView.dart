import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:retail_realestate_flutter/models/propertyDetails.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum MapSegments { map, satelliet, streetView }

class DetailMapsView extends StatefulWidget {
  DetailMapsView({Key key, this.property}) : super(key: key);

  final PropertyDetails property;

  _DetailMapsViewState createState() => _DetailMapsViewState();
}

class _DetailMapsViewState extends State<DetailMapsView> {
  final Completer<GoogleMapController> _mapsController =
      Completer<GoogleMapController>();
  final Completer<WebViewController> _webViewController =
      Completer<WebViewController>();

  final Map<MapSegments, String> segmentsMap = {
    MapSegments.map: "Kaart",
    MapSegments.satelliet: "Sattelite",
    MapSegments.streetView: "Steet View"
  };

  MapType _currentMapType = MapType.normal;
  int _mapStackIndex = 0;
  int _segmentSelectedIndex = 0;

  String _panoId;

  Future<String> getPanoId(double lat, double lng) async {
    var response = await http.get(
        'https://maps.googleapis.com/maps/api/streetview/metadata?location=$lat,$lng&size=400x600&key=API_KEY');

    if (response.statusCode == 200) {
      var pId = json.decode(response.body)['pano_id'];
      return pId;
    } else {
      return "";
      // handle a failed request
    }
  }

  List<double> _location = List<double>(2);

  @override
  void initState() {
    _location = {
      widget.property.general.location[0],
      widget.property.general.location[1]
    }.toList();

    //getPanoId(_location[0], _location[1]).then((panoId) => _panoId = panoId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final CameraPosition _initPosition = CameraPosition(
      target: LatLng(_location[0], _location[1]),
      zoom: 12.73,
    );

    // String _streetViewUrl =
    //     'https://maps.googleapis.com/maps/api/streetview' +
    //         //"?size=${_mapsSize.width.round()}x${_mapsSize.height.round()}" +
    //         "?size=400x600" +
    //         "&location=${location[0]},${location[1]}" +
    //         '&heading=151.78' +
    //         '&pitch=-0.76' +
    //         '&source=outdoor' +
    //         '&map_action=pano' +
    //         '&key=$apiKey';
    // //'&signature=YOUR_SIGNATURE';
    //TODO: add ApiKey for google later
    String _streetViewUrl = 'https://www.google.com/maps/@' +
        '?api=1' +
        '&map_action=pano' +
        '&viewpoint=${_location[0]},${_location[1]}'
            //'&viewpoint=52.1587819,4.4884253'
            '&pano=$_panoId'
            '&heading=151.78' +
        '&pitch=-0.76' +
        '&source=outdoor';
    //'&key=$apiKey';
    //'&signature=YOUR_SIGNATURE';

    Set<Marker> _propertyMarkers = {
      Marker(
          consumeTapEvents: true,
          markerId: MarkerId(widget.property.id),
          position: LatLng(_location[0], _location[1]))
    }.toSet();

    final segments = Map<String, Widget>.fromIterables(
        segmentsMap.keys.map((f) => f.toString()),
        List<Widget>.generate(segmentsMap.values.length, (index) {
          return Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(4),
            child: Text(
              segmentsMap.values.toList()[index].toString().toUpperCase(),
              style: Theme.of(context).textTheme.subtitle.copyWith(
                  color: (_segmentSelectedIndex == index)
                      ? Colors.black
                      : Colors.white),
            ),
          );
        }));

    final streetView = WebView(
      initialUrl: _streetViewUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController controller) =>
          _webViewController.complete(controller),
    );

    final googleMap = GoogleMap(
      initialCameraPosition: _initPosition,
      mapType: _currentMapType,
      markers: _propertyMarkers,
      onMapCreated: (GoogleMapController controller) {
        _mapsController.complete(controller);
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        elevation: 0.1,
        centerTitle: true,
        title: CupertinoSegmentedControl<String>(
          borderColor: Colors.white,
          selectedColor: Color(0xFFFFD500),
          unselectedColor: Colors.black,
          pressedColor: Colors.orange[200],
          children: segments,
          groupValue:
              (MapSegments.values.toList())[_segmentSelectedIndex].toString(),
          onValueChanged: (selected) {
            _segmentSelectedIndex = MapSegments.values
                .map((f) => f.toString())
                .toList()
                .indexOf(selected);

            setState(() {
              if (selected == MapSegments.map.toString()) {
                _currentMapType = MapType.normal;
                _mapStackIndex = 0;
              } else if (selected == MapSegments.satelliet.toString()) {
                _currentMapType = MapType.satellite;
                _mapStackIndex = 0;
              } else if (selected == MapSegments.streetView.toString()) {
                _mapStackIndex = 1;
              } else {
                //throw erro
              }
            });
          },
        ),
        actions: <Widget>[
          InkWell(
            child: Icon(Icons.cancel),
            onTap: () => Navigator.pop(context),
          )
        ],
      ),
      body: Container(
          child: IndexedStack(
        index: _mapStackIndex,
        alignment: AlignmentDirectional.center,
        children: <Widget>[googleMap, streetView],
      )),
    );
  }
}
