import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicorn/widgets/LogIn/custom_input_text.dart';

class MainDetails extends StatefulWidget {
  const MainDetails({Key? key}) : super(key: key);

  @override
  _MainDetailsState createState() => _MainDetailsState();
}

class _MainDetailsState extends State<MainDetails> {
  String? firstName;
  String? secondName;
  String? email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.clear,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SizedBox(
        width: 1.sw,
        height: 1.sh,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 1.sw,
              padding: const EdgeInsets.only(left: 16, top: 2),
              child: const Text(
                "Create Your Account",
                style: TextStyle(
                    fontFamily: "Geometric Sans-Serif",
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const CustomInputText(
              labelName: "First Name",
            ),
            const CustomInputText(
              labelName: "Second Name",
            ),
            const CustomInputText(
              labelName: "Email",
            ),
            const CustomInputText(
              labelName: "Password",
            )
          ],
        ),
      ),
    );
  }
}
