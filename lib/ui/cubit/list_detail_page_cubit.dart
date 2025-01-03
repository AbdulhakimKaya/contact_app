import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app/data/entity/person.dart';
import 'package:contact_app/data/repo/persondao_repository.dart';

class ListDetailPageCubit extends Cubit<List<Person>> {
  final String listId;
  final PersonDaoRepository prepo;

  ListDetailPageCubit(this.listId, this.prepo) : super([]) {
    _getPersons();
  }

  void _getPersons() {
    prepo.getPersonsInList(listId).listen((persons) {
      emit(persons);
    });
  }

  Future<void> addPerson(String personId) async {
    try {
      print('ListDetailPageCubit: Adding person $personId to list $listId');
      await prepo.addPersonToList(listId, personId);
      print('ListDetailPageCubit: Person added successfully');
    } catch (e) {
      print('ListDetailPageCubit Error: $e');
      rethrow;
    }
  }

  Future<void> removePerson(String personId) async {
    try {
      await prepo.removePersonFromList(listId, personId);
    } catch (e) {
      print("Kişi listeden çıkarılırken hata: $e");
    }
  }
}