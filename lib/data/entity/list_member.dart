import 'package:cloud_firestore/cloud_firestore.dart';

class ListMember {
  String id;
  String listId;
  String personId;
  DateTime addedAt;

  ListMember({
    required this.id,
    required this.listId,
    required this.personId,
    required this.addedAt,
  });

  factory ListMember.fromJson(Map<String, dynamic> json, String id) {
    return ListMember(
      id: id,
      listId: json['listId'],
      personId: json['personId'],
      addedAt: (json['addedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'listId': listId,
      'personId': personId,
      'addedAt': FieldValue.serverTimestamp(),
    };
  }
}