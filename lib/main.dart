import 'package:contact_app/data/repo/persondao_repository.dart';
import 'package:contact_app/ui/cubit/detail_page_cubit.dart';
import 'package:contact_app/ui/cubit/favorites_cubit.dart';
import 'package:contact_app/ui/cubit/lists_cubit.dart';
import 'package:contact_app/ui/views/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Cubit'ler ve Sayfalarınızı içe aktarın
import 'package:contact_app/ui/cubit/home_page_cubit.dart';
import 'package:contact_app/ui/cubit/add_page_cubit.dart'; // AddPageCubit örnek olarak eklendi
import 'package:contact_app/ui/views/login_page.dart';
import 'package:contact_app/ui/views/register_page.dart';
import 'package:provider/provider.dart';

void main() async {
  // Firebase Başlatma
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PersonDaoRepository>(
          create: (_) => PersonDaoRepository(),
        ),
        MultiBlocProvider(
          providers: [
            BlocProvider<HomePageCubit>(
              create: (_) => HomePageCubit(),
            ),
            BlocProvider<AddPageCubit>(
              create: (_) => AddPageCubit(),
            ),
            BlocProvider<DetailPageCubit>(
              create: (_) => DetailPageCubit(),
            ),
            BlocProvider<FavoritesCubit>(
              create: (_) => FavoritesCubit(),
            ),
            BlocProvider<ListsCubit>(
              create: (_) => ListsCubit(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Contact App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const AuthWrapper(),
            routes: {
              '/login': (context) => const LoginPage(),
              '/register': (context) => const RegisterPage(),
              '/home': (context) => const MainScreen(),
            },
          ),
        ),
      ],
    );
  }
}
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const LoginPage();
          } else {
            return const MainScreen(); // HomePage yerine MainScreen
          }
        }

        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}