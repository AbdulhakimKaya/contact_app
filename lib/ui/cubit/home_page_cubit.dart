import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contact_app/data/entity/person.dart';
import 'package:contact_app/data/repo/persondao_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageCubit extends Cubit<List<Person>> {
  HomePageCubit() : super(<Person>[]);

  var collectionPerson = FirebaseFirestore.instance.collection("Person");

  var prepo = PersonDaoRepository();

  Future<void> personsData() async {
    // var list = await prepo.personsData();
    // emit(list);

    // Firebase
    collectionPerson.snapshots().listen((event) {
      var personList = <Person>[];

      var documents = event.docs;
      for (var document in documents) {
        var key = document.id;
        var data = document.data();
        var person = Person.fromJson(data, key);
        personList.add(person);
      }

      emit(personList);
    });
  }

  Future<void> searchPerson(String searchText) async {
    // var list = await prepo.searchPerson(searchText);
    // emit(list);

    // Firebase
    collectionPerson.snapshots().listen((event) {
      var personList = <Person>[];

      var documents = event.docs;
      for (var document in documents) {
        var key = document.id;
        var data = document.data();
        var person = Person.fromJson(data, key);

        if (person.person_name
            .toLowerCase()
            .contains(searchText.toLowerCase())) {
          personList.add(person);
        }
      }

      emit(personList);
    });
  }

  Future<void> deletePerson(String person_id) async {
    await prepo.deletePerson(person_id);
    await personsData();
  }
}
