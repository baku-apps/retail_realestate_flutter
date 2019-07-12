import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:retail_realestate_flutter/helpers/mapHelpers.dart';
import 'package:retail_realestate_flutter/models/propertyDetails.dart';
import 'package:retail_realestate_flutter/propertyGeneralInfo.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'ExpandableWidget.dart';

class PropertyDetailsPage extends StatelessWidget {
  final PropertyDetails propertyDetails;
  const PropertyDetailsPage({Key key, this.propertyDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      centerTitle: true,
      title: Text("Details"),
      actions: <Widget>[],
      elevation: 0.1,
      backgroundColor: Colors.black,
    );

    Container _makeDivider(EdgeInsetsGeometry pad) => Container(
          padding: pad,
          child: Divider(
            color: Colors.grey[150],
            height: 1.0,
          ),
        );

    _makeImageCarousel(PropertyDetails details) => CarouselSlider(
          viewportFraction: 1.0,
          height: MediaQuery.of(context).size.height * 0.40,
          items: details.images.map((url) {
            return Builder(builder: (BuildContext context) {
              return Container(
                color: Colors.grey[300],
                width: double.infinity,
                child: Hero(
                    tag: "prop-${details.general.id}",
                    child: CachedNetworkImage(
                      imageUrl: url,
                      fit: BoxFit.cover,
                      placeholder: (context, i) => Icon(
                        Icons.broken_image,
                        size: 64,
                      ),
                      errorWidget: (context, i, error) => new Icon(Icons.error),
                    )),
              );

              //   return Container(
              //       width: MediaQuery.of(context).size.width,
              //       margin: EdgeInsets.symmetric(horizontal: 5.0),
              //       decoration: BoxDecoration(color: Colors.amber),
              //       child: Text(
              //         'text $i',
              //         style: TextStyle(fontSize: 16.0),
              //       ));
              // },
            });
          }).toList(),
        );

    List<Widget> _makeFeaturesColumns(PropertyDetails details) {
      var featureList = List<Widget>();

      details.featuresMap.forEach((categotyTitle, feature) {
        featureList.add(const SizedBox(height: 4.0));
        featureList
            .add(Text(categotyTitle, style: Theme.of(context).textTheme.title));
        featureList
            .add(_makeDivider(const EdgeInsets.symmetric(vertical: 8.0)));

        feature.forEach((title, value) {
          featureList.add(Text(
            title,
            style: Theme.of(context).textTheme.caption,
          ));
          featureList.add(const SizedBox(height: 8.0));
          featureList.add(Text(
            value,
            style: Theme.of(context).textTheme.body1,
          ));
          featureList
              .add(_makeDivider(const EdgeInsets.symmetric(vertical: 8.0)));
        });
      });

      return featureList;
    }

    return Scaffold(
      appBar: topAppBar,
      body: Container(
        child: ListView(shrinkWrap: true, children: <Widget>[
          _makeImageCarousel(propertyDetails),
          Container(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0),
              child: PropertyGeneralInfo(property: propertyDetails.general)),
          _makeDivider(EdgeInsets.symmetric(vertical: 16.0)),
          Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Omschrijving",
                    style: Theme.of(context).textTheme.headline,
                  ),
                  const SizedBox(height: 4.0),
                  ExapandableWidget(
                      maxHeight: 110.0,
                      expandText: "Lees volledige omschrijving",
                      shrinkText: "Verklein omschrijving",
                      child: Text(
                        propertyDetails.description,
                        overflow: TextOverflow.fade,
                        softWrap: true,
                        style: Theme.of(context).textTheme.body1,
                        textAlign: TextAlign.justify,
                      ))
                ],
              )),
          _makeDivider(EdgeInsets.symmetric(vertical: 8.0)),
          Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Kenmerken",
                    style: Theme.of(context).textTheme.headline,
                  ),
                  const SizedBox(height: 8.0),
                  //TODO: use StatefulBuilder Widget to only update the expansion/shrinking
                  ExapandableWidget(
                    maxHeight: 115.0,
                    expandText: "Bekijk alle kenmerken",
                    shrinkText: "Minder kenmerken",
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _makeFeaturesColumns(propertyDetails),
                    ),
                  ),
                ],
              )),
          _makeDivider(EdgeInsets.symmetric(vertical: 8.0)),
          Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Kaart",
                      style: Theme.of(context).textTheme.headline,
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      child: GoogleMap(
                        onTap: (loc) => MapHelpers.openMap(
                            propertyDetails.location[0],
                            propertyDetails.location[1]),
                        initialCameraPosition: CameraPosition(
                            target: LatLng(propertyDetails.location[0],
                                propertyDetails.location[1]),
                            zoom: 15),
                        markers: {
                          Marker(
                            consumeTapEvents: true,
                            onTap: () => MapHelpers.openMap(
                                propertyDetails.location[0],
                                propertyDetails.location[1]),
                            markerId: MarkerId(propertyDetails.id),
                            position: LatLng(propertyDetails.location[0],
                                propertyDetails.location[1]),
                            infoWindow: InfoWindow(
                                title: propertyDetails.general.address),
                          )
                        },
                        tiltGesturesEnabled: false,
                        zoomGesturesEnabled: false,
                        scrollGesturesEnabled: false,
                        indoorViewEnabled: false,
                        mapType: MapType.normal,
                      ),
                    ),
                    const SizedBox(height: 25.0),
                  ]))
        ]),
      ),
      bottomNavigationBar: new Container(
          height: 60,
          padding: const EdgeInsets.all(8),
          //color: Colors.grey,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                  color: Colors.black,
                  borderRadius: new BorderRadius.all(Radius.circular(4))),
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(6),
                      color: Colors.black,
                      child: Icon(Icons.phone, color: Colors.yellow),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      alignment: Alignment.center,
                      child: Text("06-123456789",
                          style: Theme.of(context)
                              .textTheme
                              .body2
                              .copyWith(color: Colors.yellow[200], fontSize: 18)),
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                child: Text("Stuur bericht",
                    style: Theme.of(context)
                        .textTheme
                        .body2
                        .copyWith(fontSize: 16, color: Colors.blue[300])),
              )
            ],
          )),
    );
  }
}
