import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/modules/map/widgets/map_body.dart';
import 'package:flutter_map/modules/map/widgets/map_floating_location_button.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_map/modules/map/bloc/map_bloc.dart';
import 'package:flutter_map/modules/map/bloc/map_event.dart';
import 'package:flutter_map/modules/map/bloc/map_state.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _mapController = Completer();

  MapBloc get bloc => context.read<MapBloc>();

  @override
  void initState() {
    bloc.add(MapEventFetchMapLocations());
    super.initState();
  }

  @override
  void dispose() {
    _disposeMapController();
    super.dispose();
  }

  Future<void> _disposeMapController() async {
    final GoogleMapController controller = await _mapController.future;
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MapBloc>().state;

    return Scaffold(
      floatingActionButton: state.status == MapPageStatus.done
          ? MapFloatingLocationButton(mapController: _mapController)
          : null,
      body: SafeArea(
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            final status = state.status;

            switch (status) {
              case MapPageStatus.loading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case MapPageStatus.error:
                return Center(
                  child: Text(
                    state.exception.toString(),
                  ),
                );
              case MapPageStatus.done:
                return MapBody(mapController: _mapController);
            }
          },
        ),
      ),
    );
  }
}
