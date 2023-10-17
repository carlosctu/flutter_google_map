import 'package:flutter_map/data/data_source/map_locations_source.dart';
import 'package:flutter_map/domain/model/marker_location_model.dart';

class SaveUserLocationMarkersUseCase {
  final _preferences = MapLocationsSource();

  Future<void> execute(List<MarkerLocationModel> userMarkers) async =>
      _preferences.saveUserLocationMarkers(userMarkers);
}
