import 'package:flutter_map/domain/model/marker_location_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum MapPageStatus { done, loading, error }

class MapState {
  final MapPageStatus status;
  final Exception? exception;
  final LatLng position;
  final List<MarkerLocationModel> markers;

  const MapState._({
    this.status = MapPageStatus.loading,
    this.exception,
    this.position = const LatLng(0, 0),
    this.markers = const [],
  });

  const MapState.initial() : this._();

  MapState loadingState() => copyWith(status: MapPageStatus.loading);

  MapState validState(
      LatLng currentPosition, List<MarkerLocationModel> markers) {
    // Adding this new list, because cannot add
    // an unmodifiable list
    List<MarkerLocationModel> markersList = [];

    final currentPositionMarker = MarkerLocationModel(
      id: 'origin',
      latitude: currentPosition.latitude,
      longitude: currentPosition.longitude,
      markerColor: BitmapDescriptor.defaultMarker,
    );

    if (markers.isNotEmpty) {
      markersList.addAll(markers);
      markersList.first = currentPositionMarker;
    } else {
      markersList.add(currentPositionMarker);
    }

    return copyWith(
      status: MapPageStatus.done,
      position: currentPosition,
      markers: markersList,
    );
  }

  MapState invalidState(Exception? ex) => copyWith(
        status: MapPageStatus.error,
        exception: ex,
      );

  MapState updateMarkers(Marker newMarker) {
    markers.add(
      MarkerLocationModel(
        id: newMarker.markerId.value,
        latitude: newMarker.position.latitude,
        longitude: newMarker.position.longitude,
        markerColor: newMarker.icon,
      ),
    );
    return copyWith(markers: markers);
  }

  MapState removeMarker(MarkerLocationModel marker) {
    markers.removeWhere((e) => e.id == marker.id);
    return copyWith(markers: markers);
  }

  MapState getMarkers() {
    return copyWith(markers: markers);
  }

  MapState copyWith({
    MapPageStatus? status,
    Exception? exception,
    LatLng? position,
    List<MarkerLocationModel>? markers,
  }) {
    return MapState._(
      status: status ?? this.status,
      exception: exception ?? this.exception,
      position: position ?? this.position,
      markers: markers ?? this.markers,
    );
  }
}
