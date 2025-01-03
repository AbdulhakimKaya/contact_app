import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app/data/entity/custom_list.dart';
import 'package:contact_app/data/repo/persondao_repository.dart';

class ListsCubit extends Cubit<List<CustomList>> {
  ListsCubit() : super(<CustomList>[]);

  final prepo = PersonDaoRepository();

  Future<void> getLists() async {
    prepo.collectionLists
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((event) {
      var lists = event.docs.map((doc) =>
          CustomList.fromJson(doc.data(), doc.id)
      ).toList();

      emit(lists);
    });
  }

  Future<void> createList(String name) async {
    await prepo.createList(name);
  }

  Future<void> deleteList(String listId) async {
    await prepo.deleteList(listId);
  }
}
