import 'package:ceng_mainpage/widget/mid_rummy_tile.dart';
import 'package:ceng_mainpage/widget/rummy_tile.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';


class TurnpassedMiddleTile extends StatefulWidget {
  TurnpassedMiddleTile({
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
  String takozIndex;
  String tileNumber;
  final Color tileColor;
  String numberL;

  @override
  _TurnpassedMiddleTileState createState() => _TurnpassedMiddleTileState();
}

class _TurnpassedMiddleTileState extends State<TurnpassedMiddleTile> {

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
      child: MidRummyTile(
        number: widget.numberL,
      ),
    );
  }


}

