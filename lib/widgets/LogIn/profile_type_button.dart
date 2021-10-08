import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileTypeButton extends StatefulWidget {
  const ProfileTypeButton({
    Key? key,
    required this.color,
    required this.image,
    required this.text,
    required this.elev,
    required this.toggle,
    required this.selected,
  }) : super(key: key);

  final Color color;
  final Image image;
  final String text;
  final double elev;
  final Function toggle;
  final bool selected;

  @override
  State<ProfileTypeButton> createState() => _ProfileTypeButtonState();
}

class _ProfileTypeButtonState extends State<ProfileTypeButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      width: 0.5.sw,
      height: 0.5.sh,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 0.4.sw,
            height: 0.5.sh,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                primary: widget.color,
                elevation: widget.elev,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  widget.image,
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      widget.text,
                      style: const TextStyle(
                        fontFamily: "Fredoka One",
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              onPressed: () {
                widget.toggle();
              },
            ),
          ),
        ],
      ),
    );
  }
}
