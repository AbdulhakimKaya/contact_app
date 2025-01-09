import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app/data/entity/person.dart';
import 'package:contact_app/data/repo/persondao_repository.dart';

class FavoritesCubit extends Cubit<List<Person>> {
  FavoritesCubit() : super(<Person>[]);

  final prepo = PersonDaoRepository();

  Future<void> getFavorites() async {
    prepo.collectionPerson
        .where('isFavorite', isEqualTo: true)
        .snapshots()
        .listen((event) {
      var personList = <Person>[];

      for (var document in event.docs) {
        var person = Person.fromJson(
          document.data(),
          document.id,
        );
        personList.add(person);
      }

      emit(personList);
    });
  }

  Future<void> toggleFavorite(String personId, bool isFavorite) async {
    await prepo.toggleFavorite(personId, isFavorite);
  }
}
