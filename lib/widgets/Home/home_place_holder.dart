import 'package:flutter/cupertino.dart';

class PlaceholderWidget extends StatefulWidget {
  final Color? color;
  final String? text;
  final String? asset;
  late final  Widget child;

  PlaceholderWidget({
    Key? key,
    this.color,
    this.text,
    this.asset,
    required this.child,
  }) : super(key: key);

  @override
  State<PlaceholderWidget> createState() => _PlaceholderWidgetState();
}

class _PlaceholderWidgetState extends State<PlaceholderWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
