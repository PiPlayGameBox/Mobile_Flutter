import 'package:flutter/material.dart';

class MidRummyTile extends StatelessWidget {
  final String number;

  const MidRummyTile({super.key, required this.number});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          //borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 5,
              blurRadius: 7,
              offset: Offset(4, 8), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Text(
            number.toString(),
            style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: "Lato"),
          ),
        ),
      ),
    );
  }
}
