import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:retail_realestate_flutter/propertyDetailPage.dart';
import 'package:retail_realestate_flutter/propertyGeneralInfo.dart';

import 'models/property.dart';
import 'models/propertyDetails.dart';

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
              //Navigator.of(context).push(DetailsPageRoute(_property))
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PropertyDetailsPage(
                    propertyDetails: PropertyDetails.fake(_property));
              }))
            },
        child: Container(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 8.0),
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
                                child:
                                    // Hero(
                                    //     tag: "prop-${_property.id}",
                                    //     child:
                                    CachedNetworkImage(
                                        width: double.infinity,
                                        fit: BoxFit.fitWidth,
                                        imageUrl: _property.photoUrl,
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error))
                                // )
                                ),
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
