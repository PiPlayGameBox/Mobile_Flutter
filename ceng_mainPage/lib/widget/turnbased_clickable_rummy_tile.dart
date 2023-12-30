import 'package:ceng_mainpage/widget/rummy_tile.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';


class TurnbasedClickableRummyTile extends StatefulWidget {
  const TurnbasedClickableRummyTile({
    Key? key,
    required this.rummyTileHeight,
    required this.rummyTileWidth,
    required this.cloneIndex,
    required this.takozIndex,
    required this.tileNumber,
    required this.tileColor,
  }) : super(key: key);


  final double rummyTileHeight;
  final double rummyTileWidth;
  final String cloneIndex;
  final String takozIndex;
  final String tileNumber;
  final Color tileColor;

  @override
  _TurnbasedClickableRummyTileState createState() => _TurnbasedClickableRummyTileState();
}

class _TurnbasedClickableRummyTileState extends State<TurnbasedClickableRummyTile> {
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
      child: RummyTile(
        tileNumber: widget.tileNumber,
        tileColor: widget.tileColor,
      ),
    );
  }
}