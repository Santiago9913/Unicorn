import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicorn/models/user.dart';
import 'package:unicorn/widgets/Home/home_page.dart';

class InterestsPage extends StatefulWidget {
  InterestsPage({Key? key, required this.user}) : super(key: key);

  late final User user;

  @override
  State<InterestsPage> createState() => _InterestsPageState();
}

class _InterestsPageState extends State<InterestsPage> {
  bool enable = false;
  bool hasBeenPressedCrypto = false;
  bool hasBeenPressedFintech = false;
  bool hasBeenPressedBlockchain = false;
  bool hasBeenPressedInnovation = false;
  bool hasBeenPressedRandom = false;
  Color bottonPressed = const Color(0xFFE2F3F5);
  Color bottonUnpressed = const Color(0xFF0E153A);
  Color textColorPressed = Colors.black;

  Map<String, dynamic> getSelected() {
    Map<String, dynamic> selected = {};

    if (hasBeenPressedCrypto) {
      selected["Crypto"] = "Crypto";
    }
    if (hasBeenPressedFintech) {
      selected["Fintech"] = "Fintech";
    }
    if (hasBeenPressedBlockchain) {
      selected["Blockchain"] = "Blockchain";
    }
    if (hasBeenPressedInnovation) {
      selected["Innovation"] = "Innovation";
    }
    if (hasBeenPressedRandom) {
      selected["Random"] = "Random";
    }

    return selected;
  }

  void Selected() {
    if (hasBeenPressedCrypto ||
        hasBeenPressedFintech ||
        hasBeenPressedBlockchain ||
        hasBeenPressedInnovation ||
        hasBeenPressedRandom == true) {
      enable = true;
    } else {
      enable = false;
    }
  }

  uploadUserInterests() async {
    DatabaseReference dbReference = widget.user.getDBReference;
    String userId = widget.user.getUserUID;
    try {
      DatabaseReference userReference =
          dbReference.child("users/$userId/interests/");
      Map<String, dynamic> mapInterest = getSelected();
      await userReference.update(mapInterest);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_backspace,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: 1.sw,
          height: 1.sh,
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Container(
              width: 1.sw,
              padding: const EdgeInsets.only(left: 16, top: 2),
              child: const Text(
                "Select your interests:",
                style: TextStyle(
                    fontFamily: "Geometric Sans-Serif",
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 60, 0, 15),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextButton.icon(
                        label: Text(
                          "Crypto",
                          style: TextStyle(
                            fontFamily: "Geometric Sans-Serif",
                            fontSize: 25,
                            color: hasBeenPressedCrypto
                                ? textColorPressed
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        icon: Image.asset("assets/icons/Other06.png"),
                        style: ElevatedButton.styleFrom(
                          elevation: hasBeenPressedCrypto ? 30 : 0,
                          splashFactory: NoSplash.splashFactory,
                          primary: hasBeenPressedCrypto
                              ? bottonPressed
                              : bottonUnpressed,
                          fixedSize: Size(0.9.sw, 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            hasBeenPressedCrypto = !hasBeenPressedCrypto;
                          });
                          Selected();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextButton.icon(
                        label: Text(
                          "Fintech",
                          style: TextStyle(
                            fontFamily: "Geometric Sans-Serif",
                            fontSize: 25,
                            color: hasBeenPressedFintech
                                ? textColorPressed
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        icon: Image.asset("assets/icons/Other04.png"),
                        style: ElevatedButton.styleFrom(
                          elevation: hasBeenPressedFintech ? 30 : 0,
                          splashFactory: NoSplash.splashFactory,
                          primary: hasBeenPressedFintech
                              ? bottonPressed
                              : bottonUnpressed,
                          fixedSize: Size(0.9.sw, 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            hasBeenPressedFintech = !hasBeenPressedFintech;
                          });
                          Selected();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextButton.icon(
                        label: Text(
                          "Blockchain",
                          style: TextStyle(
                            fontFamily: "Geometric Sans-Serif",
                            fontSize: 25,
                            color: hasBeenPressedBlockchain
                                ? textColorPressed
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        icon: Image.asset("assets/icons/Other09.png"),
                        style: ElevatedButton.styleFrom(
                          elevation: hasBeenPressedBlockchain ? 30 : 0,
                          splashFactory: NoSplash.splashFactory,
                          primary: hasBeenPressedBlockchain
                              ? bottonPressed
                              : bottonUnpressed,
                          fixedSize: Size(0.9.sw, 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            hasBeenPressedBlockchain =
                                !hasBeenPressedBlockchain;
                          });
                          Selected();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextButton.icon(
                        label: Text(
                          "Innovation",
                          style: TextStyle(
                            fontFamily: "Geometric Sans-Serif",
                            fontSize: 25,
                            color: hasBeenPressedInnovation
                                ? textColorPressed
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        icon: Image.asset("assets/icons/Other18.png"),
                        style: ElevatedButton.styleFrom(
                          elevation: hasBeenPressedInnovation ? 30 : 0,
                          splashFactory: NoSplash.splashFactory,
                          primary: hasBeenPressedInnovation
                              ? bottonPressed
                              : bottonUnpressed,
                          fixedSize: Size(0.9.sw, 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            hasBeenPressedInnovation =
                                !hasBeenPressedInnovation;
                          });
                          Selected();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: TextButton.icon(
                        label: Text(
                          "Random",
                          style: TextStyle(
                            fontFamily: "Geometric Sans-Serif",
                            fontSize: 25,
                            color: hasBeenPressedRandom
                                ? textColorPressed
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        icon: Image.asset("assets/icons/Other20.png"),
                        style: ElevatedButton.styleFrom(
                          elevation: hasBeenPressedRandom ? 30 : 0,
                          splashFactory: NoSplash.splashFactory,
                          primary: hasBeenPressedRandom
                              ? bottonPressed
                              : bottonUnpressed,
                          fixedSize: Size(0.9.sw, 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            hasBeenPressedRandom = !hasBeenPressedRandom;
                          });
                          Selected();
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: ElevatedButton(
                      child: const Text(
                        "Start",
                        style: TextStyle(
                          fontFamily: "Geometric Sans-Serif",
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: const Color(0xFF3D5AF1),
                          fixedSize: Size(0.88.sw, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          onSurface: const Color(0xFF3D5AF1)),
                      onPressed: enable
                          ? () async {
                              await uploadUserInterests();
                              {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                        user: widget.user,
                                      ),
                                    ),
                                    (route) => false);
                              }
                            }
                          : null,
                    ),
                  ),
                ]))
          ]),
        ),
      ),
    );
  }
}
