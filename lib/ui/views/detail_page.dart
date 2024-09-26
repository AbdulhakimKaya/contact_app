import 'package:contact_app/data/entity/person.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatefulWidget {
  final Person person;

  const DetailPage({required this.person, super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var tfPersonName = TextEditingController();
  var tfPersonTel = TextEditingController();

  Future<void> updatePerson(int person_id, String person_name, String person_tel) async {
    print("Update Person: $person_id - $person_name $person_tel");
  }

  @override
  void initState() {
    super.initState();
    var person = widget.person;
    tfPersonName.text = person.person_name;
    tfPersonTel.text = person.person_tel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Page"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 50, left: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: tfPersonName,
                decoration: const InputDecoration(hintText: "Person Name"),
              ),
              TextField(
                controller: tfPersonTel,
                decoration: const InputDecoration(hintText: "Person Tel"),
              ),
              ElevatedButton(onPressed: () {
                updatePerson(widget.person.person_id, tfPersonName.text, tfPersonTel.text);
              }, child: const Text("Update"))
            ],
          ),
        ),
      ),
    );
  }
}
