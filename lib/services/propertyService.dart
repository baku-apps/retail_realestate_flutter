import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:retail_realestate_flutter/models/property.dart';

class PropertyService {
  Future<String> _loadAsset() async =>
      await rootBundle.loadString('lib/repositories/localjoe.json');

  Future<List<Property>> fetchPropertiesList() async {
    var jsonList = await _loadAsset();
    List<Map<String, dynamic>> dynamicList = List.from(json.decode(jsonList));

    var properties = dynamicList.map((f) => Property.fromJson(f)).toList();

    return properties;
  }
}
