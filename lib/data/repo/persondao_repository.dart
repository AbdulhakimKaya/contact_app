import 'package:contact_app/data/entity/person.dart';
import 'package:contact_app/sqlite/database_helper.dart';

class PersonDaoRepository {
  Future<void> savePerson(String person_name, String person_tel, String? person_image) async {
    // print("Save Person: $person_name $person_tel");

    var db = await DatabaseHelper.databaseConnection();
    var newPerson = Map<String, dynamic>();
    newPerson["person_name"] = person_name;
    newPerson["person_tel"] = person_tel;
    newPerson["person_image"] = person_image;
    await db.insert("person", newPerson);
  }

  Future<void> updatePerson(
      int person_id, String person_name, String person_tel, String? person_image) async {
    // print("Update Person: $person_id - $person_name $person_tel");

    var db = await DatabaseHelper.databaseConnection();
    var updatedPerson = Map<String, dynamic>();
    updatedPerson["person_name"] = person_name;
    updatedPerson["person_tel"] = person_tel;
    updatedPerson["person_image"] = person_image;
    await db.update("person", updatedPerson, where: "person_id = ?", whereArgs: [person_id]);
  }

  Future<void> deletePerson(int person_id) async {
    // print("Person Id: $person_id");

    var db = await DatabaseHelper.databaseConnection();
    await db.delete("person", where: "person_id = ?", whereArgs: [person_id]);

  }

  Future<List<Person>> personsData() async {
    // var personsList = <Person>[];
    // var p1 = Person(
    //     person_id: 1, person_name: "Abdulhakim", person_tel: "05301112233");
    // var p2 =
    //     Person(person_id: 2, person_name: "Furkan", person_tel: "05301114455");
    // var p3 =
    //     Person(person_id: 3, person_name: "Ömer", person_tel: "05301116677");
    //
    // personsList.add(p1);
    // personsList.add(p2);
    // personsList.add(p3);
    //
    // return personsList;

    var db = await DatabaseHelper.databaseConnection();
    List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM person");
    
    return List.generate(maps.length, (index) {
      var row = maps[index];
      return Person(person_id: row["person_id"], person_name: row["person_name"], person_tel: row["person_tel"], person_image: row["person_image"]);
    });
  }

  Future<List<Person>> searchPerson(String searchText) async {
    // var personsList = <Person>[];
    // var p1 = Person(
    //     person_id: 1, person_name: "Abdulhakim", person_tel: "05301112233");
    // personsList.add(p1);
    //
    // return personsList;

    var db = await DatabaseHelper.databaseConnection();
    List<Map<String, dynamic>> maps = await db.rawQuery("SELECT * FROM person WHERE person_name like '%$searchText%'");

    return List.generate(maps.length, (index) {
      var row = maps[index];
      return Person(person_id: row["person_id"], person_name: row["person_name"], person_tel: row["person_tel"], person_image: row["person_image"]);
    });
  }
}
