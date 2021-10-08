import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicorn/widgets/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unicorn/widgets/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Unicorn());
}

class Unicorn extends StatefulWidget {
  const Unicorn({Key? key}) : super(key: key);

  @override
  State<Unicorn> createState() => _UnicornState();
}

class _UnicornState extends State<Unicorn> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  final db = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    //Prevent portrait
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("Error");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return ScreenUtilInit(
            builder: () => const MaterialApp(
              home: MainPage(),
              debugShowCheckedModeBanner: false,
            ),
          );
        }

        return const SplashScreen();
      },
    );
  }
}
