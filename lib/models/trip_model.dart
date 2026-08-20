import 'package:cloud_firestore/cloud_firestore.dart';

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
      passengerId: _stringFrom(map['passengerId']),
      routeId: _stringFrom(map['routeId']),
      driverId: _stringFrom(map['driverId']),
      tripDate: _dateFrom(map['tripDate']),
      fareAmount: _doubleFrom(map['fareAmount']),
      status: _stringFrom(map['status'], fallback: 'pending'),
      createdAt: _dateFrom(map['createdAt']),
      paymentMethod: map['paymentMethod'] == null
          ? null
          : _stringFrom(map['paymentMethod']),
      rating: map['rating'] == null ? null : _doubleFrom(map['rating']),
    );
  }

  static String _stringFrom(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;
    return value is String ? value : value.toString();
  }

  static double _doubleFrom(dynamic value, {double fallback = 0}) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static DateTime _dateFrom(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.toInt());
    }
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
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
