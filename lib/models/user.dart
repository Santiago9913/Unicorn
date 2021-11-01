import 'package:firebase_database/firebase_database.dart';

class User {
  String name;
  String lastName;
  String userUID;
  String type;
  String email;
  String bannerPicURL;
  String profilePicUrl;
  String linkedInProfile = "";

  final db = FirebaseDatabase.instance.reference();

  User({
    required this.name,
    required this.lastName,
    required this.userUID,
    required this.type,
    required this.email,
    required this.bannerPicURL,
    required this.profilePicUrl,
    this.linkedInProfile = "",
  });

  String get getName {
    return name;
  }

  String get getlastName {
    return lastName;
  }

  String get getUserUID {
    return userUID;
  }

  String get getUserType {
    return type;
  }

  String get getEmail {
    return email;
  }

  String get getBannerPicURL {
    return bannerPicURL;
  }

  String get getProfilePicURL {
    return profilePicUrl;
  }

  String get getLinkedInProfile {
    return linkedInProfile;
  }

  void setProfilePicture(String url) {
    profilePicUrl = url;
  }

  void setBannerPicture(String url) {
    bannerPicURL = url;
  }

  Future<void> setLinkedInProfile(String url) async {
    try {
      DatabaseReference userReference = getUserRef;
      Map<String, String> mapName = {"linkedInProfile": url};
      await userReference.update(mapName);
      linkedInProfile = url;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setName(String nName) async {
    try {
      DatabaseReference userReference = getUserRef;
      Map<String, String> mapName = {"firstName": nName};
      await userReference.update(mapName);
      name = nName;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setLastName(String nName) async {
    try {
      DatabaseReference userReference = getUserRef;
      Map<String, String> mapName = {"lastName": nName};
      await userReference.update(mapName);
      lastName = nName;
    } catch (e) {
      print(e.toString());
    }
  }

  DatabaseReference get getUserRef {
    return db.child('users/$userUID/');
  }

  DatabaseReference get getDBReference {
    return db;
  }
  // User.fromJson(Map<dynamic, dynamic> json)
  //     : name = json["name"] as String,
  //       lastName = json["lastName"] as String,
  //       email = json["email"] as String,
  //       type = json["type"] as String,
  //       userUID = json["userUID"] as String;

  Map<dynamic, dynamic> toJSON() => <dynamic, dynamic>{
        'email': email,
        'firstName': name,
        'lastName': lastName,
        'type': type,
        'survey': false,
        'bannerPicUrl': '',
        'profilePicUrl': '',
        'linkedInProfile': '',
      };
}
