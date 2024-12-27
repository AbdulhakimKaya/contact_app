import 'dart:io'; // File sınıfı için
import 'package:contact_app/data/entity/person.dart';
import 'package:contact_app/ui/cubit/detail_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart'; // Görsel seçimi için

class DetailPage extends StatefulWidget {
  final Person person;

  const DetailPage({required this.person, super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  var tfPersonName = TextEditingController();
  var tfPersonTel = TextEditingController();
  File? _selectedImage; // Seçilen görseli tutacak değişken

  @override
  void initState() {
    super.initState();
    var person = widget.person;
    tfPersonName.text = person.person_name;
    tfPersonTel.text = person.person_tel;
    _selectedImage = person.person_image != null ? File(person.person_image!) : null; // Eğer kişiye ait resim varsa, resim yolu ile başla
  }

  // Görsel seçme fonksiyonu
  Future<void> _pickImage() async {
    final pickedImage =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path); // Seçilen görsel dosyasını kaydet
      });
    }
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
              // Görsel seçme ve gösterme kısmı
              _selectedImage != null
                  ? Column(
                children: [
                  Image.file(
                    _selectedImage!,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text("Change Image"),
                  ),
                ],
              )
                  : Column(
                children: [
                  const Text("Resim yükleyebilirsiniz."),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: const Text("Select Image"),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Güncelleme düğmesi
              ElevatedButton(
                onPressed: () {
                  context.read<DetailPageCubit>().updatePerson(
                    widget.person.person_id,
                    tfPersonName.text,
                    tfPersonTel.text,
                    _selectedImage != null ? _selectedImage!.path : '', // Eğer resim seçildiyse, dosya yolunu gönder
                  );
                  // Başarılı mesajı
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Kişi başarıyla güncellendi."),
                    ),
                  );
                  Navigator.pop(context);
                },
                child: const Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
