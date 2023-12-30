import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color buttonColor;
  final String buttonText;
  final Color buttonTextColor;
  final void Function() onPress;
  final double radius;
  final Size screenSize;

  const CustomButton(
      {Key? key,
      required this.onPress,
      required this.buttonText,
      required this.buttonColor,
      required this.buttonTextColor,
      required this.radius,
      required this.screenSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: EdgeInsets.all(screenSize.width * 0.01),
        margin: EdgeInsets.symmetric(horizontal: screenSize.width * 0.08),
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(
          child: Text(
            buttonText,
            style: TextStyle(
                color: buttonTextColor,
                fontWeight: FontWeight.bold,
                fontSize: screenSize.width * 0.054),
          ),
        ),
      ),
    );
  }
}
