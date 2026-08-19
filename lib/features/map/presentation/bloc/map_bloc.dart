import 'package:bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_event.dart';
import 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial()) {
    on<LoadMap>(_onLoadMap);
    on<UpdateLocation>(_onUpdateLocation);
  }

  Future<void> _onLoadMap(LoadMap event, Emitter<MapState> emit) async {
    final CameraPosition initialPosition = const CameraPosition(
      target: LatLng(15.5007, 32.5599),
      zoom: 13,
    );

    final markers = <Marker>{
      const Marker(
        markerId: MarkerId('current'),
        position: LatLng(15.5007, 32.5599),
        infoWindow: InfoWindow(title: 'موقعك'),
      ),
    };

    emit(MapLoaded(markers: markers, cameraPosition: initialPosition));
  }

  Future<void> _onUpdateLocation(
    UpdateLocation event,
    Emitter<MapState> emit,
  ) async {
    if (state is MapLoaded) {
      final current = state as MapLoaded;
      final markers = Set<Marker>.from(current.markers)
        ..add(
          Marker(
            markerId: MarkerId(
              'pos_${event.position.latitude}_${event.position.longitude}',
            ),
            position: event.position,
          ),
        );

      emit(MapLoaded(markers: markers, cameraPosition: current.cameraPosition));
    }
  }
}
