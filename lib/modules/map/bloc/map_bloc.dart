import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_map/domain/use_cases/use_cases.dart';
import 'package:flutter_map/modules/map/bloc/map_event.dart';
import 'package:flutter_map/modules/map/bloc/map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetCurrentLocationUseCase _getCurrentLocationUseCase;

  MapBloc(
    this._getCurrentLocationUseCase,
  ) : super(const MapState.initial()) {
    on<MapEventGetLocation>(_onFetchMapCurrentLocation);
  }

  void _onFetchMapCurrentLocation(
    MapEvent event,
    Emitter emit,
  ) async {
    emit(state.loadingState());

    try {
      final currentLocation = await _getCurrentLocationUseCase.execute();

      emit(state.validState(currentLocation));
    } on Exception catch (ex) {
      emit(state.invalidState(ex));
    }
  }
}
