import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicorn/widgets/LogIn/login_select_profile_type.dart';
import 'package:unicorn/widgets/custom_input_text.dart';

class MainDetails extends StatefulWidget {
  const MainDetails({Key? key}) : super(key: key);

  @override
  _MainDetailsState createState() => _MainDetailsState();
}

class _MainDetailsState extends State<MainDetails> {
  String? name;
  String? secondName;
  String? email;
  String? password;
  String? userUID;

  TextEditingController nameController = TextEditingController();
  TextEditingController secondNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool enable = false;

  var fields = {"name": 0, "secondName": 0, "email": 0, "password": 0};

  void noEmptyFields() {
    int sum = 0;
    for (int v in fields.values) {
      sum += v;
    }

    if (sum == 4 && enable == false) {
      setState(() {
        enable = !enable;
      });
    } else if (sum != 4 && enable == true) {
      setState(() {
        enable = !enable;
      });
    }
  }

  void createUserWithEmailAndPassword() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);

      userUID = userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-passowrd") {
        print(e.code);
      } else if (e.code == "email-already-in-use") {
        print(e.code);
      }
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
            Icons.clear,
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
                  "Create Your Account",
                  style: TextStyle(
                      fontFamily: "Geometric Sans-Serif",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              CustomInputText(
                labelName: "First Name",
                password: false,
                textController: nameController,
                getText: (val) {
                  name = val;
                  if (name != "") {
                    fields["name"] = 1;
                  } else {
                    fields["name"] = 0;
                  }
                  noEmptyFields();
                },
              ),
              CustomInputText(
                labelName: "Second Name",
                password: false,
                textController: secondNameController,
                getText: (val) {
                  secondName = val;
                  if (secondName!.isNotEmpty) {
                    fields["secondName"] = 1;
                  } else {
                    fields["secondName"] = 0;
                  }

                  noEmptyFields();
                },
              ),
              CustomInputText(
                labelName: "Email",
                password: false,
                textController: emailController,
                getText: (val) {
                  email = val;
                  if (email!.isNotEmpty) {
                    fields["email"] = 1;
                  } else {
                    fields["email"] = 0;
                  }

                  noEmptyFields();
                },
              ),
              CustomInputText(
                labelName: "Password",
                password: true,
                textController: passwordController,
                getText: (val) {
                  password = val;

                  if (password!.isNotEmpty) {
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
                      "Continue",
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
                            createUserWithEmailAndPassword();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SelectProfileType(
                                  userUID: userUID!,
                                ),
                              ),
                            );
                          }
                        : null,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
