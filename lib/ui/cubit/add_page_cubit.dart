import 'package:contact_app/data/repo/persondao_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPageCubit extends Cubit<void> {
  final prepo = PersonDaoRepository();

  AddPageCubit() : super(0);

  Future<void> savePerson(String person_name, String person_tel, String? person_image, bool isFavorite) async {
    try {
      await prepo.savePerson(person_name, person_tel, person_image, isFavorite);
      print("Kişi başarıyla kaydedildi.");
    } catch (e) {
      print("Kişi kaydedilemedi: $e");
    }
  }
}
