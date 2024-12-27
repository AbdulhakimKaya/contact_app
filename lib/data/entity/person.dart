class Person {
  // int person_id;
  String person_id;
  String person_name;
  String person_tel;
  String? person_image;

  Person({required this.person_id, required this.person_name, required this.person_tel, this.person_image});

  factory Person.fromJson(Map<dynamic, dynamic> json, String key) {
    return Person(person_id: key, person_name: json["person_name"], person_tel: json["person_tel"], person_image: json["person_image"]);
  }
}