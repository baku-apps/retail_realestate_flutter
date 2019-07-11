import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:retail_realestate_flutter/models/propertyDetails.dart';
import 'package:retail_realestate_flutter/propertyGeneralInfo.dart';
import 'package:carousel_slider/carousel_slider.dart';

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

    _makeImageCarousel(List<String> images) => CarouselSlider(
          viewportFraction: 1.0,
          height: MediaQuery.of(context).size.height * 0.33,
          items: images.map((i) {
            return Builder(builder: (BuildContext context) {
              return Container(
                color: Colors.grey[300],
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: i,
                  fit: BoxFit.fitHeight,
                  placeholder: (context, i) => Icon(
                        Icons.broken_image,
                        size: 64,
                      ),
                  errorWidget: (context, i, error) => new Icon(Icons.error),
                ),
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
          _makeImageCarousel(propertyDetails.images),
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
                // mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Kenmerken",
                    style: Theme.of(context).textTheme.headline, 
                  ),
                  const SizedBox(height: 8.0),
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
        ]),
      ),
    );
  }
}
