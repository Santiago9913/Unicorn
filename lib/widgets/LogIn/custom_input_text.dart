import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInputText extends StatefulWidget {
  const CustomInputText({
    Key? key,
    required this.labelName,
  }) : super(key: key);

  final String? labelName;

  @override
  State<CustomInputText> createState() => _CustomInputTextState();
}

class _CustomInputTextState extends State<CustomInputText> {
  @override
  Widget build(BuildContext context) {
    final myController = TextEditingController();

    @override
    dispose() {
      myController.dispose();
      super.dispose();
    }

    return Container(
      width: 1.sw,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.labelName!,
              style: const TextStyle(
                fontFamily: "Geometric Sans-Serif",
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 0.90.sw,
              child: TextField(
                controller: myController,
                decoration: InputDecoration(
                  labelText: widget.labelName!,
                  fillColor: const Color(0xFF3D5AF1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
