import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InterestsPage extends StatelessWidget {
  const InterestsPage({Key? key}) : super(key: key);

  //String? interest;

  final bool enable = false;

  //var fields = {"interest": 0};

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
      height: 0.89.sh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
                      label: const Text(
                        "Crypto",
                        style: TextStyle(
                          fontFamily: "Geometric Sans-Serif",
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: Image.asset("assets/icons/Other06.png"),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF0E153A),
                        fixedSize: Size(0.9.sw, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {

                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextButton.icon(
                      label: const Text(
                        "Fintech",
                        style: TextStyle(
                          fontFamily: "Geometric Sans-Serif",
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: Image.asset("assets/icons/Other04.png"),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF0E153A),
                        fixedSize: Size(0.9.sw, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {

                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextButton.icon(
                      label: const Text(
                        "Blockchain",
                        style: TextStyle(
                          fontFamily: "Geometric Sans-Serif",
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: Image.asset("assets/icons/Other09.png"),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF0E153A),
                        fixedSize: Size(0.9.sw, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {

                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextButton.icon(
                      label: const Text(
                        "Innovation",
                        style: TextStyle(
                          fontFamily: "Geometric Sans-Serif",
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: Image.asset("assets/icons/Other18.png"),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF0E153A),
                        fixedSize: Size(0.9.sw, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {

                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextButton.icon(
                      label: const Text(
                        "Random",
                        style: TextStyle(
                          fontFamily: "Geometric Sans-Serif",
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: Image.asset("assets/icons/Other20.png"),
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFF0E153A),
                        fixedSize: Size(0.9.sw, 70),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {

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
                    onPressed: () {
                      //createUserWithEmailAndPassword();
                      print("account created");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InterestsPage(),
                        ),
                      );;
                    }
                  ),
                ),
              ]
          )
          )
          ]
        ),
      ),
    ),
    );
  }
}
