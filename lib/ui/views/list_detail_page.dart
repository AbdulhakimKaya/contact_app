import 'dart:io';
import 'package:contact_app/data/repo/persondao_repository.dart';
import 'package:contact_app/ui/components/person_card.dart';
import 'package:contact_app/ui/cubit/home_page_cubit.dart';
import 'package:contact_app/ui/cubit/list_detail_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app/data/entity/person.dart';

import 'detail_page.dart';

class ListDetailPage extends StatefulWidget {
  final String listId;
  final String listName;

  const ListDetailPage({Key? key, required this.listId, required this.listName}) : super(key: key);

  @override
  State<ListDetailPage> createState() => _ListDetailPageState();
}

class _ListDetailPageState extends State<ListDetailPage> {
  late ListDetailPageCubit listDetailCubit;

  @override
  void initState() {
    super.initState();
    listDetailCubit = ListDetailPageCubit(widget.listId, context.read<PersonDaoRepository>());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: listDetailCubit,
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(widget.listName),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () => _showAddPersonDialog(context),
              ),
            ],
          ),
          body: _buildPersonsList(context),
        ),
      ),
    );
  }

  Widget _buildPersonsList(BuildContext context) {
    return BlocBuilder<ListDetailPageCubit, List<Person>>(
      builder: (context, persons) {
        if (persons.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.person,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Bu listede henüz kimse yok!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: persons.length,
          itemBuilder: (context, index) => _buildPersonTile(persons[index]),
        );
      },
    );
  }

  void _showAddPersonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocBuilder<HomePageCubit, List<Person>>(
        builder: (context, allPersons) {
          // Mevcut listedeki kişileri al
          final currentListPersons = listDetailCubit.state;

          // Henüz listeye eklenmemiş kişileri filtrele
          final notAddedPersons = allPersons.where((person) =>
          !currentListPersons.any((listPerson) =>
          listPerson.person_id == person.person_id
          )
          ).toList();

          return AlertDialog(
            title: const Text('Kişi Ekle'),
            content: SizedBox(
              width: double.maxFinite,
              child: notAddedPersons.isEmpty
                  ? const Center(
                child: Text('Eklenebilecek kişi kalmadı'),
              )
                  : ListView.builder(
                shrinkWrap: true,
                itemCount: notAddedPersons.length,
                itemBuilder: (context, index) =>
                    _buildAddPersonTile(notAddedPersons[index], dialogContext),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('İptal'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPersonTile(Person person) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(person: person),
          ),
        ).then((value) {
          context.read<HomePageCubit>().personsData();
        });
      },
      child: PersonCard(person: person, isDeleted: false, isDeletedList: true),
    );
  }

  Widget _buildAddPersonTile(Person person, BuildContext dialogContext) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: person.person_image != null ? FileImage(File(person.person_image!)) : null,
        backgroundColor: Colors.grey[200],
        child: person.person_image == null || person.person_image!.isEmpty
            ? Text(person.person_name[0].toUpperCase())
            : null,
      ),
      title: Text(person.person_name),
      subtitle: Text(person.person_tel),
      trailing: IconButton(
        icon: const Icon(Icons.add_circle_outline),
        onPressed: () {
          listDetailCubit.addPerson(person.person_id);
          Navigator.pop(dialogContext);
        },
      ),
    );
  }
}

class MultiBlocBuilder<T1 extends Cubit<List<Person>>, T2 extends Cubit<List<Person>>, State> extends StatelessWidget {
  final Widget Function(BuildContext, List<Person>, List<Person>) builder;

  const MultiBlocBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T1, List<Person>>(
      builder: (context, state1) {
        return BlocBuilder<T2, List<Person>>(
          builder: (context, state2) {
            return builder(context, state1, state2);
          },
        );
      },
    );
  }
}