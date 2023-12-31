import 'package:flutter_map/data/data_source/map_locations_source.dart';
import 'package:flutter_map/domain/model/marker_location_model.dart';

class GetUserLocationMarkersUseCase {
  final _preferences = MapLocationsSource();

  Future<List<MarkerLocationModel>> execute() async =>
      _preferences.getUserLocationMarkers();
}
