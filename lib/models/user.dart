import 'package:unicorn/controllers/firebase_storage_controller.dart';

class User {
  String name;
  String lastName;
  String userUID;
  String type;
  String email;
  String bannerPicURL;
  String profilePicUrl;
  String linkedInProfile;
  List<dynamic> interests;
  List<String> posts;
  DateTime created;


  User({
    required this.name,
    required this.lastName,
    required this.userUID,
    required this.type,
    required this.email,
    required this.bannerPicURL,
    required this.profilePicUrl,
    this.linkedInProfile = "",
    this.interests = const <String>[],
    this.posts = const <String>[],
    required this.created
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

  List<String> get getPosts {
    return posts;
  }

  void setProfilePicture(String url) {
    profilePicUrl = url;
  }

  void setBannerPicture(String url) {
    bannerPicURL = url;
  }

  void setInterests(List<dynamic> nInterests) {
    interests = nInterests;
  }

  Future<void> setLinkedInProfile(String url) async {
    try {
      Map<String, String> mapName = {"linkedInProfile": url};
      await FirebaseStorageController.updateUser(userUID, mapName);
      linkedInProfile = url;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setName(String nName) async {
    try {
      Map<String, String> mapName = {"firstName": nName};
      await FirebaseStorageController.updateUser(userUID, mapName);
      name = nName;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setLastName(String nName) async {
    try {
      Map<String, String> mapName = {"lastName": nName};
      await FirebaseStorageController.updateUser(userUID, mapName);
      lastName = nName;
    } catch (e) {
      print(e.toString());
    }
  }

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'email': email,
        'firstName': name,
        'lastName': lastName,
        'type': type,
        'survey': false,
        'bannerPicUrl': '',
        'profilePicUrl': '',
        'linkedInProfile': '',
        'interests': interests,
        'posts': posts,
        'created': created
      };

  static User fromJson(Map<String, dynamic> map, String uid) {
    return User(
      name: map["firstName"],
      lastName: map["lastName"],
      userUID: uid,
      type: map["type"],
      email: map["email"],
      bannerPicURL: map["bannerPicUrl"] ?? "",
      profilePicUrl: map["profilePicUrl"] ?? "",
      linkedInProfile: map['linkedInProfile'] ?? "",
      interests: map['interests'],
      created: map['created'] ?? DateTime(DateTime.now().year),
    );
  }
}
