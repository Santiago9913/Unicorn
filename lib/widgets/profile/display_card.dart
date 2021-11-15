import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDisplayCard extends StatelessWidget {
  const CustomDisplayCard(
      {Key? key, required this.name, required this.email, required this.color})
      : super(key: key);

  final String name;
  final String email;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.circular(20.0),
        child: Container(
          height: 0.1.sh,
          width: 0.45.sh,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/icons/test1.jpg',
                  ),
                  radius: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                          fontFamily: "Geometric Sans-Serif",
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    Text(
                      email,
                      style: const TextStyle(
                        fontFamily: "Geometric Sans-Serif",
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
