import 'dart:io';
import 'package:contact_app/data/entity/person.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:contact_app/ui/cubit/add_page_cubit.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class AddPage extends StatefulWidget {
  final Person? person; // Opsiyonel person parametresi

  const AddPage({super.key, this.person});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  var tfPersonName = TextEditingController();
  var tfPersonTel = TextEditingController();
  File? _selectedImage;

  bool isFavorite = false; // Favori durumu için yerel değişken

  @override
  void initState() {
    super.initState();

    // Eğer person parametresi varsa, varsayılan değerleri yükleyin
    if (widget.person != null) {
      tfPersonName.text = widget.person!.person_name;
      tfPersonTel.text = widget.person!.person_tel;
      isFavorite = widget.person!.isFavorite;
    }
  }

  Future<void> _pickImage() async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 24, left: 24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : null,
                        backgroundColor: Colors.grey[200],
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _pickImage,
                        child: const Text("Change Image"),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      isFavorite ? Icons.star : Icons.star_border,
                      color: isFavorite ? Colors.amber : Colors.grey,
                      size: 28,
                    ),
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: tfPersonName,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Person Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(width: 1),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        MaskTextInputFormatter(
                          mask: '(###) ### ## ##',
                          filter: {'#': RegExp(r'[0-9]')},
                        ),
                      ],
                      controller: tfPersonTel,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: '(5__) ___ __ __',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(width: 1),
                        ),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '+90 ',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (tfPersonName.text.isEmpty || tfPersonTel.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Lütfen tüm alanları doldurun."),
                      ),
                    );
                    return;
                  }

                  String fullPhoneNumber = '+90${tfPersonTel.text}';

                  context.read<AddPageCubit>().savePerson(
                    tfPersonName.text,
                    fullPhoneNumber,
                    _selectedImage != null ? _selectedImage!.path : '',
                    isFavorite, // Favori bilgisi ekleniyor
                  );

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Kişi başarıyla kaydedildi."),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

