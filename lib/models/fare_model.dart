import 'package:equatable/equatable.dart';

class FareModel extends Equatable {
  final String id;
  final String routeId;
  final double basePrice;
  final double pricePerKm;
  final double peakHourMultiplier;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FareModel({
    required this.id,
    required this.routeId,
    required this.basePrice,
    required this.pricePerKm,
    required this.peakHourMultiplier,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'routeId': routeId,
      'basePrice': basePrice,
      'pricePerKm': pricePerKm,
      'peakHourMultiplier': peakHourMultiplier,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory FareModel.fromJson(Map<String, dynamic> json) {
    return FareModel(
      id: json['id'] ?? '',
      routeId: json['routeId'] ?? '',
      basePrice: (json['basePrice'] ?? 0.0).toDouble(),
      pricePerKm: (json['pricePerKm'] ?? 0.0).toDouble(),
      peakHourMultiplier: (json['peakHourMultiplier'] ?? 1.0).toDouble(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  /// Create a copy with modified fields
  FareModel copyWith({
    String? id,
    String? routeId,
    double? basePrice,
    double? pricePerKm,
    double? peakHourMultiplier,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FareModel(
      id: id ?? this.id,
      routeId: routeId ?? this.routeId,
      basePrice: basePrice ?? this.basePrice,
      pricePerKm: pricePerKm ?? this.pricePerKm,
      peakHourMultiplier: peakHourMultiplier ?? this.peakHourMultiplier,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    routeId,
    basePrice,
    pricePerKm,
    peakHourMultiplier,
    createdAt,
    updatedAt,
  ];
}
