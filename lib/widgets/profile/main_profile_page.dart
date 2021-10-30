import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicorn/models/user.dart';
import 'package:unicorn/widgets/Home/home_page.dart';
import 'package:unicorn/widgets/profile/display_card.dart';
import 'package:unicorn/widgets/profile/edit_proile_page.dart';
import 'package:unicorn/widgets/profile/info_card.dart';

class MainProfilePage extends StatefulWidget {
  const MainProfilePage({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User user;

  @override
  _MainProfilePageState createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage> {
  String bannerPicUrl = "";
  String profilePicUrl = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bannerPicUrl = widget.user.getBannerPicURL;
    profilePicUrl = widget.user.getProfilePicURL;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          height: 1.sh,
          child: Column(
            children: [
              Stack(
                children: [
                  AppBar(
                    systemOverlayStyle: const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.light,
                    ),
                    backgroundColor:
                        bannerPicUrl.isEmpty ? const Color(0xFF3D5AF1) : null,
                    leading: Container(
                      margin:
                          const EdgeInsets.only(top: 16, left: 12, bottom: 50),
                      child: IconButton(
                        alignment: Alignment.topLeft,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  HomeScreen(user: widget.user),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                    title: Container(
                      margin: const EdgeInsets.only(bottom: 40),
                      width: 250.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: Colors.grey.shade400,
                          ),
                          Container(
                            width: 220.w,
                            height: 15.h,
                            margin: const EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.only(left: 5),
                            child: TextField(
                              maxLines: 1,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: "Search",
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    flexibleSpace: Container(
                      height: 0.183.sh,
                      decoration: bannerPicUrl.isEmpty
                          ? null
                          : BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(bannerPicUrl),
                                fit: BoxFit.fill,
                              ),
                            ),
                    ),
                    elevation: 0,
                    toolbarHeight: 0.15.sh,
                  ),
                  Positioned(
                    top: 0.12.sh,
                    child: Container(
                      padding: const EdgeInsets.only(left: 18),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 40,
                        child: profilePicUrl.isEmpty
                            ? const Icon(
                                Icons.person,
                                color: Colors.black,
                              )
                            : CircleAvatar(
                                backgroundImage: NetworkImage(profilePicUrl),
                                radius: 38,
                              ),
                      ),
                    ),
                  ),
                ],
                clipBehavior: Clip.none,
              ),
              Container(
                height: 0.815.sh,
                width: 1.sw,
                color: Colors.transparent,
                child: Container(
                  margin: EdgeInsets.only(left: 20.w, top: 50.h, right: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 0.35.sw,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Text(
                                "${widget.user.getName} ${widget.user.getlastName}",
                                maxLines: 1,
                                style: const TextStyle(
                                    fontFamily: "Geometric Sans-Serif",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            iconSize: 18,
                            icon: const Icon(
                              Icons.edit,
                            ),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                        EditProfilePage(
                                      user: widget.user,
                                    ),
                                    transitionsBuilder: (context, animation,
                                        secondaryAnimation, child) {
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
                                  (route) => false);
                            },
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 37.w),
                            child: ElevatedButton(
                              child: const Text(
                                "Promote me",
                                style: TextStyle(
                                  fontFamily: "Geometric Sans-Serif",
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                splashFactory: NoSplash.splashFactory,
                                elevation: 0,
                                primary: const Color(0xFF3D5AF1),
                                fixedSize: Size(0.3.sw, 20),
                                onSurface: const Color(0xFF3D5AF1),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                print("Promote me");
                              },
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: const Text("0 Followers | 0 Investments"),
                      ),
                      Container(
                        child: TabBar(
                          indicatorColor: const Color(0xFF3D5AF1),
                          tabs: [
                            const Tab(
                              child: Text(
                                "Information",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            Tab(
                              child: Text(
                                widget.user.getUserType == 'Investor' ? "Investments" : 'Startups',
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                            Tab(
                              child: Text(
                                widget.user.getUserType == 'Investor' ? "Investors" : "Interests",
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const CustomDisplayInfoCard(
                                      title: "Location",
                                      info: "Info",
                                      isLink: false,
                                    ),
                                    widget.user.getLinkedInProfile.isNotEmpty
                                        ? CustomDisplayInfoCard(
                                            title: "LinkedIn Profile",
                                            info:
                                                widget.user.getLinkedInProfile,
                                            isLink: true,
                                          )
                                        : const Text(""),
                                  ],
                                ),
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: const [],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
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
