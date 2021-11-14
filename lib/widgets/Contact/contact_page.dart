import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicorn/controllers/firebase_storage_controller.dart';
import 'package:unicorn/models/user.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController subjetcController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subjetcController.dispose();
    contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            print("send");
            await FirebaseStorageController.updateUser(widget.user.userUID,
                {"numContacts": widget.user.numContacts++});

            Navigator.of(context).pop();
          },
        ),
        title: const Center(
          child: Text(
            "Contact Form",
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
                // FocusScope.of(context).requestFocus(
                //   FocusNode(),
                // );
                // Navigator.of(context).pop();
                print("back");
              },
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        height: 0.7.sh,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: subjetcController,
                maxLines: 1,
                cursorColor: const Color(0xFF3D5AF1),
                decoration: const InputDecoration(
                  hintText: "Subjetc",
                  labelText: "Subject",
                  labelStyle: TextStyle(color: Color(0xFF3D5AF1)),
                  focusColor: Color(0xFF3D5AF1),
                  fillColor: Color(0xFF3D5AF1),
                  hoverColor: Color(0xFF3D5AF1),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF3D5AF1)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF3D5AF1)),
                  ),
                ),
              ),
              TextField(
                controller: contentController,
                maxLength: 90,
                maxLines: 5,
                cursorColor: const Color(0xFF3D5AF1),
                decoration: const InputDecoration(
                  hintText: "Content",
                  labelText: "Content",
                  labelStyle: TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
