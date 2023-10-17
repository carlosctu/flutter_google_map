import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/modules/map/bloc/map_bloc.dart';
import 'package:flutter_map/modules/map/bloc/map_event.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapFloatingLocationButton extends StatefulWidget {
  final Completer<GoogleMapController> mapController;
  const MapFloatingLocationButton({
    Key? key,
    required this.mapController,
  }) : super(key: key);

  @override
  State<MapFloatingLocationButton> createState() =>
      _MapFloatingLocationButtonState();
}

class _MapFloatingLocationButtonState extends State<MapFloatingLocationButton> {
  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<MapBloc>();
    final state = context.watch<MapBloc>().state;

    return FloatingActionButton(
      backgroundColor: Colors.grey[100],
      child: Icon(
        Icons.gps_fixed,
        color: Colors.black.withOpacity(0.5),
      ),
      onPressed: () async {
        final controller = await widget.mapController.future;

        bloc.add(MapEventRefreshCurrentLocation());

        controller.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: state.position,
              zoom: 15,
            ),
          ),
        );
        setState(() {});
      },
    );
  }
}
