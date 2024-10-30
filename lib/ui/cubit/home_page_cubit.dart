import 'package:contact_app/data/entity/person.dart';
import 'package:contact_app/data/repo/persondao_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePageCubit extends Cubit<List<Person>> {
  HomePageCubit():super(<Person>[]);

  var prepo = PersonDaoRepository();

  Future<void> personsData() async {
    var list = await prepo.personsData();
    emit(list);
  }

  Future<void> searchPerson(String searchText) async {
    var list = await prepo.searchPerson(searchText);
    emit(list);
  }

  Future<void> deletePerson(int person_id) async {
    await prepo.deletePerson(person_id);
    await personsData();
  }
}