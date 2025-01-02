import 'dart:io';
import 'package:contact_app/data/entity/person.dart';
import 'package:contact_app/ui/cubit/home_page_cubit.dart';
import 'package:contact_app/ui/views/add_page.dart';
import 'package:contact_app/ui/views/detail_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearch = false;
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    context.read<HomePageCubit>().personsData();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("HATA: Kullanıcı oturum açmamış!");
      return;
    } else {
      print("Kullanıcı oturum bilgisi alındı: ${user.uid}");
    }

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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 35),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    user?.email ?? 'Kullanıcı',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Çıkış Yap'),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                if (mounted) {
                  Navigator.of(context).pop(); // Drawer'ı kapat
                }
              },
            ),
          ],
        ),
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
                        builder: (context) => DetailPage(person: person),
                      ),
                    ).then((value) {
                      context.read<HomePageCubit>().personsData();
                    });
                  },
                  child: Card(
                    child: SizedBox(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Profile image and contact info
                          Expanded(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircleAvatar(
                                    radius: 35,
                                    backgroundImage: person.person_image != null && person.person_image!.isNotEmpty
                                        ? FileImage(File(person.person_image!))
                                        : null,
                                    backgroundColor: Colors.grey[200],
                                    child: person.person_image == null || person.person_image!.isEmpty
                                        ? const Icon(Icons.person, size: 35, color: Colors.grey)
                                        : null,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          person.person_name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          person.person_tel,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Delete button
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Kişiyi Sil'),
                                  content: Text('${person.person_name} kişisini silmek istediğinize emin misiniz?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('İptal'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        context.read<HomePageCubit>()
                                            .deletePerson(person.person_id);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Sil'),
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz kişi eklenmemiş',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPage()),
          ).then((value) {
            context.read<HomePageCubit>().personsData();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}