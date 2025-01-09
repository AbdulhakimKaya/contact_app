import 'dart:io';
import 'package:contact_app/data/entity/person.dart';
import 'package:contact_app/ui/cubit/detail_page_cubit.dart';
import 'package:contact_app/ui/cubit/home_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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

    // Telefon numarasını +90 olmadan göster
    var phoneNumber = person.person_tel;
    if (phoneNumber.startsWith('+90')) {
      phoneNumber = phoneNumber.substring(3); // +90'ı kaldır
    }
    phoneNumber = clearPhone(phoneNumber); // Temizle
    tfPersonTel.text = formatPhone(phoneNumber); // Formatla
    // Resim dosyasının varlığını kontrol ediyoruz
    if (person.person_image != null &&
        File(person.person_image!).existsSync()) {
      _selectedImage = File(person.person_image!);
    } else {
      _selectedImage = null;
    }
  }

  // Görsel seçme fonksiyonu
  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _selectedImage =
            File(pickedImage.path); // Seçilen görsel dosyasını kaydet
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Page"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(right: 24, left: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Görsel seçme ve gösterme kısmı
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
                      child: _selectedImage == null
                          ? Text(
                              tfPersonName.text[0].toUpperCase(),
                              style: TextStyle(fontSize: 24),
                            )
                          : null,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text("Change Image"),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    widget.person.isFavorite ? Icons.star : Icons.star_border,
                    color:
                        widget.person.isFavorite ? Colors.amber : Colors.grey,
                    size: 28,
                  ),
                  onPressed: () {
                    setState(() {
                      widget.person.isFavorite = !widget.person.isFavorite;
                    });
                    context.read<HomePageCubit>().toggleFavorite(
                          widget.person.person_id,
                          widget.person.isFavorite,
                        );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            TextField(
              controller: tfPersonName,style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Person Name',
                hintStyle:  const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    width: 1,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                // Kullanıcıdan 10 haneli numara alınan alan
                Expanded(
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      MaskTextInputFormatter(
                          mask: '(###) ### ## ##',
                          filter: {'#': RegExp(r'[0-9]')}),
                    ],
                    controller: tfPersonTel,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: '(5__) ___ __ __',
                      hintStyle:  const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          width: 1,
                        ),
                      ),
                      prefixIcon: const Padding(
                        padding: EdgeInsets.only(left: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '+90 ',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Lütfen telefon numaranızı giriniz';
                      }

                      value = clearPhone(value);
                      if (value.isEmpty) {
                        return 'Lütfen telefon numaranızı giriniz';
                      }

                      if (value.length < 10) {
                        return 'Telefon numarası 10 haneli olmalıdır';
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
            // Güncelleme düğmesi
            const SizedBox(height: 24),
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

                context.read<DetailPageCubit>().updatePerson(
                      widget.person.person_id,
                      tfPersonName.text,
                      fullPhoneNumber, // Birleştirilmiş telefon numarası
                      _selectedImage != null ? _selectedImage!.path : '',
                    );

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
    );
  }

  String clearPhone(String phone) {
    // Tüm karakterlerden sadece rakamları alıyoruz
    phone = phone.replaceAll(RegExp(r'[^0-9]'), '');

    // Eğer başta "+90" veya "90" varsa, bunu kaldırıyoruz
    if (phone.startsWith('90')) {
      phone = phone.substring(2);
    }

    // Başındaki sıfırı kaldır (çünkü form gösteriminde zaten +90 var)
    if (phone.startsWith('0')) {
      phone = phone.substring(1);
    }

    return phone;
  }

  String formatPhone(String clearInput) {
    if (clearInput.length < 4) {
      return clearInput;
    }

    if (clearInput.length < 7) {
      return '(${clearInput.substring(0, 3)}) ${clearInput.substring(3)}';
    }

    if (clearInput.length < 9) {
      return '(${clearInput.substring(0, 3)}) ${clearInput.substring(3, 6)} ${clearInput.substring(6)}';
    }

    return '(${clearInput.substring(0, 3)}) ${clearInput.substring(3, 6)} ${clearInput.substring(6, 8)} ${clearInput.substring(8)}';
  }
}
