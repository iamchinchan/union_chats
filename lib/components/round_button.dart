import 'package:flutter/material.dart';
import '../constants.dart';

class RoundButton extends StatelessWidget {
  const RoundButton(
      {required this.onPressed,
      required this.color,
      required this.label,
      Key? key})
      : super(key: key);
  final Color color;
  final Function() onPressed;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
