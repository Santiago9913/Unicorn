import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_performance/firebase_performance.dart';
import "package:flutter/material.dart";
import 'package:flutter/services.dart';
import "package:flutter_screenutil/flutter_screenutil.dart";
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicorn/controllers/firebase_storage_controller.dart';
import 'package:unicorn/controllers/location_controller.dart';
import 'package:unicorn/models/user.dart' as user_model;
import 'package:unicorn/widgets/Home/home_page.dart';
import 'package:unicorn/widgets/LogIn/login_2fa.dart';
import 'package:unicorn/widgets/Survey/survey.dart';
import 'package:unicorn/widgets/custom_input_text.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String? email;
  String? password;
  String? uid;
  bool userSignedIn = false;

  final Trace trace = FirebasePerformance.instance.newTrace('signin_trace');

  bool answered = false;
  String error = "";
  late user_model.User user;

  late UserCredential credentilas;
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var fields = {"email": 0, "password": 0};
  bool enable = false;

  void noEmptyFields() {
    int sum = 0;
    for (int v in fields.values) {
      sum += v;
    }

    if (sum == 2 && enable == false) {
      setState(() {
        enable = true;
      });
    } else if (sum != 2 && enable == true) {
      setState(() {
        enable = false;
      });
    }
  }

  Future<dynamic> getSurveyFromDataBase() async {
    dynamic value =
        await FirebaseStorageController.getFieldInUser(uid!, "survey");
    if (value == 'survey') {
      return "";
    }
    answered = value as bool;
    return answered;
  }

  Future<void> signInWithEmailAndPassword() async {
    email = email!.replaceAll(' ', '');
    Future<UserCredential> userCredential =
        auth.signInWithEmailAndPassword(email: email!, password: password!);

    credentilas = await userCredential;
    uid = credentilas.user?.uid;
    userSignedIn = true;
  }

  Future<void> createUser() async {
    Map<String, dynamic> val = await FirebaseStorageController.getUser(uid!);
    user = user_model.User.fromJson(val, uid!);
  }

  bool timePassed(DateTime created) {
    DateTime now = DateTime.now();
    bool correct = false;
    if (created.year - now.year != 0) {
      correct = true;
    }
    if (created.month - now.month != 0) {
      correct = true;
    }
    if (created.day - now.day != 0) {
      correct = true;
    }
    if (created.hour - now.hour != 0) {
      correct = true;
    }
    if (now.minute - created.minute > 5) {
      correct = true;
    }
    return correct;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
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
          height: 0.6.sh,
          width: 1.sw,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomInputText(
                textController: emailController,
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
                textController: passwordController,
                labelName: "Password",
                password: true,
                getText: (val) {
                  password = val;
                  if (password != "") {
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
                      onSurface: const Color(0xFF3D5AF1),
                    ),
                    onPressed: enable
                        ? () async {
                            FocusScope.of(context).requestFocus(
                              FocusNode(),
                            ); //Hide keyboard after pressed
                            try {
                              await trace.start();
                              await signInWithEmailAndPassword();
                              await trace.stop();
                              await createUser();
                              if (user.twoFactor) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TwoFactorLogIn(
                                      name: user.name,
                                      secondName: user.lastName,
                                      email: user.email,
                                      phoneNumber: user.phoneNumber,
                                      uid: user.userUID,
                                      twoFactor: user.twoFactor,
                                      login: false,
                                    ),
                                  ),
                                );
                              }
                              await getSurveyFromDataBase();
                              bool time = timePassed(user.created);
                              if (userSignedIn) {
                                bool locationGranted =
                                    await Permission.location.status.isGranted;
                                String location = "";
                                late String country;
                                late int totalPages;
                                if (locationGranted) {
                                  location =
                                      await LocationController.getLocation();
                                  if (location != "") {
                                    List<String> posArr = location.split(",");
                                    List<Placemark> placemarkers =
                                        await placemarkFromCoordinates(
                                            double.parse(posArr[0]),
                                            double.parse(posArr[1]));
                                    country = placemarkers[4].country!;
                                    totalPages = await LocationController
                                        .getPagesInMyLocation(country);
                                  }
                                }
                                answered
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomeScreen(
                                            user: user,
                                            locationAccess: locationGranted,
                                            location:
                                                location != "" ? country : null,
                                            totalPages: location != ""
                                                ? totalPages
                                                : null,
                                          ),
                                        ),
                                      )
                                    : time
                                        ? Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  Survey(user: user),
                                            ),
                                          )
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => HomeScreen(
                                                user: user,
                                                locationAccess: locationGranted,
                                                location: location != ""
                                                    ? country
                                                    : null,
                                                totalPages: location != ""
                                                    ? totalPages
                                                    : null,
                                              ),
                                            ),
                                          );
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == "user-not-found") {
                                error = "Oops! User not found";
                              } else if (e.code == "wrong-password") {
                                error = "Oops! Wrong password :(";
                              }

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(error),
                                  backgroundColor: Colors.red.shade600,
                                ),
                              );
                            }
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
      ),
    );
  }
}
