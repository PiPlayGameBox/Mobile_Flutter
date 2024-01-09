import 'dart:async';

import 'package:flutter/material.dart';

class PlayerFrame extends StatefulWidget {
  final String playerName;
  final Image playerIcon;
  final double frameHeight;
  final double frameWidth;
  final String turnInfo;

  const PlayerFrame(
      {super.key,
      required this.playerName,
      required this.playerIcon,
      required this.frameWidth,
      required this.frameHeight,
      required this.turnInfo});

  @override
  State<PlayerFrame> createState() => _PlayerFrameState();
}

class _PlayerFrameState extends State<PlayerFrame> {


  @override
  Widget build(BuildContext context) {
    double nameWidth = widget.frameWidth;
    double nameHeight = widget.frameHeight * 0.3;
    double avatarHeight = widget.frameHeight * 0.7;
    double avatarWidth = widget.frameHeight * 0.7;

    return SizedBox(
      //width: frameWidth,
      //height: frameHeight,
      child: Column(
        children: [
          Container(
            width: avatarWidth,
            height: avatarHeight,
            decoration:
            (widget.turnInfo == widget.playerName)
                ? BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.yellowAccent.withOpacity(1),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ) :
            BoxDecoration(
              //color: Colors.red,
              //border: Border.all(color: Colors.brown, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: widget.playerIcon,
            ),
          ),
          Container(
            width: nameWidth,
            height: nameHeight,
            decoration: (widget.turnInfo == widget.playerName)
                ? BoxDecoration(
                    color: Colors.blue[800],
                    border: Border.all(color: Colors.brown, width: 2),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellowAccent.withOpacity(1.0),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  )
                : BoxDecoration(
                    color: Colors.blue[800],
                    border: Border.all(color: Colors.brown, width: 2),
                    borderRadius: BorderRadius.circular(5),
                  ),
            child: Center(
              child: FittedBox(
                fit: BoxFit.fill,
                child: Text(
                  widget.playerName,
                  style: TextStyle(
                      color: true ? Colors.white : Colors.transparent,
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
