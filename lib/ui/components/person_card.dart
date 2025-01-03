import 'dart:io';
import 'package:contact_app/data/entity/person.dart';
import 'package:contact_app/ui/cubit/list_detail_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app/ui/cubit/home_page_cubit.dart';

class PersonCard extends StatelessWidget {
  final Person person;
  final bool? isDeleted;
  final bool? isDeletedList;

  const PersonCard({
    super.key,
    required this.person, this.isDeleted = true, this.isDeletedList = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 65,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Profile image and contact info
            Expanded(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: CircleAvatar(
                      radius: 35,
                      backgroundImage: person.person_image != null && person.person_image!.isNotEmpty
                          ? FileImage(File(person.person_image!))
                          : null,
                      backgroundColor: Colors.grey[200],
                      child: person.person_image == null || person.person_image!.isEmpty
                          ? Text(person.person_name[0].toUpperCase())
                          : null,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
                              child: const Text('Sil'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
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
