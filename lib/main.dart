import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/data/data_source/map_locations_source.dart';
import 'package:flutter_map/domain/use_cases/get_current_location_use_case.dart';
import 'package:flutter_map/domain/use_cases/get_user_markers_use_case.dart';
import 'package:flutter_map/modules/map/bloc/map_bloc.dart';
import 'package:flutter_map/modules/map/map_page.dart';

import 'domain/use_cases/save_user_location_markers_use_case.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MapLocationsSource.init();
  runApp(const FlutterMapApp());
}

class FlutterMapApp extends StatelessWidget {
  const FlutterMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<GetCurrentLocationUseCase>(
          create: (context) => GetCurrentLocationUseCase(),
        ),
        RepositoryProvider<GetUserLocationMarkersUseCase>(
          create: (context) => GetUserLocationMarkersUseCase(),
        ),
        RepositoryProvider<SaveUserLocationMarkersUseCase>(
          create: (context) => SaveUserLocationMarkersUseCase(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MapBloc>(
            create: (context) => MapBloc(
              context.read<GetCurrentLocationUseCase>(),
              context.read<GetUserLocationMarkersUseCase>(),
              context.read<SaveUserLocationMarkersUseCase>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Maps',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const MapPage(),
        ),
      ),
    );
  }
}
