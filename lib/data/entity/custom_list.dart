import 'package:cloud_firestore/cloud_firestore.dart';

class CustomList {
  String id;
  String name;
  String userId;
  DateTime createdAt;

  CustomList({
    required this.id,
    required this.name,
    required this.userId,
    required this.createdAt,
  });

  factory CustomList.fromJson(Map<String, dynamic> json, String id) {
    return CustomList(
      id: id,
      name: json['name'],
      userId: json['userId'],
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}