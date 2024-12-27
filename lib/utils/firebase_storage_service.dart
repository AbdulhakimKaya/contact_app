import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage(File imageFile, String folderName) async {
    try {
      // Dosya adını oluştur
      String fileName = basename(imageFile.path);

      // Firebase Storage referansı
      Reference ref = _storage.ref('$folderName/$fileName');

      // Dosyayı yükle
      UploadTask uploadTask = ref.putFile(imageFile);

      // Yükleme işlemi tamamlandığında URL al
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();

      return downloadURL; // Görüntünün indirme bağlantısı
    } catch (e) {
      throw Exception("Image upload failed: $e");
    }
  }
}
