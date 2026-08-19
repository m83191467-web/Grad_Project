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
  });

  factory RouteModel.fromMap(Map<String, dynamic> map, String id) {
    return RouteModel(
      id: id,
      startLocation: map['startLocation'] ?? '',
      endLocation: map['endLocation'] ?? '',
      distance: (map['distance'] ?? 0).toDouble(),
      duration: map['duration'] ?? 0,
      fare: (map['fare'] ?? 0).toDouble(),
      availableSeats: map['availableSeats'] ?? 0,
      driverId: map['driverId'] ?? '',
      departureTime: map['departureTime'] is DateTime
          ? map['departureTime']
          : DateTime.parse(map['departureTime'] ?? DateTime.now().toString()),
      status: map['status'] ?? 'active',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'startLocation': startLocation,
      'endLocation': endLocation,
      'distance': distance,
      'duration': duration,
      'fare': fare,
      'availableSeats': availableSeats,
      'driverId': driverId,
      'departureTime': departureTime,
      'status': status,
    };
  }
}
