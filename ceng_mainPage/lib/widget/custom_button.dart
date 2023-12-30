import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap; // Func that changes the action onTap.

  final String text;

  const CustomButton({
    Key? key,
    required this.onTap,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all( // Circular
          Radius.circular(25.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 3,
            spreadRadius: 0,
            offset: Offset(0, 3),
          )
        ],
      ),

      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          minimumSize: Size(
            width,
            50,
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 20,
            fontFamily: "Netflix",
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
