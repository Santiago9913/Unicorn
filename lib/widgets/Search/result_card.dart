import 'package:flutter/material.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:unicorn/controllers/firebase_storage_controller.dart';
import 'package:unicorn/models/user.dart';
import 'package:unicorn/widgets/profile/main_profile_page.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    Key? key,
    required this.user,
    required this.imageUrl,
    required this.ownerUID,
    required this.userOwner,
  }) : super(key: key);

  final User user;
  final User userOwner;
  final String imageUrl;
  final String ownerUID;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FirebaseStorageController.registerView(user.userUID);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainProfilePage(
              user: user,
              ownerUID: ownerUID,
              userOwner: userOwner,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(left: 10.w, bottom: 10.h, top: 5.h),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF0E153A),
              radius: 25,
              child: user.profilePicUrl.isEmpty
                  ? const Icon(Icons.person, color: Colors.white)
                  : CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePicUrl),
                      radius: 25,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "${user.name} ${user.lastName} ",
                style: const TextStyle(
                  fontFamily: "Geometric Sans-Serif",
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
