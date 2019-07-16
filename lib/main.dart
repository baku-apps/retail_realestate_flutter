import 'package:flutter/material.dart';
import 'package:retail_realestate_flutter/propertyListPage.dart';

import 'propertyMapsListPage.dart';

void main() => {runApp(RetailRealestateApp())};

class RetailRealestateApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(primaryColor: Color.fromRGBO(0, 0, 0, 1.0)),
      home: PropertyListPage(title: 'Aanbod'),
      //home: PropertyMapsListPage(),
    );
  }
}
