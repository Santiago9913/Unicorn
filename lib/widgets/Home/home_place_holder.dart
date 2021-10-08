import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PlaceholderWidget extends StatelessWidget {
  final Color color;
  final String text;
  final String asset;

  const PlaceholderWidget(
    this.color,
    this.text,
    this.asset,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1.sw,
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            asset,
            width: 180,
            height: 180,
          ),
          Container(
            child: Text(text),
          )
        ],
      ),
    );
  }
}
