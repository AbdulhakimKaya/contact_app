import 'package:contact_app/data/repo/persondao_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailPageCubit extends Cubit<void> {
  DetailPageCubit():super(0);

  var prepo = PersonDaoRepository();

  Future<void> updatePerson(int person_id, String person_name, String person_tel) async {
    await prepo.updatePerson(person_id, person_name, person_tel);
  }
}