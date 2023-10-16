import 'package:google_maps_flutter/google_maps_flutter.dart';

enum MapPageStatus { done, loading, error }

class MapState {
  final MapPageStatus status;
  final Exception? exception;
  final LatLng position;

  const MapState._({
    this.status = MapPageStatus.loading,
    this.exception,
    this.position = const LatLng(0, 0),
  });

  const MapState.initial() : this._();

  MapState loadingState() => copyWith(status: MapPageStatus.loading);

  MapState validState(LatLng position) => copyWith(
        status: MapPageStatus.done,
        position: position,
      );

  MapState invalidState(Exception? ex) => copyWith(
        status: MapPageStatus.error,
        exception: ex,
      );

  MapState copyWith({
    MapPageStatus? status,
    Exception? exception,
    LatLng? position,
  }) {
    return MapState._(
      status: status ?? this.status,
      exception: exception ?? this.exception,
      position: position ?? this.position,
    );
  }
}
