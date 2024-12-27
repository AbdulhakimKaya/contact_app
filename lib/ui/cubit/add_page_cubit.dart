import 'package:contact_app/data/repo/persondao_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPageCubit extends Cubit<void>{
  AddPageCubit():super(0);

  var prepo = PersonDaoRepository();

  Future<void> savePerson(String person_name, String person_tel, String person_image) async {
    await prepo.savePerson(person_name, person_tel, person_image);
  }
}