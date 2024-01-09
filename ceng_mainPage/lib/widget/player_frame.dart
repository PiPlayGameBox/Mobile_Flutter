import 'package:flutter/material.dart';

class PlayerFrame extends StatelessWidget {
  final String playerName;
  final Image playerIcon;
  final double frameHeight;
  final double frameWidth;

  const PlayerFrame(
      {super.key,
        required this.playerName,
        required this.playerIcon,
        required this.frameWidth,
        required this.frameHeight});

  @override
  Widget build(BuildContext context) {
    double nameWidth = frameWidth;
    double nameHeight = frameHeight * 0.25;
    double avatarHeight = frameHeight * 0.75;
    double avatarWidth = frameHeight * 0.75;

    return SizedBox(
      //width: frameWidth,
      //height: frameHeight,
      child: Column(
        children: [
          Container(
            width: avatarWidth,
            height: avatarHeight,
            decoration: BoxDecoration(
              //color: Colors.red,
              /*border: Border.all(color: Colors.brown, width: 2),*/
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: playerIcon,
            ),
          ),
          Container(
            width: nameWidth,
            height: nameHeight,
            decoration: BoxDecoration(
              color: Colors.blue[800],
              border: Border.all(color: Colors.brown, width: 2),
              borderRadius: BorderRadius.circular(5),

            ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.fill,
                child: Text(
                  playerName,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Lato"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
