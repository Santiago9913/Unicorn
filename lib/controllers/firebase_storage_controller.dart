import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageController {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final DatabaseReference _db = FirebaseDatabase.instance.reference();

  static Future<String> uploadImageToStorage(
      String storagePath, String filePath, String fileName) async {
    File file = File(filePath);
    String url = '';
    String urlToUpload = '$storagePath/$fileName.jpeg';
    late Map<String, String> mapImage;

    try {
      await _storage.ref(urlToUpload).putFile(file);
      url = await _storage.ref(urlToUpload).getDownloadURL();

      switch (fileName) {
        case 'profile':
          mapImage = {"profilePicUrl": url};
          await _db.child('$storagePath/').update(mapImage);
          break;
        case 'banner':
          mapImage = {"bannerPicUrl": url};
          await _db.child('$storagePath/').update(mapImage);
          break;
      }
    } catch (error) {
      print(error.toString());
    }

    return url;
  }
}
