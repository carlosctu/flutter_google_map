import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/modules/map/bloc/map_bloc.dart';
import 'package:flutter_map/modules/map/bloc/map_event.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapBody extends StatelessWidget {
  final Completer<GoogleMapController> mapController;
  const MapBody({
    Key? key,
    required this.mapController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<MapBloc>();
    final state = context.watch<MapBloc>().state;

    return GoogleMap(
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      onMapCreated: (controller) => mapController.complete(controller),
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
              final selectedMarker = state.markers
                  .firstWhere((marker) => marker.position == argument);

              return MarkerBottomSheet(
                selectedMarker: selectedMarker,
              );
            },
          ),
        );

        bloc.add(MapEventAddNewLocation(newMarker: newMarker));
      },
    );
  }
}

class MarkerBottomSheet extends StatelessWidget {
  final Marker selectedMarker;

  const MarkerBottomSheet({
    super.key,
    required this.selectedMarker,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<MapBloc>();
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Marker #${selectedMarker.markerId.value.toString()}",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 24),
          Text('Latitude: ${selectedMarker.position.latitude}'),
          const SizedBox(height: 12),
          Text('Longitude: ${selectedMarker.position.longitude}'),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.center,
            child: TextButton(
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.all(
                  const Color(0xffcf4245).withOpacity(0.1),
                ),
              ),
              onPressed: () {
                bloc.add(
                  MapEventRemoveLocation(marker: selectedMarker),
                );

                Navigator.pop(context);
              },
              child: const Text(
                'Remover',
                style: TextStyle(
                  color: Color(0xffcf4245),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
