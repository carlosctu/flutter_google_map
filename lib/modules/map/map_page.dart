import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/modules/map/bloc/map_bloc.dart';
import 'package:flutter_map/modules/map/bloc/map_event.dart';
import 'package:flutter_map/modules/map/bloc/map_state.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController _mapController;

  MapBloc get bloc => context.read<MapBloc>();

  @override
  void initState() {
    bloc.add(MapEventGetLocation());
    super.initState();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MapBloc>().state;
    return Scaffold(
      floatingActionButton: state.status == MapPageStatus.done
          ? FloatingActionButton(
              backgroundColor: Colors.grey[100],
              child: Icon(
                Icons.gps_fixed,
                color: Colors.black.withOpacity(0.5),
              ),
              onPressed: () => _mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                    CameraPosition(target: state.position, zoom: 15)),
              ),
            )
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
                return GoogleMap(
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  onMapCreated: (controller) => _mapController = controller,
                  initialCameraPosition: CameraPosition(
                    target: state.position,
                    zoom: 15,
                  ),
                  onTap: (argument) => print('tapped'),
                );
            }
          },
        ),
      ),
    );
  }
}
