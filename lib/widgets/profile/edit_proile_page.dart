import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicorn/controllers/firebase_storage_controller.dart';
import 'package:unicorn/controllers/hive_controller.dart';
import 'package:unicorn/models/user.dart';
import 'package:unicorn/widgets/profile/main_profile_page.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController linkedInProfileController = TextEditingController();

  String bannerPicUrl = "";
  String profilePicUrl = "";

  BoxDecoration? bannerImageDecode = const BoxDecoration();
  Image profileImageDecode = Image.asset("assets/icons/blank.png");

  final ImagePicker _picker = ImagePicker();

  _imgFromCamera(String name) async {
    // var status = await Permission.camera.status;

    // if (await Permission.camera.isDenied) {
    //   await Permission.camera.request();
    // }

    // if (await Permission.camera.isGranted) {
    XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);

    if (image != null) {
      String storagePath = 'users/${widget.user.getUserUID}';
      String filePath = image.path;
      File file = File(image.path);
      String fileName = name;

      String url = await FirebaseStorageController.uploadImageToStorage(
          storagePath, filePath, fileName, widget.user.userUID);

      setState(() {
        if (name == 'profile') {
          profilePicUrl = url;
          widget.user.setProfilePicture(url);
          HiveController.storeImage(
              "${widget.user.userUID}/profile.jpeg", file);
          HiveController.retrieveImage("${widget.user.userUID}/profile.jpeg")
              .then((value) {
            setState(() {
              profileImageDecode = value.isEmpty
                  ? Image.asset("assets/icons/blank.png")
                  : Image.memory(value);
            });
          });
        } else if (name == 'banner') {
          bannerPicUrl = url;
          widget.user.setBannerPicture(url);
          HiveController.storeImage("${widget.user.userUID}/banner.jpeg", file);
          HiveController.retrieveImage("${widget.user.userUID}/banner.jpeg")
              .then((value) {
            setState(() {
              bannerImageDecode = BoxDecoration(
                image: DecorationImage(
                  image: Image.memory(value).image,
                  fit: BoxFit.fill,
                ),
              );
            });
          });
        }
      });
    }
    // }
  }

  _imgFromGallery(String name) async {
    XFile? image =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (image != null) {
      String storagePath = 'users/${widget.user.getUserUID}';
      File file = File(image.path);
      String filePath = image.path;
      String fileName = name;

      String url = await FirebaseStorageController.uploadImageToStorage(
          storagePath, filePath, fileName, widget.user.userUID);

      if (name == 'profile') {
        profilePicUrl = url;
        widget.user.setProfilePicture(url);
        HiveController.storeImage("${widget.user.userUID}/profile.jpeg", file);
        HiveController.retrieveImage("${widget.user.userUID}/profile.jpeg")
            .then((value) {
          setState(() {
            profileImageDecode = value.isEmpty
                ? Image.asset("assets/icons/blank.png")
                : Image.memory(value);
          });
        });
      } else if (name == 'banner') {
        bannerPicUrl = url;
        widget.user.setBannerPicture(url);
        HiveController.storeImage("${widget.user.userUID}/banner.jpeg", file);
        HiveController.retrieveImage("${widget.user.userUID}/banner.jpeg")
            .then((value) {
          setState(() {
            bannerImageDecode = BoxDecoration(
              image: DecorationImage(
                image: Image.memory(value).image,
                fit: BoxFit.fill,
              ),
            );
          });
        });
      }
    }
  }

  void _showPicker(context, String name) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery(name);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera(name);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  cacheImagesIfFileNotExistsBanner() {
    setState(() {
      if (widget.user.bannerPicURL.isNotEmpty) {
        bannerImageDecode = BoxDecoration(
          image: DecorationImage(
            image: CachedNetworkImageProvider(widget.user.bannerPicURL),
            fit: BoxFit.fill,
          ),
        );
      } else {
        bannerImageDecode = null;
      }
    });
  }

  cacheImagesIfFileNotExistsProfile() {
    setState(() {
      if (widget.user.profilePicUrl.isNotEmpty) {
        profileImageDecode =
            Image(image: CachedNetworkImageProvider(widget.user.profilePicUrl));
      } else {
        Image.asset("assets/icons/blank.png");
      }
    });
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.user.getName;
    lastNameController.text = widget.user.getlastName;
    linkedInProfileController.text = widget.user.getLinkedInProfile;
    bannerPicUrl = widget.user.getBannerPicURL;
    profilePicUrl = widget.user.getProfilePicURL;

    if (widget.user.bannerPicURL != "") {
      HiveController.retrieveImage("${widget.user.userUID}/banner.jpeg")
          .then((value) {
        setState(() {
          bannerImageDecode = value.isEmpty
              ? null
              : BoxDecoration(
                  image: DecorationImage(
                    image: Image.memory(value).image,
                    fit: BoxFit.fill,
                  ),
                );
        });
      }).catchError((error, stackTrace) {
        cacheImagesIfFileNotExistsBanner();
      });
    }

    if (widget.user.profilePicUrl != "") {
      HiveController.retrieveImage("${widget.user.userUID}/profile.jpeg")
          .then((value) {
        setState(() {
          profileImageDecode = value.isEmpty
              ? Image.asset("assets/icons/blank.png")
              : Image.memory(value);
        });
      }).catchError((error, stackTrace) {
        cacheImagesIfFileNotExistsProfile();
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    lastNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            color: const Color(0xFF3D5AF1),
            icon: const Icon(Icons.check),
            onPressed: () async {
              if (nameController.text != widget.user.getName) {
                await widget.user.setName(nameController.text);
              }
              if (lastNameController.text != widget.user.getlastName) {
                await widget.user.setLastName(lastNameController.text);
              }
              if (linkedInProfileController.text !=
                  widget.user.getLinkedInProfile) {
                await widget.user
                    .setLinkedInProfile(linkedInProfileController.text);
              }
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      MainProfilePage(
                    user: widget.user,
                  ),
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) {
                    const begin = Offset(0.0, 1.0);
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end)
                        .chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
          title: const Center(
            child: Text(
              "Edit Profile",
              style: TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                color: Colors.transparent,
                icon: const Icon(Icons.check),
                onPressed: () {},
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: 1.sh,
            width: 1.sw,
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 0.183.sh,
                      width: 0.8.sw,
                      decoration: bannerImageDecode,
                      child: Center(
                        child: Container(
                          width: 0.8.sw,
                          height: 0.183.sh,
                          color: Colors.grey.withOpacity(0.5),
                          child: IconButton(
                            color: Colors.white,
                            icon: const Icon(Icons.camera_alt_outlined),
                            onPressed: () {
                              _showPicker(context, 'banner');
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFF3D5AF1),
                      radius: 50,
                      child: CircleAvatar(
                        backgroundImage: profileImageDecode.image,
                        radius: 48,
                        child: Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          child: IconButton(
                            color: Colors.white,
                            icon: Icon(Icons.camera_alt_outlined),
                            onPressed: () {
                              _showPicker(context, 'profile');
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF3D5AF1)),
                    ),
                  ),
                  cursorColor: const Color(0xFF3D5AF1),
                  maxLines: 1,
                  controller: nameController,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Last Name",
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF3D5AF1)),
                    ),
                  ),
                  cursorColor: Color(0xFF3D5AF1),
                  maxLines: 1,
                  controller: lastNameController,
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "LinkendIn",
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF3D5AF1)),
                    ),
                  ),
                  cursorColor: const Color(0xFF3D5AF1),
                  maxLines: 1,
                  controller: linkedInProfileController,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
