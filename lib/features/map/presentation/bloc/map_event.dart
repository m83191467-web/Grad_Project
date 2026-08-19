import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapEvent {}

class LoadMap extends MapEvent {}

class UpdateLocation extends MapEvent {
  final LatLng position;
  UpdateLocation(this.position);
}
