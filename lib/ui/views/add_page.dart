import 'dart:io'; // File sınıfı için
import 'package:flutter/material.dart'; // Material bileşenleri için
import 'package:flutter_bloc/flutter_bloc.dart'; // Bloc kullanımı için
import 'package:image_picker/image_picker.dart'; // Görsel seçimi için
import 'package:contact_app/ui/cubit/add_page_cubit.dart'; // Cubit bağlantısı için

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  var tfPersonName = TextEditingController(); // İsim için text controller
  var tfPersonTel = TextEditingController(); // Telefon için text controller
  File? _selectedImage; // Seçilen görseli tutacak değişken

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
        title: const Text("Add Page"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 50, left: 50),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: tfPersonName,
                  decoration: const InputDecoration(hintText: "Person Name"),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: tfPersonTel,
                  decoration: const InputDecoration(hintText: "Person Tel"),
                ),
                const SizedBox(height: 20),
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
                    : ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text("Select Image"),
                ),
                const SizedBox(height: 20),
                // Kaydetme düğmesi
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

                    // Kayıt işlemi (Cubit üzerinden)
                    context.read<AddPageCubit>().savePerson(
                      tfPersonName.text,
                      tfPersonTel.text,
                      _selectedImage != null ? _selectedImage!.path : '', // Görselin dosya yolu
                    );

                    // Başarılı mesajı ve sayfadan çıkış
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
      ),
    );
  }
}
