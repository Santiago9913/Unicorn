import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:unicorn/controllers/hive_controller.dart';
import 'package:unicorn/models/user.dart';
import 'package:unicorn/widgets/Contact/contact_page.dart';
import 'package:unicorn/widgets/Home/home_page.dart';
import 'package:unicorn/widgets/profile/display_card.dart';
import 'package:unicorn/widgets/profile/edit_proile_page.dart';
import 'package:unicorn/widgets/profile/info_card.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

class MainProfilePage extends StatefulWidget {
  const MainProfilePage({
    Key? key,
    required this.user,
    this.ownerUID = "",
    this.userOwner,
  }) : super(key: key);

  final User user;
  final String ownerUID;
  final User? userOwner;

  @override
  _MainProfilePageState createState() => _MainProfilePageState();
}

class _MainProfilePageState extends State<MainProfilePage> {
  String bannerPicUrl = "";
  String profilePicUrl = "";

  late Map<String, dynamic> paymentData;

  BoxDecoration? bannerImageDecode = const BoxDecoration();
  Widget profileImageDecode = const Icon(
    Icons.person,
    color: Colors.black,
  );

  cacheImagesIfFileNotExistsProfile() {
    setState(() {
      if (widget.user.profilePicUrl.isNotEmpty) {
        profileImageDecode = CircleAvatar(
          backgroundImage:
              CachedNetworkImageProvider(widget.user.profilePicUrl),
          radius: 38,
        );
      } else {
        const Icon(
          Icons.person,
          color: Colors.black,
        );
      }
    });
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bannerPicUrl = widget.user.getBannerPicURL;
    profilePicUrl = widget.user.getProfilePicURL;

    if (bannerPicUrl != "" && widget.ownerUID == "") {
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

    if (profilePicUrl != "" && widget.ownerUID == "") {
      HiveController.retrieveImage("${widget.user.userUID}/profile.jpeg")
          .then((value) {
        setState(() {
          profileImageDecode = value.isEmpty
              ? const Icon(
                  Icons.person,
                  color: Colors.black,
                )
              : CircleAvatar(
                  backgroundImage: Image.memory(value).image,
                  radius: 38,
                );
        });
      }).catchError((error, stackTrace) {
        cacheImagesIfFileNotExistsProfile();
      });
    }
  }

  Future<void> checkout() async {
    const url_un = 'https://unicornm.herokuapp.com/api/stripe/generatePayment';
    final formatter = DateFormat('yyyy-MM-dd');
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month, now.day);
    DateTime finishDate = DateTime(startDate.year, startDate.month, startDate.day + 7);

    String id = widget.user.userUID.toString();
    String start = formatter.format(startDate).toString();
    String end = formatter.format(finishDate).toString();

    final response = await http.post(
      Uri.parse(url_un),
      headers: <String, String> {
        'content-type' : 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String> {
        'id' : id,
        'startDate' : start,
        'finishDate' : end,
      }),
    );

    paymentData = json.decode(response.body);


    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        applePay: false,
        googlePay: true,
        style: ThemeMode.light,
        testEnv: true,
        merchantCountryCode: "US",
        merchantDisplayName: "Promote profile",
        paymentIntentClientSecret: paymentData["payment"],
      ),
    );
    try {
      await Stripe.instance.presentPaymentSheet();
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Payment Succesfull")));
    } catch (e) {
      print(e.toString());
    }
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
                          widget.userOwner == null
                              ? Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomeScreen(user: widget.user),
                                  ),
                                  (route) => false,
                                )
                              : Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HomeScreen(user: widget.userOwner),
                                  ),
                                  (route) => false,
                                );
                        },
                      ),
                    ),
                    flexibleSpace: Container(
                      height: 0.183.sh,
                      decoration: widget.ownerUID == ""
                          ? bannerImageDecode
                          : widget.user.bannerPicURL == ""
                              ? null
                              : BoxDecoration(
                                  image: DecorationImage(
                                    image: CachedNetworkImageProvider(
                                        widget.user.bannerPicURL),
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
                        child: widget.ownerUID == ""
                            ? profileImageDecode
                            : widget.user.profilePicUrl == ""
                                ? const Icon(
                                    Icons.person,
                                    color: Colors.black,
                                  )
                                : CircleAvatar(
                                    backgroundImage: CachedNetworkImageProvider(
                                        widget.user.profilePicUrl),
                                    radius: 38,
                                  ),
                      ),
                    ),
                  ),
                ],
                clipBehavior: Clip.none,
              ),
              Expanded(
                child: Container(
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
                            widget.ownerUID == ""
                                ? IconButton(
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
                                            transitionsBuilder: (context,
                                                animation,
                                                secondaryAnimation,
                                                child) {
                                              const begin = Offset(0.0, 1.0);
                                              const end = Offset.zero;
                                              const curve = Curves.ease;

                                              var tween = Tween(
                                                      begin: begin, end: end)
                                                  .chain(
                                                      CurveTween(curve: curve));

                                              return SlideTransition(
                                                position:
                                                    animation.drive(tween),
                                                child: child,
                                              );
                                            },
                                          ),
                                          (route) => false);
                                    },
                                  )
                                : const Padding(
                                    padding: EdgeInsets.only(left: 30),
                                  ),
                            Container(
                              margin: EdgeInsets.only(left: 37.w),
                              child: ElevatedButton(
                                child: Text(
                                  widget.ownerUID == ""
                                      ? "Promote me"
                                      : "Contact me",
                                  style: const TextStyle(
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
                                onPressed: ()  {
                                  widget.ownerUID == ""
                                      ? checkout()
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ContactPage(
                                              user: widget.user,
                                            ),
                                          ),
                                        );
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
                                  widget.user.getUserType == 'Investor'
                                      ? "Investments"
                                      : 'Startups',
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                              Tab(
                                child: Text(
                                  widget.user.getUserType == 'Investor'
                                      ? "Investors"
                                      : "Interests",
                                  style: const TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: TabBarView(
                            children: <Widget>[
                              SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CustomDisplayInfoCard(
                                        title: "Location",
                                        info: "Info",
                                        isLink: false,
                                        isOwner: false,
                                      ),
                                      widget.ownerUID == ""
                                          ? widget.user.getLinkedInProfile
                                                  .isNotEmpty
                                              ? CustomDisplayInfoCard(
                                                  title: "LinkedIn Profile",
                                                  info: widget
                                                      .user.getLinkedInProfile,
                                                  isLink: true,
                                                  isOwner: true,
                                                )
                                              : const Text("")
                                          : widget.user.getLinkedInProfile
                                                  .isNotEmpty
                                              ? CustomDisplayInfoCard(
                                                  title: "LinkedIn Profile",
                                                  info: widget
                                                      .user.getLinkedInProfile,
                                                  isLink: true,
                                                  isOwner: false,
                                                  uid: widget.user.userUID,
                                                  user: widget.user,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
