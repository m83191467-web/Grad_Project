class TripModel {
  final String id;
  final String passengerId;
  final String routeId;
  final String driverId;
  final DateTime tripDate;
  final double fareAmount;
  final String status; // pending, completed, cancelled
  final DateTime createdAt;
  final String? paymentMethod;
  final double? rating;

  TripModel({
    required this.id,
    required this.passengerId,
    required this.routeId,
    required this.driverId,
    required this.tripDate,
    required this.fareAmount,
    required this.status,
    required this.createdAt,
    this.paymentMethod,
    this.rating,
  });

  factory TripModel.fromMap(Map<String, dynamic> map, String id) {
    return TripModel(
      id: id,
      passengerId: map['passengerId'] ?? '',
      routeId: map['routeId'] ?? '',
      driverId: map['driverId'] ?? '',
      tripDate: map['tripDate'] is DateTime
          ? map['tripDate']
          : DateTime.parse(map['tripDate'] ?? DateTime.now().toString()),
      fareAmount: (map['fareAmount'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
      createdAt: map['createdAt'] is DateTime
          ? map['createdAt']
          : DateTime.parse(map['createdAt'] ?? DateTime.now().toString()),
      paymentMethod: map['paymentMethod'],
      rating: map['rating'] != null ? (map['rating']).toDouble() : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'passengerId': passengerId,
      'routeId': routeId,
      'driverId': driverId,
      'tripDate': tripDate,
      'fareAmount': fareAmount,
      'status': status,
      'createdAt': createdAt,
      'paymentMethod': paymentMethod,
      'rating': rating,
    };
  }
}
