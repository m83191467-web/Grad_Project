import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String name;
  final String phone;
  final String email;
  final String type; // passenger, driver, admin
  final String? avatar;
  final double? rating;
  final DateTime createdAt;

  UserModel({
    required this.uid,
    required this.name,
    required this.phone,
    required this.email,
    required this.type,
    this.avatar,
    this.rating,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    final createdAt = map['createdAt'];

    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      email: map['email'] ?? '',
      type: map['type'] ?? 'passenger',
      avatar: map['avatar'],
      rating: map['rating'] != null ? (map['rating']).toDouble() : null,
      createdAt: createdAt is Timestamp
          ? createdAt.toDate()
          : createdAt is DateTime
          ? createdAt
          : DateTime.tryParse(createdAt?.toString() ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'phone': phone,
      'email': email,
      'type': type,
      'avatar': avatar,
      'rating': rating,
      'createdAt': createdAt,
    };
  }
}
