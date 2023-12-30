import 'package:ceng_mainpage/widget/mid_rummy_tile.dart';
import 'package:ceng_mainpage/widget/rummy_tile.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';


class TurnbasedMiddleRummyTile extends StatefulWidget {
  const TurnbasedMiddleRummyTile({
    Key? key,
    required this.rummyTileHeight,
    required this.rummyTileWidth,
    required this.cloneIndex,
    required this.takozIndex,
    required this.tileNumber,
    required this.tileColor,
    required this.numberL,
  }) : super(key: key);


  final double rummyTileHeight;
  final double rummyTileWidth;
  final String cloneIndex;
  final String takozIndex;
  final String tileNumber;
  final Color tileColor;
  final String numberL;

  @override
  _TurnbasedMiddleRummyTileState createState() => _TurnbasedMiddleRummyTileState();
}

class _TurnbasedMiddleRummyTileState extends State<TurnbasedMiddleRummyTile> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isClicked = !isClicked;
        });
      },
      child: isClicked
          ? DottedBorder(
        borderType: BorderType.RRect,
        strokeWidth: 2,
        color: Colors.yellow,
        child: buildRummyTile(),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: buildRummyTile(),
      ),
    );
  }

  Widget buildRummyTile() {
    return SizedBox(
      height: widget.rummyTileHeight,
      width: widget.rummyTileWidth,
      child: MidRummyTile(
        number: widget.numberL,
      ),
    );
  }
}