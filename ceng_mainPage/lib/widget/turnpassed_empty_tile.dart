import 'package:ceng_mainpage/widget/rummyE_tile.dart';
import 'package:ceng_mainpage/widget/rummy_tile.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';


class TurnpassedEmptyTile extends StatefulWidget {
  TurnpassedEmptyTile({
    Key? key,
    required this.rummyTileHeight,
    required this.rummyTileWidth,
    required this.takozIndex,

  }) : super(key: key);

  final double rummyTileHeight;
  final double rummyTileWidth;
  String takozIndex;

  @override
  _TurnpassedEmptyTileState createState() => _TurnpassedEmptyTileState();
}

class _TurnpassedEmptyTileState extends State<TurnpassedEmptyTile> {

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
      child: const RummyETile(
        tileNumber: 'E',
        tileColor: Colors.white54,
      ),
    );
  }


}

