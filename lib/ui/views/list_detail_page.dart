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
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.listName),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () => _showAddPersonDialog(context),
            ),
          ],
        ),
        body: _buildPersonsList(),
      ),
    );
  }

  Widget _buildPersonsList() {
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
        },child: PersonCard(person: person, isDeleted: false, isDeletedList: true,));
  }

  void _showAddPersonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocBuilder<HomePageCubit, List<Person>>(
        builder: (context, persons) {
          return AlertDialog(
            title: const Text('Kişi Ekle'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: persons.length,
                itemBuilder: (context, index) => _buildAddPersonTile(persons[index], dialogContext),
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

  Widget _buildAddPersonTile(Person person, BuildContext dialogContext) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: person.person_image != null ? FileImage(File(person.person_image!)) : null,
        child: person.person_image == null ? Text(person.person_name[0].toUpperCase()) : null,
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