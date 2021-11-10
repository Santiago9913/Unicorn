import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unicorn/controllers/firebase_storage_controller.dart';
import 'package:unicorn/models/post.dart';
import 'package:unicorn/models/user.dart';

class CratePostPage extends StatefulWidget {
  const CratePostPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<CratePostPage> createState() => _CratePostPageState();
}

class _CratePostPageState extends State<CratePostPage> {
  final TextEditingController contentController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  late File imageFile;
  String imagePath = "";
  String content = "";

  Future<void> uploadPost() async {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);

    Post post = Post(
      content: content,
      owner: widget.user.userUID,
      datePosted: date,
    );

    await FirebaseStorageController.uploadPostImageAndPost(
        post, imageFile, widget.user.userUID);
  }

  Future<String> _imgPicker(ImageSource source) async {
    XFile? image = await _picker.pickImage(source: source, imageQuality: 50);

    if (image != null) {
      File file = File(image.path);
      setState(() {
        imageFile = file;
        imagePath = file.path;
      });

      return image.path;
    }

    return "";
  }

  void _showPicker(context) {
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
                    onTap: () async {
                      FocusScope.of(context).requestFocus(
                        FocusNode(),
                      );
                      await _imgPicker(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () async {
                    FocusScope.of(context).requestFocus(
                      FocusNode(),
                    );
                    await _imgPicker(ImageSource.camera);
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
              FocusScope.of(context).requestFocus(
                FocusNode(),
              );
              content = contentController.text;

              if (imagePath.isEmpty || content.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        const Text("Please insert an image and text content!"),
                    backgroundColor: Colors.red.shade600,
                  ),
                );
              } else {
                await uploadPost();
                Navigator.of(context).pop();
              }
            },
          ),
          title: const Center(
            child: Text(
              "Create Post",
              style: TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                color: Colors.red,
                icon: const Icon(Icons.clear),
                onPressed: () {
                  FocusScope.of(context).requestFocus(
                    FocusNode(),
                  );
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            height: 0.7.sh,
            width: 1.sw,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  maxLength: 90,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    hintText: "Content. Max 90 words",
                    labelStyle: TextStyle(color: Colors.grey),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                  ),
                  cursorColor: const Color(0xFF3D5AF1),
                  maxLines: 5,
                  controller: contentController,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // padding: const EdgeInsets.only(top: 20),
                      height: 0.3.sh,
                      width: 0.9.sw,
                      decoration: imagePath.isEmpty
                          ? null
                          : BoxDecoration(
                              image: DecorationImage(
                                image: Image.file(imageFile).image,
                                // fit: BoxFit.fill,
                              ),
                            ),
                      child: Center(
                        child: Container(
                          // padding: const EdgeInsets.only(top: 20),
                          width: 0.9.sw,
                          height: 0.3.sh,
                          color: Colors.grey.withOpacity(0.5),
                          child: IconButton(
                            color: Colors.white,
                            icon: const Icon(Icons.camera_alt_outlined),
                            onPressed: () {
                              _showPicker(context);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
