class DriverModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final String licenseNumber;
  final double rating;
  final int totalTrips;
  final bool isOnline;
  final DateTime createdAt;

  DriverModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.licenseNumber,
    required this.rating,
    required this.totalTrips,
    required this.isOnline,
    required this.createdAt,
  });

  factory DriverModel.fromMap(Map<String, dynamic> map, String id) {
    return DriverModel(
      id: id,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      licenseNumber: map['licenseNumber'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      totalTrips: map['totalTrips'] ?? 0,
      isOnline: map['isOnline'] ?? false,
      createdAt: map['createdAt'] is DateTime
          ? map['createdAt']
          : DateTime.parse(map['createdAt'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'licenseNumber': licenseNumber,
      'rating': rating,
      'totalTrips': totalTrips,
      'isOnline': isOnline,
      'createdAt': createdAt,
    };
  }
}
