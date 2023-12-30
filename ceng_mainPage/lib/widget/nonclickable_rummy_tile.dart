import 'package:ceng_mainpage/widget/rummy_tile.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';


class NonclickableRummyTile extends StatefulWidget {
  const NonclickableRummyTile({
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
  _NonclickableRummyTileState createState() => _NonclickableRummyTileState();
}

class _NonclickableRummyTileState extends State<NonclickableRummyTile> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: buildRummyTile(),
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
