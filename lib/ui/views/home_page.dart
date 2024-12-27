import 'dart:io';  // File import etmek için
import 'package:contact_app/data/entity/person.dart';
import 'package:contact_app/ui/cubit/home_page_cubit.dart';
import 'package:contact_app/ui/views/add_page.dart';
import 'package:contact_app/ui/views/detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearch = false;

  @override
  void initState() {
    super.initState();
    context.read<HomePageCubit>().personsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearch
            ? TextField(
          decoration: const InputDecoration(hintText: "Search"),
          onChanged: (searchText) {
            context.read<HomePageCubit>().searchPerson(searchText);
          },
        )
            : const Text("Contacts"),
        actions: [
          isSearch
              ? IconButton(
            onPressed: () {
              setState(() {
                isSearch = false;
              });
              context.read<HomePageCubit>().personsData();
            },
            icon: const Icon(Icons.clear),
          )
              : IconButton(
            onPressed: () {
              setState(() {
                isSearch = true;
              });
            },
            icon: const Icon(Icons.search),
          )
        ],
      ),
      body: BlocBuilder<HomePageCubit, List<Person>>(
        builder: (context, personsList) {
          if (personsList.isNotEmpty) {
            return ListView.builder(
              itemCount: personsList.length,
              itemBuilder: (context, index) {
                var person = personsList[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailPage(person: person)))
                        .then((value) {
                      context.read<HomePageCubit>().personsData();
                    });
                  },
                  child: Card(
                    child: SizedBox(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Profile image in a circle
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: CircleAvatar(
                                  radius: 30, // Set the radius to control the size
                                  backgroundImage: person.person_image != null
                                      ? FileImage(File(person.person_image!))
                                      : null,  // personImageUrl, yerel dosya yolunu taşıyor
                                  backgroundColor: Colors.grey[200], // Placeholder color
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      person.person_name,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    Text(person.person_tel),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Delete ${person.person_name}?"),
                                  action: SnackBarAction(
                                    label: "Yes",
                                    onPressed: () {
                                      context.read<HomePageCubit>()
                                          .deletePerson(person.person_id);
                                    },
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddPage()))
              .then((value) {
            context.read<HomePageCubit>().personsData();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
