import 'package:ceng_mainpage/screen/rummikub_screen.dart';
import 'package:ceng_mainpage/widget/clickable_rummy_tile.dart';
import 'package:ceng_mainpage/widget/rummyE_tile.dart';
import 'package:ceng_mainpage/widget/rummy_tile.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';


class EmptyRummyTileGlobals {
  // Checks if any empty tile is clicked.
  static bool isAnyEmptyClicked = false;
  // This is updated as the index of the placed tile.
  static int placedTileIndex = -1;
}


class EmptyRummyTile extends StatefulWidget {
  EmptyRummyTile({
    Key? key,
    required this.rummyTileHeight,
    required this.rummyTileWidth,
    required this.anyRummyClicked,
    required this.takozIndex,
/*    required this.isMoved,*/
  }) : super(key: key);

  final double rummyTileHeight;
  final double rummyTileWidth;
  bool anyRummyClicked;
  String takozIndex;
/*  bool isMoved;*/

  @override
  _EmptyRummyTileState createState() => _EmptyRummyTileState();
}

class _EmptyRummyTileState extends State<EmptyRummyTile> {

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
    /*return Visibility(
      visible: false,
      maintainSize: true,
      maintainState: true,
      maintainAnimation: true,
      child: GestureDetector(
        onTap: () {
          setState(() {
            isClicked = !isClicked;
          });
        },
        child: widget.anyRummyClicked
            ? DottedBorder(
          borderType: BorderType.RRect,
          strokeWidth: 2,
          color: Colors.green,
          child: buildRummyTile(),
        )
            : Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: buildRummyTile(),
        ),
      ),
    );*/
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

