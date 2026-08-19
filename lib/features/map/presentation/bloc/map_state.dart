import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapState {}

class MapInitial extends MapState {}

class MapLoaded extends MapState {
  final Set<Marker> markers;
  final CameraPosition cameraPosition;

  MapLoaded({required this.markers, required this.cameraPosition});
}
