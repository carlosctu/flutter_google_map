import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';

part 'marker_location_model.g.dart';

@JsonSerializable()
class MarkerLocationModel {
  final String id;
  final double latitude;
  final double longitude;
  final BitmapDescriptor markerColor;

  const MarkerLocationModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.markerColor,
  });

  factory MarkerLocationModel.fromJson(Map<String, dynamic> json) =>
      _$MarkerLocationModelFromJson(json);
  Map<String, dynamic> toJson() => _$MarkerLocationModelToJson(this);
}
