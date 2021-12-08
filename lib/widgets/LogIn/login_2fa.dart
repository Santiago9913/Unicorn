import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:unicorn/controllers/firebase_storage_controller.dart';
import 'package:unicorn/widgets/LogIn/login_select_profile_type.dart';

class TwoFactorLogIn extends StatefulWidget {
  const TwoFactorLogIn({
    Key? key,
    required this.name,
    required this.secondName,
    required this.email,
    required this.phoneNumber,
    required this.uid,
    required this.twoFactor,
    required this.login,
  }) : super(key: key);

  final String name;
  final String secondName;
  final String email;
  final String phoneNumber;
  final String uid;
  final bool twoFactor;
  final bool login;

  @override
  _TwoFactorLogInState createState() => _TwoFactorLogInState();
}

class _TwoFactorLogInState extends State<TwoFactorLogIn> {
  bool finished = false;

  Future<void> verifyNumber() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.verifyPhoneNumber(
      phoneNumber: "+57 " + widget.phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) {
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        showGeneralDialog(
          context: context,
          pageBuilder: (context, animation, secondaryAnimation) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                leading: null,
              ),
              body: Center(
                child: SizedBox(
                  height: 0.5.sh,
                  child: Column(
                    children: [
                      Container(
                        width: 1.sw,
                        padding:
                            const EdgeInsets.only(left: 16, top: 2, bottom: 10),
                        child: const Text(
                          "Enter your verification code",
                          style: TextStyle(
                              fontFamily: "Geometric Sans-Serif",
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: VerificationCode(
                          textStyle: const TextStyle(
                            fontFamily: "Geometric Sans-Serif",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          underlineColor: const Color(0xFF3D5AF1),
                          keyboardType: TextInputType.number,
                          length: 6,
                          clearAll: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'clear all',
                              style: TextStyle(
                                fontSize: 14.0,
                                decoration: TextDecoration.underline,
                                color: Color(0xFF3D5AF1),
                              ),
                            ),
                          ),
                          onCompleted: (String value) async {
                            FocusScope.of(context).unfocus();
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                              verificationId: verificationId,
                              smsCode: value,
                            );

                            try {
                              await auth.signInWithCredential(credential);
                              if (widget.login) {
                                await FirebaseStorageController.updateTrace("accepted");
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SelectProfileType(
                                      userUID: widget.uid,
                                      firstName:
                                          widget.name.replaceAll(" ", ""),
                                      lastName:
                                          widget.secondName.replaceAll(" ", ""),
                                      email: widget.email.replaceAll(" ", ""),
                                      phoneNumber: widget.phoneNumber,
                                      twoFactor: widget.twoFactor,
                                    ),
                                  ),
                                  (e) => false,
                                );
                              } else {
                                await FirebaseStorageController.updateTrace("accepted");
                                Navigator.pop(context);
                              }
                            } catch (e) {
                              await FirebaseStorageController.updateTrace("rejected");
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                      "Invalid code, please check the code that was sent"),
                                  backgroundColor: Colors.red.shade600,
                                ),
                              );
                            }
                          },
                          onEditing: (bool value) {},
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    verifyNumber();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.sh,
      color: Colors.white,
    );
  }
}
