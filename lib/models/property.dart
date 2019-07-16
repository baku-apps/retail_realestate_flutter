import 'package:json_annotation/json_annotation.dart';

part 'property.g.dart';

@JsonSerializable()
class Property {
  //Property();

  factory Property.fromJson(Map<String, dynamic> json) =>
      _$PropertyFromJson(json);
  Map<String, dynamic> toJson() => _$PropertyToJson(this);

  String id;
  String photoUrl;
  String address;
  String city;
  String price;
  List<double> location = List<double>(2);


  Property({
    this.id,
    this.photoUrl,
    this.address,
    this.city,
    this.price,
    this.location,
  });
}
