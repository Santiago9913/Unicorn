import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostWidget extends StatelessWidget {
  const PostWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5.sh,
      margin: EdgeInsets.only(top: 5.h, bottom: 5.h),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Padding(
                padding: EdgeInsets.only(left: 20, top: 20, right: 10),
                child: CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 30,
                ),
              ),
              Text(
                "Name",
                style: TextStyle(
                    fontFamily: "Geometric Sans-Serif",
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10, left: 20),
            child: Text(
                "Eu exercitation voluptate laboris ex pariatur id sunt et fugiat amet. Amet et occaecat ut."),
          ),
          Flexible(
            flex: 6,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      "https://images.unsplash.com/photo-1508556497405-ed7dcd94acfc?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1170&q=80"),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              color: Colors.green.shade100,
            ),
          )
        ],
      ),
    );
  }
}
