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
    bloc.add(MapEventFetchMapLocations());
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
              onPressed: () {
                bloc.add(MapEventRefreshCurrentLocation());

                _mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: state.position,
                      zoom: 15,
                    ),
                  ),
                );
                setState(() {});
              })
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
                // markers.add(state.originMarker);
                return GoogleMap(
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  onMapCreated: (controller) => _mapController = controller,
                  markers: state.markers.toSet(),
                  initialCameraPosition: CameraPosition(
                    target: state.position,
                    zoom: 15,
                  ),
                  onTap: (argument) {
                    final newMarker = Marker(
                      markerId: MarkerId(state.markers.length.toString()),
                      position: argument,
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue,
                      ),
                      onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          final selectedMarker = state.markers.firstWhere(
                              (marker) => marker.position == argument);

                          return Container(
                            padding: const EdgeInsets.only(
                              bottom: 24,
                              left: 24,
                              right: 24,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  selectedMarker.markerId.toString(),
                                ),
                                Text(
                                  'Latitude: ${selectedMarker.position.latitude}',
                                ),
                                Text(
                                  'Longitude: ${selectedMarker.position.longitude}',
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: TextButton(
                                    onPressed: () {
                                      bloc.add(
                                        MapEventRemoveLocation(
                                            marker: selectedMarker),
                                      );

                                      Navigator.pop(context);
                                    },
                                    child: const Text('Remover'),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    );

                    bloc.add(MapEventAddNewLocation(newMarker: newMarker));
                  },
                );
            }
          },
        ),
      ),
    );
  }
}
