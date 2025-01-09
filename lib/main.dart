import 'package:contact_app/data/repo/persondao_repository.dart';
import 'package:contact_app/ui/cubit/detail_page_cubit.dart';
import 'package:contact_app/ui/cubit/favorites_cubit.dart';
import 'package:contact_app/ui/cubit/lists_cubit.dart';
import 'package:contact_app/ui/views/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:contact_app/ui/cubit/home_page_cubit.dart';
import 'package:contact_app/ui/cubit/add_page_cubit.dart';
import 'package:contact_app/ui/views/login_page.dart';
import 'package:contact_app/ui/views/register_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Tema provider'ı için yeni class
class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  final String key = "theme_status";

  bool get isDarkMode => _isDarkMode;

  set isDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  ThemeData get theme =>
      _isDarkMode ? ThemeData.dark() : ThemeData(primarySwatch: Colors.blue);

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    // Tema değiştiğinde SharedPreferences'a kaydet
    saveTheme();
    notifyListeners();
  }

  // Tema durumunu kaydetmek için yeni method
  Future<void> saveTheme() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('theme_status', _isDarkMode);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // SharedPreferences'ı başlat
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('theme_status') ?? false;

  runApp(MyApp(initialThemeIsDark: isDarkMode));
}

class MyApp extends StatelessWidget {
  final bool initialThemeIsDark;

  const MyApp({super.key, this.initialThemeIsDark = false});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider()..isDarkMode = initialThemeIsDark,
        ),
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
          child: Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Contact App',
                theme: themeProvider.theme,
                home: const AuthWrapper(),
                routes: {
                  '/login': (context) => const LoginPage(),
                  '/register': (context) => const RegisterPage(),
                  '/home': (context) => const MainScreen(),
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

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
            return const MainScreen();
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
