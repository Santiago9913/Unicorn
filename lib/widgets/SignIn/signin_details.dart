import "package:flutter/material.dart";
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:unicorn/widgets/custom_input_text.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String? email;
  String? password;

  var fields = {"email": 0, "password": 0};
  bool enable = false;

  void noEmptyFields() {
    int sum = 0;
    for (int v in fields.values) {
      sum += v;
    }

    if (sum == 2 && enable == false) {
      setState(() {
        enable = !enable;
      });
    } else if (sum != 2 && enable == true) {
      setState(() {
        enable = !enable;
      });
    }
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();

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
      body: SizedBox(
        height: 1.sh,
        width: 1.sw,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomInputText(
              labelName: "Email",
              password: false,
              getText: (val) {
                email = val;
                if (email != "") {
                  fields["email"] = 1;
                } else {
                  fields["email"] = 0;
                }
                noEmptyFields();
              },
            ),
            CustomInputText(
              labelName: "Password",
              password: false,
              getText: (val) {
                password = val;
                if (email != "") {
                  fields["password"] = 1;
                } else {
                  fields["password"] = 0;
                }
                noEmptyFields();
              },
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: ElevatedButton(
                  child: const Text(
                    "Sign In",
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
                      onSurface: const Color(0xFF3D5AF1)),
                  onPressed: enable
                      ? () {
                          print("pressed");
                        }
                      : null,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                "Forgot password ?",
                style: TextStyle(
                  fontFamily: "Geometric Sans-Serif",
                  fontSize: 13,
                  color: Color(0xFF3D5AF1),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
