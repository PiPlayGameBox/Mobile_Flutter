import 'package:ceng_mainpage/widget/rummy_tile.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';


class TurnpassedRightTile extends StatefulWidget {
  TurnpassedRightTile({
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
  String takozIndex;
  String tileNumber;
  final Color tileColor;

  @override
  _TurnpassedRightTileState createState() => _TurnpassedRightTileState();
}

class _TurnpassedRightTileState extends State<TurnpassedRightTile> {

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

