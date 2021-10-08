import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicorn/models/user.dart';
import 'package:unicorn/widgets/LogIn/profile_type_button.dart';

class SelectProfileType extends StatefulWidget {
  const SelectProfileType({
    Key? key,
    required this.userUID,
    required this.firstName,
    required this.lastName,
  }) : super(key: key);

  final String userUID;
  final String? firstName;
  final String? lastName;

  @override
  _SelectProfileTypeState createState() => _SelectProfileTypeState();
}

class _SelectProfileTypeState extends State<SelectProfileType> {
  bool entrepreneurSelected = false;
  bool investorSelected = false;
  bool enable = false;
  double entrepreneurElevation = 0;
  double investorElevation = 0;
  String type = "";

  void uploadUser() async {
    User user = User(
        name: widget.firstName!,
        lastName: widget.lastName!,
        userUID: widget.userUID,
        type: type);

    try {
      await user.getUserRef.set(user.toJSON());
    } catch (e) {
      print(e);
    }
  }

  void toggleEntrepreneur() {
    setState(() {
      entrepreneurSelected = true;
      enable = true;

      if (investorSelected) {
        investorSelected = !investorSelected;
        investorElevation = 0;
      }
      entrepreneurElevation = entrepreneurSelected ? 40 : 0;
      type = "Entrepreneur";
    });
  }

  void toggleInvestor() {
    setState(() {
      investorSelected = true;
      enable = true;

      if (entrepreneurSelected) {
        entrepreneurSelected = !entrepreneurSelected;
        entrepreneurElevation = 0;
      }
      investorElevation = investorSelected ? 40 : 0;
      type = "Investor";
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SizedBox(
          width: 1.sw,
          height: 0.93.sh,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 1.sw,
                padding: const EdgeInsets.only(left: 16, top: 2),
                child: const Text(
                  "Are you a: ",
                  style: TextStyle(
                      fontFamily: "Geometric Sans-Serif",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ProfileTypeButton(
                    color: const Color(0xFF3D5AF1),
                    image: Image.asset(
                      'assets/icons/Saly10.png',
                      height: 200.h,
                    ),
                    text: "Entrepreneur",
                    elev: entrepreneurElevation,
                    selected: entrepreneurSelected,
                    toggle: toggleEntrepreneur,
                  ),
                  ProfileTypeButton(
                    color: const Color(0xFF0E153A),
                    image: Image.asset(
                      'assets/icons/Saly19.png',
                      height: 200.h,
                    ),
                    text: "Investor",
                    elev: investorElevation,
                    selected: investorSelected,
                    toggle: toggleInvestor,
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 74),
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
                    onPressed: enable ? uploadUser : null,
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
