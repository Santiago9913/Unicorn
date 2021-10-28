import 'package:firebase_database/firebase_database.dart';

class User {
  String name;
  String lastName;
  String userUID;
  String type;
  String email;
  String bannerPicURL;
  String profilePicUrl;

  final db = FirebaseDatabase.instance.reference();

  User({
    required this.name,
    required this.lastName,
    required this.userUID,
    required this.type,
    required this.email,
    required this.bannerPicURL,
    required this.profilePicUrl,
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

  void setProfilePicture(String url) {
    profilePicUrl = url;
  }

  void setBannerPicture(String url) {
    bannerPicURL = url; 
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
      };
}
