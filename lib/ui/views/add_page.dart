import 'package:contact_app/ui/cubit/add_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  var tfPersonName = TextEditingController();
  var tfPersonTel = TextEditingController();

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
                context.read<AddPageCubit>().savePerson(tfPersonName.text, tfPersonTel.text, tfPersonName.text);
              }, child: const Text("Save"))
            ],
          ),
        ),
      ),
    );
  }
}
