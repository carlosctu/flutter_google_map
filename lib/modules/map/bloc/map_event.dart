import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapEvent {}

class MapEventFetchMapLocations extends MapEvent {}

class MapEventRefreshCurrentLocation extends MapEvent {}

class MapEventAddNewLocation extends MapEvent {
  final Marker newMarker;
  MapEventAddNewLocation({
    required this.newMarker,
  });
}

class MapEventRemoveLocation extends MapEvent {
  final Marker marker;
  MapEventRemoveLocation({
    required this.marker,
  });
}
