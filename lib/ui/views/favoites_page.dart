import 'package:contact_app/ui/components/person_card.dart';
import 'package:contact_app/ui/cubit/home_page_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app/ui/cubit/favorites_cubit.dart';
import 'package:contact_app/data/entity/person.dart';
import 'package:contact_app/ui/views/detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

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
              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(person: person),
                      ),
                    ).then((value) {
                      context.read<HomePageCubit>().personsData();
                    });
                  },
                  child: PersonCard(
                    person: person,
                    isDeleted: false,
                  ));
            },
          );
        },
      ),
    );
  }
}
