import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:unicorn/widgets/Weekly/weekly_screen.dart';
import 'package:unicorn/widgets/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unicorn/widgets/splash_screen.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51K1zfWCLAaGpJJL2hfKF9kJzRnSIzv21kvzFtmI5FaQItnvflsQoZpi4WsqU24dowBPx3VAOvDvWjwZSgFb2vZkk00K5FEkyt2";
  Directory directory = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(directory.path);
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://5d1e572a71054ba486c0ecda291b7bde@o1032593.ingest.sentry.io/5999553';
    },
    appRunner: () => runApp(const Unicorn()),
  );
}

class Unicorn extends StatefulWidget {
  const Unicorn({Key? key}) : super(key: key);

  @override
  State<Unicorn> createState() => _UnicornState();
}

class _UnicornState extends State<Unicorn> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

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
