import 'package:contact_app/data/entity/person.dart';
import 'package:contact_app/ui/cubit/detail_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailPage extends StatefulWidget {
  final Person person;

  const DetailPage({required this.person, super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var tfPersonName = TextEditingController();
  var tfPersonTel = TextEditingController();

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
                context.read<DetailPageCubit>().updatePerson(widget.person.person_id, tfPersonName.text, tfPersonTel.text);
              }, child: const Text("Update"))
            ],
          ),
        ),
      ),
    );
  }
}
