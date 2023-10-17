import 'package:google_maps_flutter/google_maps_flutter.dart';

enum MapPageStatus { done, loading, error }

class MapState {
  final MapPageStatus status;
  final Exception? exception;
  final LatLng position;
  final List<Marker> markers;

  const MapState._({
    this.status = MapPageStatus.loading,
    this.exception,
    this.position = const LatLng(0, 0),
    this.markers = const [],
  });

  const MapState.initial() : this._();

  MapState loadingState() => copyWith(status: MapPageStatus.loading);

  MapState validState(LatLng currentPosition, List<Marker> markers) {
    // Adding this new list, because cannot add
    // an unmodifiable list
    List<Marker> markersList = [];

    final currentPositionMarker = Marker(
      markerId: const MarkerId('origin'),
      position: currentPosition,
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
    markers.add(newMarker);
    return copyWith(markers: markers);
  }

  MapState removeMarker(Marker marker) {
    markers.removeWhere((e) => e.markerId == marker.markerId);
    return copyWith(markers: markers);
  }

  MapState getMarkers() {
    return copyWith(markers: markers);
  }

  MapState copyWith({
    MapPageStatus? status,
    Exception? exception,
    LatLng? position,
    List<Marker>? markers,
  }) {
    return MapState._(
      status: status ?? this.status,
      exception: exception ?? this.exception,
      position: position ?? this.position,
      markers: markers ?? this.markers,
    );
  }
}
