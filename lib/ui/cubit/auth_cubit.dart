import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthCubit extends Cubit<User?> {
  AuthCubit() : super(FirebaseAuth.instance.currentUser);

  // Kullanıcı Giriş Yap
  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(userCredential.user);
    } catch (e) {
      print("Login error: $e");
      emit(null);
    }
  }

  // Kullanıcı Kayıt Ol
  Future<void> register(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(userCredential.user);
    } catch (e) {
      print("Register error: $e");
      emit(null);
    }
  }

  // Çıkış Yap
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    emit(null);
  }
}
