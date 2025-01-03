import 'package:cloud_firestore/cloud_firestore.dart';

class Person {
  String person_id;
  String person_name;
  String person_tel;
  String? person_image;
  bool isFavorite;
  DateTime? createdAt;

  Person({
    required this.person_id,
    required this.person_name,
    required this.person_tel,
    this.person_image,
    this.isFavorite = false,
    this.createdAt,
  });

  factory Person.fromJson(Map<dynamic, dynamic> json, String key) {
    return Person(
      person_id: key,
      person_name: json["person_name"],
      person_tel: json["person_tel"],
      person_image: json["person_image"],
      isFavorite: json["isFavorite"] ?? false,
      createdAt: json["created_at"] != null
          ? (json["created_at"] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "person_name": person_name,
      "person_tel": person_tel,
      "person_image": person_image,
      "isFavorite": isFavorite,
      "created_at": createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}