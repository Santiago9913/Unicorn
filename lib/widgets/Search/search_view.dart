import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unicorn/controllers/firebase_storage_controller.dart';
import 'package:unicorn/models/user.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:unicorn/widgets/Home/home_page.dart';
import 'package:unicorn/widgets/Search/result_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key? key,
    required this.input,
    required this.user,
  }) : super(key: key);

  final String input;
  final User user;

  @override
  State createState() {
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchPage> {
  late List<User> users;

  Future<List<User>> getResults() async {
    List<User> results =
        await FirebaseStorageController.queryOnUserName(widget.input, widget.user);
    users = results;
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF0E153A),
          statusBarIconBrightness: Brightness.light,
        ),
        backgroundColor: const Color(0xFF0E153A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(
                  user: widget.user,
                ),
              ),
              (route) => false,
            );
          },
        ),
        title: Container(
          width: 270,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromRGBO(238, 243, 248, 1),
            boxShadow: const [
              BoxShadow(
                  color: Color.fromRGBO(238, 243, 248, 1), spreadRadius: 3),
            ],
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search,
                color: Color.fromRGBO(104, 106, 108, 1),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: 220.0,
                height: 15,
                child: TextField(
                  cursorColor: Colors.black,
                  maxLines: 1,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (String input) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchPage(
                          input: input,
                          user: widget.user,
                        ),
                      ),
                    );
                  },
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Search',
                  ),
                  style: const TextStyle(
                    color: Color.fromRGBO(104, 106, 108, 1),
                    decoration: TextDecoration.none,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      body: FutureBuilder(
          future: getResults(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none &&
                !snapshot.hasData) {
              return Container(
                child: const Center(
                  child: Text(
                      "No Connection, please check your internet connection"),
                ),
              );
            }
            if (snapshot.hasError) {
              return Container(
                child: const Center(
                  child: Text(
                      "No Connection, please check your internet connection"),
                ),
              );
              ;
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  User user = users[index];
                  return ResultCard(user: user, imageUrl: user.profilePicUrl);
                },
              );
            }

            return Container(
              child: const Text("Loading..."),
            );
          }),
    );
  }
}
