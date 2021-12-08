import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'package:unicorn/models/event.dart';
import 'package:unicorn/models/ico.dart';
import 'package:unicorn/models/page.dart';
import 'package:unicorn/models/post.dart';
import 'package:unicorn/models/preferred_founding.dart';
import 'package:unicorn/models/user.dart';
import 'package:unicorn/controllers/hive_controller.dart';

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
      error;
    }

    return url;
  }

  static Future<String> uploadPostImageAndPost(
      Post post, File file, String uid) async {
    final Trace getImageTrace =
        FirebasePerformance.instance.newTrace('get_image');
    final Trace uploadImageTrace =
        FirebasePerformance.instance.newTrace('upload_image');
    String id = await uploadPost(post);
    String url = "";
    String urlToUpload = "posts/$uid/$id/post.jpeg";

    try {
      await uploadImageTrace.start();
      await _storage.ref(urlToUpload).putFile(file);
      await uploadImageTrace.stop();
      await getImageTrace.start();
      url = await _storage.ref(urlToUpload).getDownloadURL();
      await getImageTrace.stop();
      await updatePost(id, {"imgUrl": url});

      await _db.collection("users").doc(uid).update({
        "posts": FieldValue.arrayUnion([id])
      });

      return url;
    } catch (e) {
      e;
    }

    return url;
  }

  static Future<void> uploadPageAndImages(UserPage page, File profilePicFile,
      File bannerPicFile, String uid) async {
    String id = await uploadPage(page, uid);
    String profileURL = "";
    String bannerURL = "";
    String urlToUpload = "pages/$uid/$id/";

    try {
      await _storage.ref("${urlToUpload}profile.jpeg").putFile(profilePicFile);
      await _storage.ref("${urlToUpload}banner.jpeg").putFile(bannerPicFile);
      profileURL =
          await _storage.ref("${urlToUpload}profile.jpeg").getDownloadURL();

      bannerURL =
          await _storage.ref("${urlToUpload}banner.jpeg").getDownloadURL();

      await updatePage(id, {
        "bannerPicURL": bannerURL,
        "profilePicUrl": profileURL,
      });

      await _db.collection("users").doc(uid).update({
        "pages": FieldValue.arrayUnion([id])
      });
    } catch (e) {
      e;
    }
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

  static Future<void> registerView(String uid) async {
    await _db
        .collection("users")
        .doc(uid)
        .update({"views": FieldValue.increment(1)});
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

  static Future<void> updateTrace(String trace) async {
    await _db
        .collection("2fa")
        .doc("traces")
        .update({trace: FieldValue.increment(1)});
  }

  static Future<void> updateViewsCalendar(String uid) async {
    await _db
        .collection("users")
        .doc(uid)
        .update({"viewsCalendar": FieldValue.increment(1)});
  }

  //Context aware controller
  static Future<QuerySnapshot> getPagesInMyLocation(String location) async {
    return await _db
        .collection("pages")
        .where("country", isEqualTo: location)
        .get();
  }

  static Future<List<Event>> getEventsFB() async {
    List<Event> events = [];
    QuerySnapshot qs = await _db.collection("events").get();
    List<dynamic> docs = await qs.docs;
    docs.forEach((element) {
      Map<String, dynamic> info = element.data() as Map<String, dynamic>;
      Event e = Event.fromJson(info);
      events.add(e);
    });
    return events;
  }

  static Future<List<Event>> getEvents() async {
    List<dynamic> mHiveEvents = await HiveController.retrieveEvents();
    List<Event> hiveEvents = [];
    mHiveEvents.forEach((element) {
      hiveEvents.add(Event(
          name: element['name'],
          date: element['date'],
          description: element['description'],
          timeStart: element['timeStart'],
          timeEnd: element['timeEnd']));
    });
    List<Event> fbEvents = [];
    var total = 0;
    try {
      fbEvents = await getEventsFB();
      total = fbEvents.length;
    } catch (e) {
      e;
    }

    var events = hiveEvents.length > total ? [...hiveEvents] : [...fbEvents];
    if (hiveEvents.length <= total) {
      String jsonStr = jsonEncode(events);
      HiveController.storeEvents(jsonStr);
    }
    return events;
  }

  //Pages controllers
  static Future<String> uploadPage(UserPage page, String ownerUID) async {
    DocumentReference uploaded =
        await _db.collection("pages").add(page.toJSON());
    DocumentSnapshot snapshot = await uploaded.get();
    return snapshot.reference.id;
  }

  static Future<void> updatePage(
      String id, Map<String, dynamic> newInfo) async {
    await _db.collection("pages").doc(id).update(newInfo);
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

  //Query Controllers
  static Future<List<User>> queryOnUserName(String name, User user) async {
    List<dynamic> userInterests = user.interests;

    QuerySnapshot<Map<String, dynamic>> resultUsers =
        await _db.collection("users").where("firstName", isEqualTo: name).get();

    // QuerySnapshot<Map<String, dynamic>> resultPages =
    //     await _db.collection("users").where("name", isEqualTo: name).get();

    QuerySnapshot<Map<String, dynamic>> recommendedUsers = await _db
        .collection("users")
        .where("interests", arrayContainsAny: userInterests)
        .get();

    List<User> users = [];

    for (var e in recommendedUsers.docs) {
      String uid = e.id;
      if (uid != user.userUID) {
        User nUser = User.fromJson(e.data(), uid);
        users.add(nUser);
      }
    }

    for (var e in resultUsers.docs) {
      String uid = e.id;
      if (uid != user.userUID) {
        User nUser = User.fromJson(e.data(), uid);
        users.add(nUser);
      }
    }

    return users;
  }

  static Future<List<User>> queryPromoted(String uid) async {
    List<User> users = [];

    QuerySnapshot snapshot = await _db.collection("promoted").get();
    snapshot.docs.forEach((DocumentSnapshot doc) async {
      String id = doc.reference.id;
      if (id != uid) {
        Map<String, dynamic> userInfo = await getUser(id);
        User user = User.fromJson(userInfo, id);
        users.add(user);
      }
    });

    return users;
  }

  static Future<List<ICO>> queryICO() async {
    List<ICO> results = [];
    int trueTotal = 0;
    int falseTotal = 0;

    QuerySnapshot<Map<String, dynamic>> trueICO =
        await _db.collection("pages").where("useICO", isEqualTo: true).get();

    QuerySnapshot<Map<String, dynamic>> falseICO =
        await _db.collection("pages").where("useICO", isEqualTo: false).get();

    trueTotal = trueICO.size;
    falseTotal = falseICO.size;

    results.add(ICO(used: "Use ICO", value: trueTotal));
    results.add(ICO(used: "No ICO", value: falseTotal));

    return results;
  }

  static Future<List<PreferredFounding>> queryPreferredFounding() async {
    List<PreferredFounding> results = [];
    int bankFunding = 0;
    int businessAngel = 0;
    int vc = 0;
    int govermentFounding = 0;
    int crowdfounding = 0;

    QuerySnapshot<Map<String, dynamic>> bank = await _db
        .collection("pages")
        .where("preferredFinancial", isEqualTo: 'Bank funding')
        .get();

    QuerySnapshot<Map<String, dynamic>> business = await _db
        .collection("pages")
        .where("preferredFinancial", isEqualTo: 'Business angel')
        .get();

    QuerySnapshot<Map<String, dynamic>> venture = await _db
        .collection("pages")
        .where("preferredFinancial", isEqualTo: 'Venture capital')
        .get();

    QuerySnapshot<Map<String, dynamic>> gov = await _db
        .collection("pages")
        .where("preferredFinancial", isEqualTo: 'Government')
        .get();

    QuerySnapshot<Map<String, dynamic>> crowd = await _db
        .collection("pages")
        .where("preferredFinancial", isEqualTo: 'Crowdfunding')
        .get();

    bankFunding = bank.size;
    businessAngel = business.size;
    vc = venture.size;
    govermentFounding = gov.size;
    crowdfounding = crowd.size;

    results.add(PreferredFounding(name: 'Bank funding', value: bankFunding));
    results
        .add(PreferredFounding(name: 'Business angel', value: businessAngel));
    results.add(PreferredFounding(name: 'Venture capital', value: vc));
    results.add(PreferredFounding(
        name: 'Government funding', value: govermentFounding));
    results.add(PreferredFounding(name: 'Crowdfunding', value: crowdfounding));

    return results;
  }
}
