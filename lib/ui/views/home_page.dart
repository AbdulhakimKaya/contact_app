import 'package:contact_app/data/entity/person.dart';
import 'package:contact_app/ui/views/add_page.dart';
import 'package:contact_app/ui/views/detail_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSearch = false;

  Future<void> searchPerson(String searchText) async {
    print("Search Person: $searchText");
  }

  Future<List<Person>> personsData() async {
    var personsList = <Person>[];
    var p1 = Person(
        person_id: 1, person_name: "Abdulhakim", person_tel: "05301112233");
    var p2 =
        Person(person_id: 2, person_name: "Furkan", person_tel: "05301114455");
    var p3 =
        Person(person_id: 3, person_name: "Ömer", person_tel: "05301116677");

    personsList.add(p1);
    personsList.add(p2);
    personsList.add(p3);

    return personsList;
  }

  Future<void> deletePerson(int person_id) async {
    print("Person Id: $person_id");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearch
            ? TextField(
                decoration: const InputDecoration(hintText: "Search"),
                onChanged: (searchText) {
                  searchPerson(searchText);
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
      body: FutureBuilder<List<Person>>(
        future: personsData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var personsList = snapshot.data;
            return ListView.builder(
                itemCount: personsList!.length,
                itemBuilder: (context, index) {
                  var person = personsList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(person: person))).then((value) {});
                    },
                    child: Card(
                      child: SizedBox(
                        height: 80,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                            IconButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Delete ${person.person_name}?"),
                                    action: SnackBarAction(
                                        label: "Yes",
                                        onPressed: () {
                                          deletePerson(person.person_id);
                                        }),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.clear,
                                color: Colors.black54,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return const Center();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddPage()))
              .then((value) {
            print("Anasayfaya dönüldü");
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
