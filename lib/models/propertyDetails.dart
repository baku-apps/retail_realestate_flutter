import 'package:retail_realestate_flutter/models/property.dart';

class PropertyDetails {
  PropertyDetails();

  String id;
  String description;
  List<String> images;
  Property general;

  PropertyFeatures features;

  Map<String, Map<String, String>> featuresMap;

  factory PropertyDetails.fake(Property property) {
    var details = PropertyDetails();

    details.general = property;

    details.id = "1";
    details.description =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris varius maximus enim. Nullam a massa dapibus, aliquam sem vel, tempus mauris. Aliquam in odio dolor. Ut imperdiet, dolor nec semper feugiat, nulla ipsum blandit velit, et scelerisque velit arcu id tellus. Proin quis scelerisque nunc. Donec aliquam lorem sit amet enim rhoncus, posuere pellentesque est sagittis. Maecenas sem orci, condimentum eget tellus eu, semper malesuada arcu. Vestibulum faucibus est lectus, a luctus orci laoreet at. Duis ullamcorper consectetur libero.";

    details.images = [
      "https://www.jasna.sk/fileadmin/_processed_/csm_Shopy_20.7.201700029__1024x683__d5779f6291.jpg",
      "https://www.tenovuscancercare.org.uk/media/372112/blue-shop-front-small-use-only.jpg",
      "https://i1.wp.com/fitzvillafuerte.com/wp-content/uploads/2017/02/sari-sari-store-tips.jpg?fit=484%2C252&ssl=1"
    ].toList();

    details.features = PropertyFeatures(
        status: "Beschikbaar",
        delivery: "In overleg",
        purpose: "Winkelruimte",
        constructionType: "Bestaande bouw",
        buildYear: 1978,
        totalArea: 200,
        floorArea: 100,
        salesArea: 150,
        storys: 0,
        location: "Centrum");

    details.featuresMap = details._toDictionary(details);

    return details;
  }

  Map<String, Map<String, String>> _toDictionary(PropertyDetails details) {
    var featureMap = {
      'Overdracht': {
        'Prijs': details.general.price.toString(),
        'Status': details.features.status,
        'Oplevering': details.features.delivery
      },
      'Bouw': {
        'Bouwjaar': details.features.buildYear.toString(),
        'Hoofdbestemming': details.features.purpose,
        'Soort bouw': details.features.constructionType
      },
      'Oppervlakte': {
        'Totaaloppervakte': details.features.totalArea.toString() + 'm2',
        'Vloeroppervakte': details.features.floorArea.toString() + 'm2',
        'Verkoopoppervakte': details.features.salesArea.toString() + 'm2',
      },
      'Indeling': {'Verdiepingen': details.features.storys.toString() + ' verdiepingen'},
      'Omgeving': {'Ligging': details.features.location}
    };
    return featureMap;
  }
}

class PropertyFeatures {
  String status;
  String delivery;
  String purpose;
  String constructionType;
  int buildYear;

  int totalArea;
  int floorArea;
  int salesArea;

  int storys;

  String location;

  Map<String, Map<String, String>> toDictionary(PropertyDetails details) {
    Map<String, Map<String, String>> featureMap;

    featureMap["Overdracht"].addAll({
      'Prijs': details.general.price.toString(),
      'Status': details.features.status,
      'Oplevering': details.features.delivery
    });

    featureMap["Bouw"].addAll({
      'Bouwjaar': details.features.buildYear.toString(),
      'Hoofdbestemming': details.features.purpose,
      'Soort bouw': details.features.constructionType
    });

    featureMap["Oppervlakte"].addAll({
      'Totaaloppervakte': details.features.totalArea.toString() + 'm2',
      'Vloeroppervakte': details.features.floorArea.toString() + 'm2',
      'Verkoopoppervakte': details.features.salesArea.toString() + 'm2',
    });

    featureMap["Indeling"]
        .addAll({'Verdiepingen': details.features.toString()});

    featureMap["Omgeving"].addAll({'Ligging': details.features.location});

    return featureMap;
  }

  PropertyFeatures(
      {this.status,
      this.delivery,
      this.purpose,
      this.constructionType,
      this.buildYear,
      this.totalArea,
      this.floorArea,
      this.salesArea,
      this.storys,
      this.location});
}
