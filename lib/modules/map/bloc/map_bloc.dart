import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_map/domain/use_cases/get_current_location_use_case.dart';
import 'package:flutter_map/domain/use_cases/get_user_markers_use_case.dart';
import 'package:flutter_map/domain/use_cases/save_user_location_markers_use_case.dart';
import 'package:flutter_map/modules/map/bloc/map_event.dart';
import 'package:flutter_map/modules/map/bloc/map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetCurrentLocationUseCase _getCurrentLocationUseCase;
  final GetUserLocationMarkersUseCase _getUserLocationMarkersUseCase;
  final SaveUserLocationMarkersUseCase _saveUserLocationMarkersUseCase;

  MapBloc(
    this._getCurrentLocationUseCase,
    this._getUserLocationMarkersUseCase,
    this._saveUserLocationMarkersUseCase,
  ) : super(const MapState.initial()) {
    on<MapEventFetchMapLocations>(_onMapCreated);
    on<MapEventAddNewLocation>(_onNewLocationAdded);
    on<MapEventRemoveLocation>(_onLocationRemoved);
    on<MapEventRefreshCurrentLocation>(_onRefresh);
  }

  void _onMapCreated(
    MapEventFetchMapLocations event,
    Emitter emit,
  ) async {
    emit(state.loadingState());
    await _fetchMapLocations(emit);
  }

  void _onRefresh(
    MapEventRefreshCurrentLocation event,
    Emitter emit,
  ) async =>
      await _fetchMapLocations(emit);

  Future<void> _fetchMapLocations(Emitter emit) async {
    try {
      final currentLocation = await _getCurrentLocationUseCase.execute();
      final userLocationMakers = await _getUserLocationMarkersUseCase.execute();

      emit(state.validState(currentLocation, userLocationMakers));
    } on Exception catch (ex) {
      emit(state.invalidState(ex));
    }
  }

  void _onNewLocationAdded(
    MapEventAddNewLocation event,
    Emitter emit,
  ) async {
    emit(state.updateMarkers(event.newMarker));

    await _saveUserLocationMarkersUseCase.execute(state.markers);
  }

  void _onLocationRemoved(
    MapEventRemoveLocation event,
    Emitter emit,
  ) async {
    emit(state.removeMarker(event.marker));

    await _saveUserLocationMarkersUseCase.execute(state.markers);
  }
}
