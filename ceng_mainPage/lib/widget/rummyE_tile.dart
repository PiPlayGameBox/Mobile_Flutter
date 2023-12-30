import 'package:flutter/material.dart';

class RummyETile extends StatelessWidget {
  final String tileNumber;
  final Color tileColor;
  final bool isFlipped;

  const RummyETile(
      {super.key,
        required this.tileNumber,
        required this.tileColor, this.isFlipped = false});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: Opacity(
        opacity: 0.2,
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
            child: !isFlipped ? Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: Text(
                      tileNumber,
                      style: TextStyle(
                          color: tileColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Lato"),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // border color
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(2), // border width
                      child: Container(
                        // or ClipRRect if you need to clip the content
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white, // inner circle color
                        ),
                        child: Container(
                          // or ClipRRect if you need to clip the content
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: tileColor, // inner circle color
                            )), // inner content
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 2,
                ),
              ],
            ) : const SizedBox(height: 5,)
        ),
      ),
    );
  }
}
