import 'dart:io';
import 'package:contact_app/data/entity/person.dart';
import 'package:contact_app/ui/cubit/list_detail_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app/ui/cubit/home_page_cubit.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonCard extends StatelessWidget {
  final Person person;
  final bool? isDeleted;
  final bool? isDeletedList;
  final bool? isFavorite;
  final bool? isContact;

  const PersonCard({
    super.key,
    required this.person, this.isDeleted = true, this.isDeletedList = false, this.isFavorite = true, this.isContact = true,
  });

  void _launchURL(BuildContext context, String? url) async {
    if (url == null) return;
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Bağlantı açılamadı!'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: CircleAvatar(
                      radius: 24,
                      backgroundImage: person.person_image != null && person.person_image!.isNotEmpty
                          ? FileImage(File(person.person_image!))
                          : null,
                      backgroundColor: Colors.grey[200],
                      child: person.person_image == null || person.person_image!.isEmpty
                          ? Text(person.person_name[0].toUpperCase(), style: const TextStyle(color: Colors.deepPurple),)
                          : null,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            person.person_name,
                            style: const TextStyle(
                              fontSize: 16,
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
            // Favorite and Delete buttons
            Row(
              children: [
                if(isContact == true)
                  IconButton(onPressed: () => _launchURL(context, 'tel:${person.person_tel}'), icon: const Icon(Icons.phone)),
                  IconButton(onPressed: () => _launchURL(context, 'sms:${person.person_tel}'), icon: const Icon(Icons.message)),

                if(isFavorite == true)
                  IconButton(
                    icon: Icon(
                      person.isFavorite ? Icons.star : Icons.star_border,
                      color: person.isFavorite ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () {
                      context.read<HomePageCubit>().toggleFavorite(
                        person.person_id,
                        !person.isFavorite,
                      );
                    },
                  ),

                if(isDeleted == true)
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
                                context.read<HomePageCubit>().deletePerson(person.person_id);
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Sil'),
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

                if(isDeletedList == true)
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: () {
                      context.read<ListDetailPageCubit>().removePerson(person.person_id);
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
