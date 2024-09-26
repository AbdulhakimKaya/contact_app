import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  var tfPersonName = TextEditingController();
  var tfPersonTel = TextEditingController();

  Future<void> savePerson(String person_name, String person_tel) async {
    print("Save Person: $person_name $person_tel");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Page"),
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
                savePerson(tfPersonName.text, tfPersonTel.text);
              }, child: const Text("Save"))
            ],
          ),
        ),
      ),
    );
  }
}
