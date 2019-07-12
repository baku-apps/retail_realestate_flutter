import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:retail_realestate_flutter/propertyDetailPage.dart';
import 'package:retail_realestate_flutter/propertyGeneralInfo.dart';

// Contains HTML parsers to generate a Document object
//import 'package:html/dom.dart' as dom; // Contains DOM related classes for extracting data from elements

import 'models/property.dart';
import 'models/propertyDetails.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/scheduler.dart' show timeDilation;

class PropertyListPage extends StatefulWidget {
  PropertyListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PropertyListPageState createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  List<Property> _properties;

  Future<String> loadAsset() async {
    return await rootBundle.loadString('repository/localjoe.json');
  }

  @override
  void initState() {
    super.initState();

    //put this in a service, and load for now just json from asset
    loadAsset().then((jsonString) {
      List<Map<String, dynamic>> d = List.from(json.decode(jsonString));

      setState(() => _properties = d.map((f) => Property.fromJson(f)).toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
      elevation: 0.1,
      centerTitle: true,
      backgroundColor: Colors.black,
      title: Text(widget.title),
      leading: Image.asset(
        "images/logo_appbar.png",
        filterQuality: FilterQuality.high,
        fit: BoxFit.fitWidth,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.list),
          onPressed: () {},
        )
      ],
    );

    return Scaffold(
        appBar: AppBar(
          title: topAppBar,
        ),
        body: ListView.builder(
            shrinkWrap: true,
            itemCount: _properties == null ? 0 : _properties.take(5).length,
            itemBuilder: (context, index) {
              if (_properties == null)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else
                return RetailPropertyItem(property: _properties[index]);
            }));
  }
}

class RetailPropertyItem extends StatelessWidget {
  const RetailPropertyItem({
    Key key,
    @required Property property,
  })  : _property = property,
        super(key: key);

  final Property _property;

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.5; // 1.0 means normal animation speed.

    return InkWell(
        onTap: () => {
              //Navigator.of(context).push(DetailsPageRoute(_property))
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PropertyDetailsPage(
                    propertyDetails: PropertyDetails.fake(_property));
              }))
            },
        child: Container(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    //how to crop and do aspect ration on image (cropping) https://stackoverflow.com/a/44668386
                    alignment: Alignment.center,
                    child: Container(
                        height: 200,
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            ClipRRect(
                                borderRadius: BorderRadius.circular(4.0),
                                child: Hero(
                                    tag: "prop-${_property.id}",
                                    child: CachedNetworkImage(
                                        width: double.infinity,
                                        fit: BoxFit.fitWidth,
                                        imageUrl: _property.photoUrl,
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error)))),
                            Positioned(
                                bottom: 20,
                                left: 0,
                                child: Container(
                                    color: Colors.white.withOpacity(0.8),
                                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                    child: Text(
                                      _property.price,
                                      style:
                                          Theme.of(context).textTheme.subhead,
                                    ))),
                          ],
                        ))),
                const SizedBox(height: 8.0),
                PropertyGeneralInfo(property: _property)
              ],
            )));
  }
}

class DetailsPageRoute extends MaterialPageRoute {
  DetailsPageRoute(Property p)
      : super(
            builder: (context) =>
                PropertyDetailsPage(propertyDetails: PropertyDetails.fake(p)));

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(opacity: animation, child: child);
  }
}
