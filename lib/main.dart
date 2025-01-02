import 'package:contact_app/ui/cubit/detail_page_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Cubit'ler ve Sayfalarınızı içe aktarın
import 'package:contact_app/ui/cubit/home_page_cubit.dart';
import 'package:contact_app/ui/cubit/add_page_cubit.dart'; // AddPageCubit örnek olarak eklendi
import 'package:contact_app/ui/views/home_page.dart';
import 'package:contact_app/ui/views/login_page.dart';
import 'package:contact_app/ui/views/register_page.dart';

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
    return MultiBlocProvider(
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contact App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const AuthWrapper(), // Oturum durumuna göre yönlendirme
        routes: {
          '/login': (context) => const LoginPage(),
          '/register': (context) => RegisterPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}

// Kullanıcı Oturumunu Kontrol Eden Widget
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Oturum durumu kontrolü
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            // Kullanıcı giriş yapmamışsa LoginPage'e yönlendir
            return const LoginPage();
          } else {
            // Kullanıcı giriş yapmışsa HomePage'e yönlendir
            return const HomePage();
          }
        }

        // Henüz bağlantı kurulmamışsa yükleniyor ekranı göster
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
