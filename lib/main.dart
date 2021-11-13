import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:unicorn/widgets/Contact/contact_page.dart';
import 'package:unicorn/widgets/main_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:unicorn/widgets/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
              home: ContactPage(),
              debugShowCheckedModeBanner: false,
            ),
          );
        }

        return const SplashScreen();
      },
    );
  }
}
