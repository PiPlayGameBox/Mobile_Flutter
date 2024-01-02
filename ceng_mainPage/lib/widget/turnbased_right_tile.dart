import 'package:ceng_mainpage/screen/rummikub_screen.dart';
import 'package:ceng_mainpage/widget/clickable_rummy_tile.dart';
import 'package:ceng_mainpage/widget/empty_rummy_tile.dart';
import 'package:ceng_mainpage/widget/rummyE_tile.dart';
import 'package:ceng_mainpage/widget/rummy_tile.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';


class TurnbasedRightTile extends StatefulWidget {
  TurnbasedRightTile({
    Key? key,
    required this.rummyTileHeight,
    required this.rummyTileWidth,
    required this.anyRummyClicked,
    required this.cloneIndex,
    required this.takozIndex,
    required this.tileNumber,
    required this.tileColor,
/*    required this.isMoved,*/
  }) : super(key: key);

  final double rummyTileHeight;
  final double rummyTileWidth;
  bool anyRummyClicked;
  final String cloneIndex;
  String takozIndex;
  String tileNumber;
  final Color tileColor;
/*  bool isMoved;*/

  @override
  _TurnbasedRightTileState createState() => _TurnbasedRightTileState();
}

class _TurnbasedRightTileState extends State<TurnbasedRightTile> {

  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (!EmptyRummyTileGlobals.isAnyEmptyClicked && widget.anyRummyClicked) { // If there is not any empty tile clicked before we click and make the flag any true.
            isClicked = true;
            EmptyRummyTileGlobals.isAnyEmptyClicked = true;
            // And updating the global index of clicked.
            EmptyRummyTileGlobals.placedTileIndex = int.parse(widget.takozIndex);
            print("DEĞER: ${widget.anyRummyClicked} ${ClickableRummyTileGlobals.isAnyClicked} ${EmptyRummyTileGlobals.isAnyEmptyClicked} ");
          }
          else if (EmptyRummyTileGlobals.isAnyEmptyClicked) { // When we done the move, we reset the empty tile logic.
            isClicked = false;
            EmptyRummyTileGlobals.isAnyEmptyClicked = false;
            // Resetting the global index of clicked.
            EmptyRummyTileGlobals.placedTileIndex = -1;
          }
        });
      },
      child: widget.anyRummyClicked && !EmptyRummyTileGlobals.isAnyEmptyClicked // Green highlights if any tile clicked, If any empty clicked, it closes that highlight.
          ? DottedBorder(
        borderType: BorderType.RRect,
        strokeWidth: 2,
        color: Colors.green,
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

