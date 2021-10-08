import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicorn/widgets/LogIn/login_main_details.dart';
import 'package:unicorn/widgets/SignIn/signin_details.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    //Change the color of the notification bar, to match the main color in this view
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF3D5AF1),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF3D5AF1),
      body: Center(
        child: SizedBox(
          height: 1.sh,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/Saly1.png',
                  height: 300.h,
                ),
                const Text(
                  "Unicorn",
                  style: TextStyle(
                    fontFamily: "Fredoka One",
                    fontSize: 70,
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 60, 0, 20),
                  child: TextButton(
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        fontFamily: "Geometric Sans-Serif",
                        fontSize: 20,
                        color: Color(0xFF3D5AF1),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      fixedSize: Size(0.9.sw, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainDetails(),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: TextButton(
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        fontFamily: "Geometric Sans-Serif",
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      primary: const Color(0xFF3D5AF1),
                      fixedSize: Size(0.9.sw, 48),
                    ),
                    onPressed: () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInPage(),
                        ),
                      );;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
