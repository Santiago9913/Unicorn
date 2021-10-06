import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicorn/widgets/main_page.dart';

void main() {
  runApp(const Unicorn());
}

class Unicorn extends StatelessWidget {
  const Unicorn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Prevent portrait
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );

    return ScreenUtilInit(
      builder: () => const MaterialApp(
        home: MainPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
