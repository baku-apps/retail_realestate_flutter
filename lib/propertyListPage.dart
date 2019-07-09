import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:retail_realestate_flutter/propertyDetailPage.dart';
import 'package:retail_realestate_flutter/propertyDetailWebviewPage.dart';
import 'package:retail_realestate_flutter/propertyGeneralInfo.dart';
import 'package:http/http.dart' as http;

import 'package:html/parser.dart'; // Contains HTML parsers to generate a Document object
//import 'package:html/dom.dart' as dom; // Contains DOM related classes for extracting data from elements

import 'models/property.dart';
import 'models/propertyDetails.dart';
import 'package:flutter/services.dart' show rootBundle;

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
                return new RetailPropertyItem(property: _properties[index]);
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
    return InkWell(
        onTap: () => {
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
                            // Container(
                            //   width: double.infinity,
                            //   height: 300,
                            //   decoration: BoxDecoration(
                            //     image: DecorationImage(
                            //       image: NetworkImage(
                            //           _properties[index].photoUrl),
                            //       fit: BoxFit.fitWidth,
                            //     ),
                            //   ),
                            // ),
                            new ClipRRect(
                                borderRadius: new BorderRadius.circular(4.0),
                                child: CachedNetworkImage(
                                  width: double.infinity,
                                  fit: BoxFit.fitWidth,
                                  imageUrl: _property.photoUrl,
                                  placeholder: (context, url) =>
                                      new CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      new Icon(Icons.error),
                                )),
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
