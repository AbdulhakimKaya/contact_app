import 'package:contact_app/data/entity/person.dart';

class PersonDaoRepository {
  Future<void> savePerson(String person_name, String person_tel) async {
    print("Save Person: $person_name $person_tel");
  }

  Future<void> updatePerson(
      int person_id, String person_name, String person_tel) async {
    print("Update Person: $person_id - $person_name $person_tel");
  }

  Future<void> deletePerson(int person_id) async {
    print("Person Id: $person_id");
  }

  Future<List<Person>> personsData() async {
    var personsList = <Person>[];
    var p1 = Person(
        person_id: 1, person_name: "Abdulhakim", person_tel: "05301112233");
    var p2 =
        Person(person_id: 2, person_name: "Furkan", person_tel: "05301114455");
    var p3 =
        Person(person_id: 3, person_name: "Ömer", person_tel: "05301116677");

    personsList.add(p1);
    personsList.add(p2);
    personsList.add(p3);

    return personsList;
  }

  Future<List<Person>> searchPerson(String searchText) async {
    var personsList = <Person>[];
    var p1 = Person(
        person_id: 1, person_name: "Abdulhakim", person_tel: "05301112233");
    personsList.add(p1);

    return personsList;
  }
}
