import 'dart:convert';
import 'package:flutter_map/domain/model/marker_location_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapLocationsSource {
  static late SharedPreferences _preferences;
  static const String userMarkersList = 'user_markers_list_5';

  static init() async => _preferences = await SharedPreferences.getInstance();

  Future<List<String>> _getUserLocationMarkers() async {
    return _preferences.getStringList(userMarkersList) ?? [];
  }

  Future saveUserLocationMarkers(List<MarkerLocationModel> userMarkers) async {
    List<String> data = userMarkers.map((e) => jsonEncode(e.toJson())).toList();

    await _preferences.setStringList(userMarkersList, data);
  }

  Future<List<MarkerLocationModel>> getUserLocationMarkers() async {
    List<String> userLocationMarkers = await _getUserLocationMarkers();

    List<MarkerLocationModel> decodedMarkers = userLocationMarkers.map((e) {
      return MarkerLocationModel.fromJson(jsonDecode(e));
    }).toList();

    return decodedMarkers;
  }
}
