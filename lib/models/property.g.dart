// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'property.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Property _$PropertyFromJson(Map<String, dynamic> json) {
  return Property(
      id: json['id'] as String,
      photoUrl: json['photoUrl'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      price: json['price'] as String);
}

Map<String, dynamic> _$PropertyToJson(Property instance) => <String, dynamic>{
      'id': instance.id,
      'photoUrl': instance.photoUrl,
      'address': instance.address,
      'city': instance.city,
      'price': instance.price
    };
