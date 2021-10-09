import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:unicorn/widgets/Home/home_page.dart';

class Survey extends StatefulWidget {
  Survey({Key? key, required this.uid, required this.db}) : super(key: key);

  final String? uid;
  final DatabaseReference db;

  @override
  _SurveyState createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  bool enable = false;
  double _currentSliderValue = 0;

  void Selected() {
    if (_currentSliderValue == 0) {
      enable = false;
    } else {
      enable = true;
    }
  }

  Future<void> updateSurveyStatus(String? id, DatabaseReference db, double score) async {
    try {
      DatabaseReference userReference = db.child("users/$id/");
      Map<String, dynamic> mapSurvey = {"survey": true, "surveyScore": score};
      await userReference.update(mapSurvey);
    } catch (e) {
      print(e);
    }
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
          leading: IconButton(
            icon: const Icon(
              Icons.clear,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                      (route) => false);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: 1.sw,
            height: 0.89.sh,
            child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                width: 1.sw,
                padding: const EdgeInsets.only(left: 16, top: 2),
                child: const Text(
                  "How relevant is the information displayed to you? (From 1 - 10)",
                  style: TextStyle(
                      fontFamily: "Geometric Sans-Serif",
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 60, 0, 15),
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Slider(
                          value: _currentSliderValue,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: _currentSliderValue.round().toString(),
                          onChanged: (double value) {
                            setState(() {
                              _currentSliderValue = value;
                              Selected();
                            });
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: ElevatedButton(
                        child: const Text(
                          "Start",
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
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            onSurface: const Color(0xFF3D5AF1)),
                        onPressed: enable
                            ? () async {
                                  await updateSurveyStatus(widget.uid, widget.db, _currentSliderValue);
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const HomeScreen(),
                                      ),
                                      (route) => false);
                              }
                            : null,
                      ),
                    ),
                  ]))
            ]),
          ),
        ),
      ),
    );
  }
}
