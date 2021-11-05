import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:unicorn/models/post.dart';
import 'package:unicorn/models/user.dart';

class FirebaseStorageController {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<String> uploadImageToStorage(
      String storagePath, String filePath, String fileName, String uid) async {
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
          await updateUser(uid, mapImage);
          break;
        case 'banner':
          mapImage = {"bannerPicUrl": url};
          await updateUser(uid, mapImage);
          break;
      }
    } catch (error) {
      print(error.toString());
    }

    return url;
  }

  static Future<String> uploadPostImageAndPost(
      Post post, File file, String uid) async {
    String id = await uploadPost(post);
    String url = "";
    String urlToUpload = "posts/$uid/$id/post.jpeg";

    try {
      await _storage.ref(urlToUpload).putFile(file);
      url = await _storage.ref(urlToUpload).getDownloadURL();
      await updatePost(id, {"imgUrl": url});

      await _db.collection("users").doc(uid).update({
        "posts": FieldValue.arrayUnion([id])
      });

      return url;
    } catch (e) {
      print(e.toString());
    }

    return url;
  }

  //User Controllers

  static Future<void> uploadUser(User user) async {
    await _db.collection("users").doc(user.userUID).set(user.toJSON());
  }

  static Future<Map<String, dynamic>> getUser(String uid) async {
    DocumentSnapshot user = await _db.collection("users").doc(uid).get();
    return user.data()! as Map<String, dynamic>;
  }

  static Future<void> updateUser(
      String uid, Map<String, dynamic> newInfo) async {
    await _db.collection("users").doc(uid).update(newInfo);
  }

  static Future<dynamic> getFieldInUser(String uid, String field) async {
    dynamic value = field;

    DocumentSnapshot user = await _db.collection("users").doc(uid).get();

    if (user.exists) {
      value = user.data() as Map<String, dynamic>;
      return value[field];
    }

    return value;
  }

  //Context aware controller
  static Future<QuerySnapshot> getPagesInMyLocation(String location) async {
    return await _db
        .collection("pages")
        .where("country", isEqualTo: location)
        .get();
  }

  //Posts controllers

  static Future<String> uploadPost(Post post) async {
    DocumentReference uploaded =
        await _db.collection("posts").add(post.toJSON());
    DocumentSnapshot snapshot = await uploaded.get();
    return snapshot.reference.id;
  }

  static Future<void> updatePost(
      String id, Map<String, dynamic> newInfo) async {
    await _db.collection("posts").doc(id).update(newInfo);
  }
}
