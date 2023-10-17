import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/domain/use_cases/get_current_location_use_case.dart';
import 'package:flutter_map/modules/map/bloc/map_bloc.dart';
import 'package:flutter_map/modules/map/map_page.dart';

void main() {
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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MapBloc>(
            create: (context) => MapBloc(
              context.read<GetCurrentLocationUseCase>(),
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
