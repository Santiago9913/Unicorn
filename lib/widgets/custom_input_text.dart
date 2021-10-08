import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInputText extends StatefulWidget {
  const CustomInputText({
    Key? key,
    required this.labelName,
    required this.password,
    this.textController,
    required this.getText,
  }) : super(key: key);

  final String? labelName;
  final bool? password;
  final TextEditingController? textController;
  final Function getText;

  @override
  State<CustomInputText> createState() => _CustomInputTextState();
}

class _CustomInputTextState extends State<CustomInputText> {
  bool _hidePassword = true;

  void toggleVisibility() {
    setState(() {
      _hidePassword = !_hidePassword;
    });
  }

  bool checkEmail(email, validator) {
    return validator(email);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
            SizedBox(
              width: 0.9.sw,
              child: TextField(
                controller: widget.textController,
                onChanged: (_) {
                  String? val = widget.textController?.text;
                  widget.getText(val);
                },
                textInputAction: widget.password!
                    ? TextInputAction.done
                    : TextInputAction.next,
                obscureText: _hidePassword && widget.password!,
                decoration: InputDecoration(
                  hintText: widget.labelName!,
                  suffixIcon: widget.password!
                      ? IconButton(
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: toggleVisibility,
                          color: Colors.black,
                        )
                      : null,
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF3D5AF1),
                      width: 1.5,
                    ),
                  ),
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
