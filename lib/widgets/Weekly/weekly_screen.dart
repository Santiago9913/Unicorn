import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:unicorn/controllers/firebase_storage_controller.dart';
import 'package:unicorn/models/user.dart';
import 'package:unicorn/widgets/Search/result_card.dart';

class WeeklyScreen extends StatefulWidget {
  const WeeklyScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  _WeeklyScreenState createState() => _WeeklyScreenState();
}

class _WeeklyScreenState extends State<WeeklyScreen> {
  List<User> users = [];

  Future<List<User>> getUsersPromoted() async {
    return await FirebaseStorageController.queryPromoted(widget.user.userUID);
  }

  @override
  void initState() {
    getUsersPromoted().then((List<User> value) {
      setState(() {
        users = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: getUsersPromoted(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none &&
            !snapshot.hasData) {
          return Container(
            height: 1.sh,
            child: const Center(
              child: Text(
                "No Connection, please check your internet connection",
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Container(
            height: 1.sh,
            child: const Center(
              child: Text("Ups, no information could be found"),
            ),
          );
        }
        if (snapshot.hasData) {
          if (users.isEmpty) {
            print(users);
            return SizedBox(
              height: 1.sh,
              width: 1.sw,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/Other09.png',
                    height: 200.h,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: SizedBox(
                      width: 200,
                      child: Text(
                        "You don’t have posts right know. Follow some one to see news on your feed",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFFB2B2B2),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                User userResult = users[index];
                return ResultCard(
                  user: userResult,
                  imageUrl: userResult.profilePicUrl,
                  ownerUID: widget.user.userUID,
                  userOwner: widget.user,
                );
              },
            );
          }
        }

        return Container(
          child: const Text("loading..."),
        );
      },
    ));
  }
}
