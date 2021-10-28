import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDisplayInfoCard extends StatelessWidget {
  const CustomDisplayInfoCard({
    Key? key,
    required this.title,
    required this.info,
  }) : super(key: key);

  final String title;
  final String info;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 7.h, top: 20),
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: "Geometric Sans-Serif",
              fontSize: 18,
              color: Color(0xFF3D5AF1),
            ),
          ),
        ),
        Material(
          color: Colors.white,
          elevation: 5,
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            width: 0.85.sw,
            height: 0.10.sh,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    info,
                    style: const TextStyle(
                      fontFamily: "Geometric Sans-Serif",
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
