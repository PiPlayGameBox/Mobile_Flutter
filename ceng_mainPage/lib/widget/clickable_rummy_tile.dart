import 'package:ceng_mainpage/widget/rummy_tile.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';


class ClickableRummyTileGlobals {
  // Holds if any is clicked.
  static bool isAnyClicked = false;
  // This is updated as the index of the clicked tile.
  static int clickedTileIndex = -1;
}

class ClickableRummyTile extends StatefulWidget {
  ClickableRummyTile({
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
  _ClickableRummyTileState createState() => _ClickableRummyTileState();
}

class _ClickableRummyTileState extends State<ClickableRummyTile> {

  bool isClicked = false;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if(!ClickableRummyTileGlobals.isAnyClicked){ // If there is not any tile clicked before we click and make the flag any true.
            isClicked = !isClicked;
            ClickableRummyTileGlobals.isAnyClicked = true;
            // And updating the global index of clicked.
            ClickableRummyTileGlobals.clickedTileIndex = int.parse(widget.takozIndex);
          }
          else if(ClickableRummyTileGlobals.isAnyClicked && isClicked){ // If any tile is clicked and that's this tile, we can un-click it and reset the any flag.
            isClicked = !isClicked;
            ClickableRummyTileGlobals.isAnyClicked = false;
            // Resetting the global index of clicked.
            ClickableRummyTileGlobals.clickedTileIndex = -1;
          }
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

