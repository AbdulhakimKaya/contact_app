import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app/ui/cubit/favorites_cubit.dart';
import 'package:contact_app/data/entity/person.dart';
import 'package:contact_app/ui/views/detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favoriler"),
      ),
      body: BlocBuilder<FavoritesCubit, List<Person>>(
        builder: (context, favoritesList) {
          if (favoritesList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.star_border,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz favori kişi eklenmemiş',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: favoritesList.length,
            itemBuilder: (context, index) {
              var person = favoritesList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: person.person_image != null && person.person_image!.isNotEmpty
                        ? FileImage(File(person.person_image!))
                        : null,
                    child: person.person_image == null || person.person_image!.isEmpty
                        ? Text(person.person_name[0].toUpperCase())
                        : null,
                  ),
                  title: Text(person.person_name),
                  subtitle: Text(person.person_tel),
                  trailing: IconButton(
                    icon: const Icon(Icons.star, color: Colors.amber),
                    onPressed: () {
                      context.read<FavoritesCubit>().toggleFavorite(person.person_id, !person.isFavorite);
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(person: person),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}