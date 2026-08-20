import 'package:cloud_firestore/cloud_firestore.dart';

class RouteModel {
  final String id;
  final String startLocation;
  final String endLocation;
  final double distance;
  final int duration; // in minutes
  final double fare;
  final int availableSeats;
  final String driverId;
  final DateTime departureTime;
  final String status; // active, completed, cancelled
  final GeoPoint? location;

  RouteModel({
    required this.id,
    required this.startLocation,
    required this.endLocation,
    required this.distance,
    required this.duration,
    required this.fare,
    required this.availableSeats,
    required this.driverId,
    required this.departureTime,
    required this.status,
    this.location,
  });

  factory RouteModel.fromMap(Map<String, dynamic> map, String id) {
    final departure = map['departureTime'];
    final parsedDeparture = departure is Timestamp
        ? departure.toDate()
        : departure is DateTime
        ? departure
        : DateTime.tryParse(departure?.toString() ?? '') ?? DateTime.now();

    return RouteModel(
      id: id,
      startLocation:
          (map['startLocation'] ?? map['startPoint'])?.toString() ?? '',
      endLocation: (map['endLocation'] ?? map['destination'])?.toString() ?? '',
      distance: _asDouble(map['distance']),
      duration: _asInt(map['duration']),
      fare: _asDouble(map['fare']),
      availableSeats: _asInt(map['availableSeats']),
      driverId: map['driverId']?.toString() ?? '',
      departureTime: parsedDeparture,
      status: map['status']?.toString() ?? 'active',
      location: _asGeoPoint(map['location']),
    );
  }

  static double _asDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0;
  }

  static int _asInt(dynamic value) {
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static GeoPoint? _asGeoPoint(dynamic value) {
    if (value is GeoPoint) return value;
    if (value is Map) {
      final latitude = _asDouble(value['latitude'] ?? value['lat']);
      final longitude = _asDouble(value['longitude'] ?? value['lng']);
      if (latitude != 0 || longitude != 0) {
        return GeoPoint(latitude, longitude);
      }
    }
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'startLocation': startLocation,
      'endLocation': endLocation,
      'startPoint': startLocation,
      'destination': endLocation,
      'distance': distance,
      'duration': duration,
      'fare': fare,
      'availableSeats': availableSeats,
      'driverId': driverId,
      'departureTime': departureTime,
      'status': status,
      if (location != null) 'location': location,
    };
  }
}
