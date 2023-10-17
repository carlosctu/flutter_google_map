// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marker_location_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkerLocationModel _$MarkerLocationModelFromJson(Map<String, dynamic> json) =>
    MarkerLocationModel(
      id: json['id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      // ignore: deprecated_member_use
      markerColor: BitmapDescriptor.fromJson(json['markerColor'] as Object),
    );

Map<String, dynamic> _$MarkerLocationModelToJson(
        MarkerLocationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'markerColor': instance.markerColor,
    };
