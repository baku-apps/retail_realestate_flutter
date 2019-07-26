
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:retail_realestate_flutter/models/property.dart';
import 'package:retail_realestate_flutter/models/propertyDetails.dart';
import 'package:retail_realestate_flutter/ui/detailView/propertyDetailPage.dart';
import 'package:retail_realestate_flutter/services/propertyService.dart';
import 'package:retail_realestate_flutter/ui/listView/propertyMapsListPage.dart';

import 'propertyListItem.dart';

class PropertyListPage extends StatefulWidget {
  PropertyListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PropertyListPageState createState() => _PropertyListPageState();
}

class _PropertyListPageState extends State<PropertyListPage> {
  List<Property> _properties;

  var propertyService = PropertyService();

  @override
  void initState() {
    super.initState();

    //put this in a service, and load for now just json from asset
    propertyService.fetchPropertiesList().then((properties) {
      setState(() {
        _properties = properties.take(5).toList();
      });
    });
  }

  bool _showList = true;

  void _setShowList(bool showList) => setState(() => _showList = showList);

  @override
  Widget build(BuildContext context) {

    final propertiesMaps = PropertyMapsListPage(properties: _properties);

    final propertiesList = ListView.builder(
        shrinkWrap: true,
        itemCount: _properties == null ? 0 : _properties.length,
        itemBuilder: (context, index) {
          return RetailPropertyItem(property: _properties[index]);
        });

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
      actions: [
        IconButton(icon: Icon(Icons.list), onPressed: () => _setShowList(true)),
        IconButton(icon: Icon(Icons.map), onPressed: () => _setShowList(false))
      ],
    );


    Widget buildPropertyList() {
      if (_properties == null)
        return Center(
          child: CircularProgressIndicator(),
        );
      else
        return IndexedStack(
          index: _showList ? 0 : 1,
          children: <Widget>[propertiesList, propertiesMaps],
        );
    }

    return Scaffold(
        appBar: topAppBar,
        
        body: buildPropertyList());
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
