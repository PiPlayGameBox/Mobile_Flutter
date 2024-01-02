import 'package:ceng_mainpage/screen/rummikub_screen.dart';
import 'package:ceng_mainpage/widget/clickable_rummy_tile.dart';
import 'package:ceng_mainpage/widget/rummyE_tile.dart';
import 'package:ceng_mainpage/widget/rummy_tile.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';


class NonclickableEmptyTile extends StatefulWidget {
  NonclickableEmptyTile({
    Key? key,
    required this.rummyTileHeight,
    required this.rummyTileWidth,
    required this.takozIndex,
/*    required this.isMoved,*/
  }) : super(key: key);

  final double rummyTileHeight;
  final double rummyTileWidth;
  String takozIndex;
/*  bool isMoved;*/

  @override
  _NonclickableEmptyTileState createState() => _NonclickableEmptyTileState();
}

class _NonclickableEmptyTileState extends State<NonclickableEmptyTile> {

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

