import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../features/map/presentation/bloc/map_bloc.dart';
import '../features/map/presentation/bloc/map_event.dart';
import '../features/map/presentation/bloc/map_state.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MapBloc()..add(LoadMap()),
      child: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is MapLoaded) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GoogleMap(
                initialCameraPosition: state.cameraPosition,
                mapType: MapType.normal,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: true,
                markers: state.markers,
                onMapCreated: (controller) {},
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
