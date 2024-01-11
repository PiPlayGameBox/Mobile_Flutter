import 'dart:convert';
import 'dart:io';

import 'package:ceng_mainpage/provider/rummikub_data_provider.dart';
import 'package:ceng_mainpage/screen/lobby_screen.dart';
import 'package:ceng_mainpage/util/endGameOkey.dart';
import 'package:ceng_mainpage/widget/clickable_rummy_tile.dart';
import 'package:ceng_mainpage/widget/empty_rummy_tile.dart';
import 'package:ceng_mainpage/widget/mid_rummy_tile.dart';
import 'package:ceng_mainpage/widget/nonclickable_empty_tile.dart';
import 'package:ceng_mainpage/widget/nonclickable_rummy_tile.dart';
import 'package:ceng_mainpage/widget/player_frame.dart';
import 'package:ceng_mainpage/widget/rummy_tile.dart';
import 'package:ceng_mainpage/widget/turnbased_clickable_rummy_tile.dart';
import 'package:ceng_mainpage/widget/turnbased_middle_rummy_tile.dart';
import 'package:ceng_mainpage/widget/turnbased_right_tile.dart';
import 'package:ceng_mainpage/widget/turnpassed_empty_tile.dart';
import 'package:ceng_mainpage/widget/turnpassed_left_tile.dart';
import 'package:ceng_mainpage/widget/turnpassed_middle_tile.dart';
import 'package:ceng_mainpage/widget/turnpassed_right_tile.dart';
import 'package:ceng_mainpage/screens/login_screen.dart';
import 'package:ceng_mainpage/screen/main_menu_screen.dart';
import 'package:ceng_mainpage/widget/win_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:async';

import 'package:provider/provider.dart';

String resp = '0';
String exampleResponse = 'OK/E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|/E|E|E|E|/E|E|48/empty/empty/empty';
bool isTurn = false; // Checks if its user's turn. When user gets a tile, this becomes false and makes the isGet true and waits for the user to throw tile.
bool isGet = false; // Becomes true when tile get from board, becomes false when tile thrown.
int numberOfTiles = 0;
int won = 0;
String winnerPlayer = 'empty'; // first empty is winner,
String quitterPlayer = 'empty';

void globReset(){
  resp = '0';
  exampleResponse = 'OK/E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|/E|E|E|E|/E|E|48/empty/empty/empty';
  isTurn = false;
  isGet = false;
  numberOfTiles = 0;
  won = 0;
  winnerPlayer = 'empty';
  quitterPlayer = 'empty';
}

/*'OK/B4_1|Y10_2|B13_1|E|R4_1|R10_1|K11_2|B6_2|E|K9_2|K6_2|E|B12_1|B1_2|E|E|E|E|K5_2|E|E|E|E|E|E|Y5_2|E|E|E|Y13_1|/E|B9_2|Y9_2|Y10_1|/Y4_2|B7_2|47';*/
/*
  OK, tiles, floor (floor[3]=next tile to get), (spoiler tile to get middle, okey, tiles left.)
  array[0] = checker
  array[1] = tilesTakoz
  array[2] = tilesThrown
  array[3] = middleTiles
*/

/*
  array[0] = OK
  proceeds only on ok.
*/

/*
  array[1]
  0-14  : first floor tiles
  15-29 : second floor tiles
*/

/*
  array[2]
  0 : rightBottom
  1 : rightTop
  2 : leftTop
  3 : leftDown   ( Tile to get from thrown!)
*/

/*
  array[3]
  0 : Tile to get from middle (Spoiler)
  1 : Okey tile
  2 : Number of tiles left
*/

/*
  array[4]
  Player of this turn.
*/



class RummikubScreen extends StatefulWidget {
  static String routeName = '/rummikub';

  const RummikubScreen({
    Key? key,
    required this.token,
    required this.userName,
    required this.infoLUR,
  }) : super(key: key);

  final String token;
  final String userName;
  final List<String> infoLUR;

  @override
  State<RummikubScreen> createState() => _RummikubScreenState();
}

class _RummikubScreenState extends State<RummikubScreen> {
  // Provider and Timer of Rummikub game.
  // We indexed and followed the state. Without iterateIndex method, we would only see the first provider.
  // So use the provider's current data, we need to use like: "dataProvider.rumiData[dataProvider.index].middleTiles" in example.
  late RummikubDataProvider dataProvider;
  late Timer timer;
  String playersTurnInfo = "";

  // Flags for if any rummy or empty tile is clicked.
  bool anyRummyClicked = false;

  bool anyEmptyClicked = false;

  // Integer that shows the movement.
  int fromTile = -1;

  int toTile = -1;

  // Flag for the movement is done or not.
/*  bool isMoved = false;*/

  // Floors coming from array 1
  List<Widget> firstFloor = <Widget>[];
  List<Widget> secondFloor = <Widget>[];

  void checkAnyRummyClicked(){

    // Update anyRummyClicked
    setState(() {
      anyRummyClicked = ClickableRummyTileGlobals.isAnyClicked;

      if(TurnbasedClickableRummyTileGlobals.isAnyClicked != false){
        anyRummyClicked = TurnbasedClickableRummyTileGlobals.isAnyClicked;
      }

      if(TurnbasedMiddleRummyTileGlobals.isAnyClicked != false){
        anyRummyClicked = TurnbasedMiddleRummyTileGlobals.isAnyClicked;
      }

      print('Any rumi Clicked: $anyRummyClicked');
    });

  }

  void checkAnyEmptyClicked() {

    // Update fromTile
    setState(() {
      anyEmptyClicked = EmptyRummyTileGlobals.isAnyEmptyClicked;
      print('Any Empty Clicked: $anyEmptyClicked');
    });

  }

    void updateFromTile(){
      // Update fromTile
      setState(() {
        fromTile = ClickableRummyTileGlobals.clickedTileIndex;

        if(TurnbasedClickableRummyTileGlobals.clickedTileIndex != -1){
          fromTile = TurnbasedClickableRummyTileGlobals.clickedTileIndex;
        }

        if(TurnbasedMiddleRummyTileGlobals.clickedTileIndex != -1){
          fromTile = TurnbasedMiddleRummyTileGlobals.clickedTileIndex;
        }

        print('From: $fromTile');
      });
    }

    void updateToTile(){
      // Update fromTile
      setState(() {
        toTile = EmptyRummyTileGlobals.placedTileIndex;
        print('To: $toTile');
      });
    }

    void checkPlayerTurn(String userTurn){
      print('USR turn1: $userTurn');
      print('widget usr: ${loginGlobals.username}');
      if(loginGlobals.username == userTurn){
        setState(() {
          playersTurnInfo = userTurn;
          isTurn = true;
        });
      }else{
        setState(() {
          playersTurnInfo = userTurn;
          isTurn = false;
        });

      }
    }

    int getNumberOfTiles(List<String> tilesOnTakoz){
      int count = 0;

      // Scans the takoz.
      for(int i = 0; i < 30; i++ ){
        if(tilesOnTakoz[i] != 'E'){ // With this logic, we get the number of tiles on board.
          count++;
        }
      }

      return count;
    }


  // Thrown tiles are coming from array 2.
  Widget rummyTilesOnTheFloorRightBot = Container();
  Widget rummyTilesOnTheFloorRightTop = Container();
  Widget rummyTilesOnTheFloorLeftTop = Container();
  Widget rummyTilesOnTheFloorLeftBot = Container();

  void constructThrown(double rummyTileHeight, double rummyTileWidth, bool isMyTurn, bool isGetted){

    String thrown0 = dataProvider.rumiData[dataProvider.index].tilesThrown[0];
    String thrown1 = dataProvider.rumiData[dataProvider.index].tilesThrown[1];
    String thrown2 = dataProvider.rumiData[dataProvider.index].tilesThrown[2];
    String thrown3 = dataProvider.rumiData[dataProvider.index].tilesThrown[3];

    // Index 0.  RIGHT TILE (Tile to throw.)
    if(thrown0 == 'E'){

      if(isGetted){ // User get the tile. Has 15 tiles on takoz.
        rummyTilesOnTheFloorRightBot = EmptyRummyTile(
          rummyTileHeight: rummyTileHeight,
          rummyTileWidth: rummyTileWidth,
          anyRummyClicked: anyRummyClicked,
          takozIndex: '30',
        );
      }
      else{ // User has 14 tiles on takoz.
        rummyTilesOnTheFloorRightBot = TurnpassedEmptyTile(
          rummyTileHeight: rummyTileHeight,
          rummyTileWidth: rummyTileWidth,
          takozIndex: '30', // They are not at the takoz but we continue indexing them from 30.
        );
      }

    }
    else{

      List<String> parsedTile = thrown0.split('_'); // We parse tile to 2. index 0 is R1 and index 1 is 1 (clone number) in example.

      String tileWithColor = parsedTile[0]; // R10, R9
      String cloneNumber = parsedTile[1]; // 1 or 2

      String tileColor = tileWithColor[0]; // Color is always on index 0.

      // When we ignore the color at index 0, remaining part is tile number.
      String tileNumber = tileWithColor.substring(1);

      if(isGetted){ // User get the tile. Has 15 tiles on takoz.
        rummyTilesOnTheFloorRightBot = TurnbasedRightTile(
          rummyTileHeight: rummyTileHeight,
          rummyTileWidth: rummyTileWidth,
          anyRummyClicked: anyRummyClicked,
          cloneIndex: cloneNumber,
          takozIndex: '30', // They are not at the takoz but we continue indexing them from 30.
          tileNumber: tileNumber,
          tileColor: tileColor == 'R' // If R, red,
              ? Colors.red
              : tileColor == 'K' // If K, black
              ? Colors.black
              : tileColor == 'B' // If B, blue
              ? Colors.blue
              : tileColor == 'Y' // If Y, yellow
              ? Colors.orange
              : Colors.green, // Else, (In joker situation) its green.
        );
      }
      else{ // User has 14 tiles on takoz.
        rummyTilesOnTheFloorRightBot = TurnpassedRightTile(
          rummyTileHeight: rummyTileHeight,
          rummyTileWidth: rummyTileWidth,
          cloneIndex: cloneNumber,
          takozIndex: '30', // They are not at the takoz but we continue indexing them from 30.
          tileNumber: tileNumber,
          tileColor: tileColor == 'R' // If R, red,
              ? Colors.red
              : tileColor == 'K' // If K, black
              ? Colors.black
              : tileColor == 'B' // If B, blue
              ? Colors.blue
              : tileColor == 'Y' // If Y, yellow
              ? Colors.orange
              : Colors.green, // Else, (In joker situation) its green.
        );
      }

    }

    // Index 1
    if(thrown1 == 'E'){
      rummyTilesOnTheFloorRightTop = NonclickableEmptyTile(
        rummyTileHeight: rummyTileHeight,
        rummyTileWidth: rummyTileWidth,
        takozIndex: '31',
      );
    }
    else{

      List<String> parsedTile = thrown1.split('_'); // We parse tile to 2. index 0 is R1 and index 1 is 1 (clone number) in example.

      String tileWithColor = parsedTile[0]; // R10, R9
      String cloneNumber = parsedTile[1]; // 1 or 2

      String tileColor = tileWithColor[0]; // Color is always on index 0.

      // When we ignore the color at index 0, remaining part is tile number.
      String tileNumber = tileWithColor.substring(1);

      rummyTilesOnTheFloorRightTop = NonclickableRummyTile(
        rummyTileHeight: rummyTileHeight,
        rummyTileWidth: rummyTileWidth,
        cloneIndex: cloneNumber,
        takozIndex: '31', // They are not at the takoz but we continue indexing them from 31.
        tileNumber: tileNumber,
        tileColor: tileColor == 'R' // If R, red,
            ? Colors.red
            : tileColor == 'K' // If K, black
            ? Colors.black
            : tileColor == 'B' // If B, blue
            ? Colors.blue
            : tileColor == 'Y' // If Y, yellow
            ? Colors.orange
            : Colors.green, // Else, (In joker situation) its green.
      );
    }

    // Index 2
    if(thrown2 == 'E'){
      rummyTilesOnTheFloorLeftTop = NonclickableEmptyTile(
        rummyTileHeight: rummyTileHeight,
        rummyTileWidth: rummyTileWidth,
        takozIndex: '32',
      );
    }
    else{

      List<String> parsedTile = thrown2.split('_'); // We parse tile to 2. index 0 is R1 and index 1 is 1 (clone number) in example.

      String tileWithColor = parsedTile[0]; // R10, R9
      String cloneNumber = parsedTile[1]; // 1 or 2

      String tileColor = tileWithColor[0]; // Color is always on index 0.

      // When we ignore the color at index 0, remaining part is tile number.
      String tileNumber = tileWithColor.substring(1);

      rummyTilesOnTheFloorLeftTop = NonclickableRummyTile(
        rummyTileHeight: rummyTileHeight,
        rummyTileWidth: rummyTileWidth,
        cloneIndex: cloneNumber,
        takozIndex: '32', // They are not at the takoz but we continue indexing them from 32.
        tileNumber: tileNumber,
        tileColor: tileColor == 'R' // If R, red,
            ? Colors.red
            : tileColor == 'K' // If K, black
            ? Colors.black
            : tileColor == 'B' // If B, blue
            ? Colors.blue
            : tileColor == 'Y' // If Y, yellow
            ? Colors.orange
            : Colors.green, // Else, (In joker situation) its green.
      );
    }

    // Index 3 Which can be selected by user. LEFT TILE
    if(thrown3 == 'E'){
      rummyTilesOnTheFloorLeftBot = NonclickableEmptyTile(
        rummyTileHeight: rummyTileHeight,
        rummyTileWidth: rummyTileWidth,
        takozIndex: '33',
      );
    }
    else{

      List<String> parsedTile = thrown3.split('_'); // We parse tile to 2. index 0 is R1 and index 1 is 1 (clone number) in example.

      String tileWithColor = parsedTile[0]; // R10, R9
      String cloneNumber = parsedTile[1]; // 1 or 2

      String tileColor = tileWithColor[0]; // Color is always on index 0.

      // When we ignore the color at index 0, remaining part is tile number.
      String tileNumber = tileWithColor.substring(1);

      if(isMyTurn){
        rummyTilesOnTheFloorLeftBot = TurnbasedClickableRummyTile(
          rummyTileHeight: rummyTileHeight,
          rummyTileWidth: rummyTileWidth,
          cloneIndex: cloneNumber,
          takozIndex: '33', // They are not at the takoz but we continue indexing them from 33.
          tileNumber: tileNumber,
          tileColor: tileColor == 'R' // If R, red,
              ? Colors.red
              : tileColor == 'K' // If K, black
              ? Colors.black
              : tileColor == 'B' // If B, blue
              ? Colors.blue
              : tileColor == 'Y' // If Y, yellow
              ? Colors.orange
              : Colors.green, // Else, (In joker situation) its green.
        );
      }
      else{
        rummyTilesOnTheFloorLeftBot = TurnpassedLeftTile(
          rummyTileHeight: rummyTileHeight,
          rummyTileWidth: rummyTileWidth,
          cloneIndex: cloneNumber,
          takozIndex: '33', // They are not at the takoz but we continue indexing them from 33.
          tileNumber: tileNumber,
          tileColor: tileColor == 'R' // If R, red,
              ? Colors.red
              : tileColor == 'K' // If K, black
              ? Colors.black
              : tileColor == 'B' // If B, blue
              ? Colors.blue
              : tileColor == 'Y' // If Y, yellow
              ? Colors.orange
              : Colors.green, // Else, (In joker situation) its green.
        );

      }


    }

  }


  // Middle tiles are coming from array 3.
  Widget midRummyTile = Container();
  Widget okeyRummyTile = Container();


  void constructMiddle(double rummyTileHeight, double rummyTileWidth, bool isMyTurn){
    String middle0 = dataProvider.rumiData[dataProvider.index].middleTiles[0];
    String okey1 = dataProvider.rumiData[dataProvider.index].middleTiles[1];
    String tilesRemaining = dataProvider.rumiData[dataProvider.index].middleTiles[2];

    // Middle tile
    if(middle0 == 'E'){
      midRummyTile = NonclickableEmptyTile(
        rummyTileHeight: rummyTileHeight,
        rummyTileWidth: rummyTileWidth,
        takozIndex: '34',
      );
    }
    else{

      List<String> parsedTile = middle0.split('_'); // We parse tile to 2. index 0 is R1 and index 1 is 1 (clone number) in example.

      String tileWithColor = parsedTile[0]; // R10, R9
      String cloneNumber = parsedTile[1]; // 1 or 2

      String tileColor = tileWithColor[0]; // Color is always on index 0.

      // When we ignore the color at index 0, remaining part is tile number.
      String tileNumber = tileWithColor.substring(1);

      if(isMyTurn){ // If its my turn, we can get middle tile.

        midRummyTile = TurnbasedMiddleRummyTile(
          rummyTileHeight: rummyTileHeight,
          rummyTileWidth: rummyTileWidth,
          cloneIndex: cloneNumber,
          takozIndex: '34', // They are not at the takoz but we continue indexing them from 30.
          tileNumber: tileNumber,
          tileColor: tileColor == 'R' // If R, red,
              ? Colors.red
              : tileColor == 'K' // If K, black
              ? Colors.black
              : tileColor == 'B' // If B, blue
              ? Colors.blue
              : tileColor == 'Y' // If Y, yellow
              ? Colors.orange
              : Colors.green, // Else, (In joker situation) its green.
          numberL: tilesRemaining,
        );

      }
      else{

        midRummyTile = TurnpassedMiddleTile(
          rummyTileHeight: rummyTileHeight,
          rummyTileWidth: rummyTileWidth,
          cloneIndex: cloneNumber,
          takozIndex: '34', // They are not at the takoz but we continue indexing them from 30.
          tileNumber: tileNumber,
          tileColor: tileColor == 'R' // If R, red,
              ? Colors.red
              : tileColor == 'K' // If K, black
              ? Colors.black
              : tileColor == 'B' // If B, blue
              ? Colors.blue
              : tileColor == 'Y' // If Y, yellow
              ? Colors.orange
              : Colors.green, // Else, (In joker situation) its green.
          numberL: tilesRemaining,
        );


      }


    }

    // Okey tile
    if(okey1 == 'E'){
      okeyRummyTile = EmptyRummyTile(
        rummyTileHeight: rummyTileHeight,
        rummyTileWidth: rummyTileWidth,
        anyRummyClicked: anyRummyClicked,
        takozIndex: '35',
/*        isMoved: isMoved,*/
      );
    }
    else{

      List<String> parsedTile = okey1.split('_'); // We parse tile to 2. index 0 is R1 and index 1 is 1 (clone number) in example.

      String tileWithColor = parsedTile[0]; // R10, R9
      String cloneNumber = parsedTile[1]; // 1 or 2

      String tileColor = tileWithColor[0]; // Color is always on index 0.

      // When we ignore the color at index 0, remaining part is tile number.
      String tileNumber = tileWithColor.substring(1);

      okeyRummyTile = NonclickableRummyTile(
        rummyTileHeight: rummyTileHeight,
        rummyTileWidth: rummyTileWidth,
        cloneIndex: cloneNumber,
        takozIndex: '35', // They are not at the takoz but we continue indexing them from 30.
        tileNumber: tileNumber,
        tileColor: tileColor == 'R' // If R, red,
            ? Colors.red
            : tileColor == 'K' // If K, black
            ? Colors.black
            : tileColor == 'B' // If B, blue
            ? Colors.blue
            : tileColor == 'Y' // If Y, yellow
            ? Colors.orange
            : Colors.green, // Else, (In joker situation) its green.
      );
    }

  }


  Widget winRummyTile = Container();

  void constructWinRummyTile(double rummyTileHeight, double rummyTileWidth, bool isMyTurn, bool isGetted, int won){

    print('WONNN GİRDİK ${ (playersTurnInfo == loginGlobals.username)}');
    print('WONNN GİRDİK $isGetted');
    print('WONNN GİRDİK $won');

    if( (playersTurnInfo == loginGlobals.username) && isGetted == true && won == 14){


      print('WONNN GİRDİK $isGetted');
      print('WONNN GİRDİK $won');

      setState(() {

        winRummyTile = WinTile(
          rummyTileHeight: rummyTileHeight,
          rummyTileWidth: rummyTileWidth,
          takozIndex: '40', // They are not at the takoz but we continue indexing them from 30.
          anyRummyClicked: anyRummyClicked,
        );

      });


    }
    else{ // User has 14 tiles on takoz.

      setState(() {
        winRummyTile = const SizedBox.shrink();
      });

    }

  }

  void constructFirstFloorWidgets(
      double rummyTileHeight, double rummyTileWidth) {

    // We will place filled and empty tiles 15 times to fill the first floor.
    for(int tileIndex = 0; tileIndex<15; tileIndex++){

      // Here we get the current data. after tilesTakoz with tileIndex, we access to the indexes tile as R1_1 in example.
      String fullTile = dataProvider.rumiData[dataProvider.index].tilesTakoz[tileIndex];

      // If we get 'E' as tile, it means its Empty so we will place a empty tile in here.
      if(fullTile == 'E'){
        firstFloor.add(EmptyRummyTile(
            rummyTileHeight: rummyTileHeight,
            rummyTileWidth: rummyTileWidth,
            anyRummyClicked: anyRummyClicked,
            takozIndex: tileIndex.toString(),
/*            isMoved: isMoved,*/
          ),
        );
      }else{ // If we get a normal tile,

        print('FULL TILE: $fullTile');
        List<String> parsedTile = fullTile.split('_'); // We parse tile to 2. index 0 is R1 and index 1 is 1 (clone number) in example.

        String tileWithColor = parsedTile[0]; // R10, R9
        String cloneNumber = parsedTile[1]; // 1 or 2

        String tileColor = tileWithColor[0]; // Color is always on index 0.

        // When we ignore the color at index 0, remaining part is tile number.
        String tileNumber = tileWithColor.substring(1);


        firstFloor.add(ClickableRummyTile(
          rummyTileHeight: rummyTileHeight,
          rummyTileWidth: rummyTileWidth,
          cloneIndex: cloneNumber, // Tiles have clones. 1 or 2
          takozIndex: tileIndex.toString(), // We hold the value of the current index as takozIndex to follow the place of that tile.
          tileNumber: tileNumber,
          tileColor: tileColor == 'R' // If R, red,
              ? Colors.red
              : tileColor == 'K' // If K, black
              ? Colors.black
              : tileColor == 'B' // If B, blue
              ? Colors.blue
              : tileColor == 'Y' // If Y, yellow
              ? Colors.orange
              : Colors.green, // Else, (In joker situation) its green.
        )
        );
      }
    } // End of my for to build first floor.
  } // End of first floor construction.

  // Second floor
  void constructSecondFloorWidgets(
      double rummyTileHeight, double rummyTileWidth) {

    // We will place filled and empty tiles 15 times again to fill the second floor.
    for(int tileIndex = 15; tileIndex<30; tileIndex++){ // Index starts from 15 and ends at 29 for second floor.

      // Here we get the current data. after tilesTakoz with tileIndex, we access to the indexes tile as R1_1 in example.
      String fullTile = dataProvider.rumiData[dataProvider.index].tilesTakoz[tileIndex];

      // If we get 'E' as tile, it means its Empty so we will place a empty tile in here.
      if(fullTile == 'E'){
        secondFloor.add(EmptyRummyTile(
            rummyTileHeight: rummyTileHeight,
            rummyTileWidth: rummyTileWidth,
            anyRummyClicked: anyRummyClicked,
            takozIndex: tileIndex.toString(),
/*            isMoved: isMoved,*/
          ),
        );
      }else{ // If we get a normal tile,

        List<String> parsedTile = fullTile.split('_'); // We parse tile to 2. index 0 is R1 and index 1 is 1 (clone number) in example.

        String tileWithColor = parsedTile[0]; // R10, R9
        String cloneNumber = parsedTile[1]; // 1 or 2

        String tileColor = tileWithColor[0]; // Color is always on index 0.

        // When we ignore the color at index 0, remaining part is tile number.
        String tileNumber = tileWithColor.substring(1);


        secondFloor.add(ClickableRummyTile(
          rummyTileHeight: rummyTileHeight,
          rummyTileWidth: rummyTileWidth,
          cloneIndex: cloneNumber, // Tiles have clones. 1 or 2
          takozIndex: tileIndex.toString(), // We hold the value of the current index as takozIndex to follow the place of that tile.
          tileNumber: tileNumber,
          tileColor: tileColor == 'R' // If R, red,
              ? Colors.red
              : tileColor == 'K' // If K, black
              ? Colors.black
              : tileColor == 'B' // If B, blue
              ? Colors.blue
              : tileColor == 'Y' // If Y, yellow
              ? Colors.orange
              : Colors.green, // Else, (In joker situation) its green.
        )
        );
      }
    } // End of my for to build second floor.

  } // End of second floor construction.

  // Function to move the current list according to the given move.
  List<String> moveTile(List<String> before, int fromTile, int toTile ){

    // Holds board after move.
    List<String> after = List.from(before);// We copy list to after.

    // Carrying the held tile to placed tile.
    after[toTile] = before[fromTile];
    // Placed tile to held tile.
    after[fromTile] = before[toTile];

    return after;
  }

  // Implement with server.
  String createMoveRequestMessage(List<String> newTakoz, String initPoint){

    String created = '';

    const String myHand = 'MYHAND|';

    created += myHand;

    created += loginGlobals.token;

    for(int i=0;i<30;i++){
      created += '|';
      created += newTakoz[i];
    }

    created += '|';

    created += initPoint;

    return created;
  }

  String createThrowRequestMessage(String thrownTile, String initPoint){

    String created = '';

    const String playTurn = 'PLAYTURN|';

    created += playTurn;

    created += loginGlobals.token;

    created += '|';

    created += thrownTile;

    created += '|';

    created += initPoint;


    return created;
  }

  String createGetRequestMessage(String strOY, String placeIndex){

    String created = '';

    const String getStone = 'GETSTONE|';

    created += getStone;

    created += loginGlobals.token;

    created += '|';

    created += strOY;

    created += '|';

    created += placeIndex;

    return created;
  }

  String createQuitRequestMessage(){

    String created = '';

    const String iQuit = 'QUIT|';

    created += iQuit;

    created += loginGlobals.token;

    created += '|';

    created += '2'; // Lobby id of the okey

    return created;
  }

  String createWinRequestMessage(){

    String created = '';

    const String iWin = 'WIN|';

    created += iWin;

    created += loginGlobals.token;

    created += '|';

    created += '2'; // Lobby id of the okey

    return created;
  }

  void _sendBoardRequest() async {
    try {
      // Create a new socket for each request
      Socket _socket = await Socket.connect(loginGlobals.piIP, 8080);
      // Send a simple message to the server
      _socket.write('GETGAMEBOARD|${loginGlobals.token}|OKEY');

      // Listen for responses from the server
      _socket.listen(
            (List<int> data) {
          // Convert the received data to a String
          String response = utf8.decode(data);

          // Update the UI with the received response
          print('Received from server: $response');

          resp = response;

          // Close the socket after receiving a response
          _socket.close();
        },
        onDone: () {
          // Handle when the server closes the connection
          print('Server closed the connection');
        },
        onError: (error) {
          // Handle any errors that occur during communication
          print('Error receiving response: $error');
          // Close the socket in case of an error
          _socket.close();
        },
      );
    } catch (e) {
      print('Error sending request: $e');
    }
  }

  void _sendMoveRequest(String moveReq) async {
    try {
      // Create a new socket for each request
      // 10.42.0.1 IP of rasp
      Socket _socket = await Socket.connect(loginGlobals.piIP, 8080);

      // Send a simple message to the server
      _socket.write(moveReq);

      // Listen for responses from the server
      _socket.listen(
            (List<int> data) {
          // Convert the received data to a String
          String response = utf8.decode(data);

          // Update the UI with the received response
         // print('Received from server MOVE: $response');

          // Close the socket after receiving a response
          _socket.close();
        },
        onDone: () {
          // Handle when the server closes the connection
          print('Server closed the connection');
        },
        onError: (error) {
          // Handle any errors that occur during communication
          print('Error receiving response: $error');
          // Close the socket in case of an error
          _socket.close();
        },
      );
    } catch (e) {
      print('Error sending request: $e');
    }
  }

  void _sendThrowTileRequest(String throwReq) async {

    try {
      // Create a new socket for each request
      // 10.42.0.1 IP of rasp
      Socket _socket = await Socket.connect(loginGlobals.piIP, 8080);

      // Send a simple message to the server
      _socket.write(throwReq);

      // Listen for responses from the server
      _socket.listen(
            (List<int> data) {
          // Convert the received data to a String
          String response = utf8.decode(data);

          // Update the UI with the received response
          // print('Received from server MOVE: $response');

          // Close the socket after receiving a response
          _socket.close();
        },
        onDone: () {
          // Handle when the server closes the connection
          print('Server closed the connection');
        },
        onError: (error) {
          // Handle any errors that occur during communication
          print('Error receiving response: $error');
          // Close the socket in case of an error
          _socket.close();
        },
      );
    } catch (e) {
      print('Error sending request: $e');
    }

  }

  void _sendGetTileRequest(String getReq) async {

    try {
      // Create a new socket for each request
      // 10.42.0.1 IP of rasp
      Socket _socket = await Socket.connect(loginGlobals.piIP, 8080);

      // Send a simple message to the server
      _socket.write(getReq);

      // Listen for responses from the server
      _socket.listen(
            (List<int> data) {
          // Convert the received data to a String
          String response = utf8.decode(data);

          // Update the UI with the received response
          // print('Received from server MOVE: $response');

          // Close the socket after receiving a response
          _socket.close();
        },
        onDone: () {
          // Handle when the server closes the connection
          print('Server closed the connection');
        },
        onError: (error) {
          // Handle any errors that occur during communication
          print('Error receiving response: $error');
          // Close the socket in case of an error
          _socket.close();
        },
      );
    } catch (e) {
      print('Error sending request: $e');
    }

  }

  void _sendQuitRequest(String quitReq) async {

    try {
      // Create a new socket for each request
      // 10.42.0.1 IP of rasp
      Socket _socket = await Socket.connect(loginGlobals.piIP, 8080);

      print('SERVER PATLIYO QUITTE');
      // Send a simple message to the server
      _socket.write(quitReq);

      // Listen for responses from the server
      _socket.listen(
            (List<int> data) {
          // Convert the received data to a String
          String response = utf8.decode(data);

          print('EZPEZLEMONSQZ: $response');

          // Update the UI with the received response
          // print('Received from server MOVE: $response');

          // Close the socket after receiving a response
          _socket.close();
        },
        onDone: () {
          // Handle when the server closes the connection
          print('Server closed the connection');
        },
        onError: (error) {
          // Handle any errors that occur during communication
          print('Error receiving response: $error');
          // Close the socket in case of an error
          _socket.close();
        },
      );
    } catch (e) {
      print('Error sending request: $e');
    }

  }

  void _sendWinRequest(String winReq) async {

    try {
      // Create a new socket for each request
      // 10.42.0.1 IP of rasp
      Socket _socket = await Socket.connect(loginGlobals.piIP, 8080);

      print('SERVER PATLIYO MU WINDE');
      // Send a simple message to the server
      _socket.write(winReq);

      // Listen for responses from the server
      _socket.listen(
            (List<int> data) {
          // Convert the received data to a String
          String response = utf8.decode(data);

          print('Yok patlamıyo winde: $response');

          // Update the UI with the received response
          // print('Received from server MOVE: $response');

          // Close the socket after receiving a response
          _socket.close();
        },
        onDone: () {
          // Handle when the server closes the connection
          print('Server closed the connection');
        },
        onError: (error) {
          // Handle any errors that occur during communication
          print('Error receiving response: $error');
          // Close the socket in case of an error
          _socket.close();
        },
      );
    } catch (e) {
      print('Error sending request: $e');
    }

  }


  // Our initial state is here.
  @override
  void initState(){
    super.initState();

    dataProvider = RummikubDataProvider();

    String strChecker = '';
    String strTilesTakoz = '';
    String strTilesThrown = '';
    String strMiddleTiles = '';
    String strUserTurn = '';
    String strWinner = '';
    String strQuitter = '';

    setState(() {
      globReset();
    });


    timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {

      setState(() {

        List<String> array = exampleResponse.split('/'); // We parse the response here.

        if(array.length>=6){
          strChecker = array[0];
          strTilesTakoz = array[1];
          strTilesThrown = array[2];
          strMiddleTiles = array[3];
          strUserTurn = array[4];
          strWinner = array[5];
          strQuitter = array[6];
        }

        String checker = strChecker;    // We get the checker here.
        List<String> tilesTakoz = strTilesTakoz.split('|'); // We parse the tiles on takoz here.
        List<String> tilesThrown = strTilesThrown.split('|');    // We parse the tiles thrown to board here.
        List<String> middleTiles = strMiddleTiles.split('|');    // We parse the middle tiles here.
        String userTurn = strUserTurn;    // We get the username of this turn.

        winnerPlayer = strWinner;

        quitterPlayer = strQuitter;

        RummikubData newRummikubData = RummikubData(checker, tilesTakoz, tilesThrown, middleTiles, userTurn);

        _sendBoardRequest();
        // We update the all data.

        /*print('Response::::');
        print(resp);
        print('Before::::');
        print(exampleResponse);*/
        if(resp.substring(0) != '0'){
          exampleResponse = resp.substring(0);
        }

        dataProvider.updateRummikubData(newRummikubData);

        if(quitterPlayer != 'empty'){
          if(quitterPlayer != ''){
            timer.cancel();
            _showQuitterDialog(context);

          }
        }


        if(winnerPlayer != 'empty'){
          if(winnerPlayer != '') {
            timer.cancel();
            _showWinDialog(context);
          }
        }

        /*print('After::::');
        print(exampleResponse);*/

        firstFloor.clear();
        constructFirstFloorWidgets(rmtH, rmtW);

        secondFloor.clear();
        constructSecondFloorWidgets(rmtH, rmtW);

        /*print("First Floor Length: ${firstFloor.length}");
        print("Second Floor Length: ${secondFloor.length}");*/

        /*won = numTilesInAllPers(tilesTakoz.sublist(0,15),tilesTakoz.sublist(15), middleTiles[1]);
        print('WON NUMBERRRRRRR :::::  $won');*/


        numberOfTiles = getNumberOfTiles(tilesTakoz); // Updates the number of tiles
        print('IMDATT :::: $numberOfTiles');

        if(numberOfTiles == 14){ // When user have 15 tile on board, we should make get turn false.
          checkPlayerTurn(userTurn);
          isGet = false;
        }
        else if(numberOfTiles == 15){
          isTurn = false;
          isGet = true;

        }


        constructThrown(rmtH, rmtW, isTurn, isGet);

        constructMiddle(rmtH, rmtW, isTurn);

        constructWinRummyTile(rmtH, rmtW, isTurn, isGet, won);


        print('ISTURN: $isTurn');
        checkAnyRummyClicked();

        checkAnyEmptyClicked();

        updateFromTile();

        updateToTile();


        // Checks if user get tile from middle.
        if(TurnbasedMiddleRummyTileGlobals.isAnyClicked){

          if(fromTile == 34){ // Ortadaki taş index = 34

            /*String middleTileStr = middleTiles[0]; // gets the clicked left tile.
            */
            if(toTile != -1){ // When toTile is selected too.
              String toTileStr = toTile.toString();
              print('GET TILE MIDDLE: $toTileStr');
              String getReq = createGetRequestMessage('O', toTileStr);

              _sendGetTileRequest(getReq);

              TurnbasedMiddleRummyTileGlobals.isAnyClicked = false;
              EmptyRummyTileGlobals.isAnyEmptyClicked = false;
              // Resetting the global index of clicked.
              EmptyRummyTileGlobals.placedTileIndex = -1;

              TurnbasedMiddleRummyTileGlobals.clickedTileIndex = -1;

              anyEmptyClicked = false;

              // Getting turn is passed. Now its time to throw.
              isTurn = false;
              isGet = true;

            }


          }

        }

        // If moved, we need to construct them again.
        constructThrown(rmtH, rmtW, isTurn, isGet);

        constructMiddle(rmtH, rmtW, isTurn);

        constructWinRummyTile(rmtH, rmtW, isTurn, isGet, won);

        // Checks if user get tile from left.
        if(TurnbasedClickableRummyTileGlobals.isAnyClicked){ // Soldaki taş index = 33;

          if(fromTile == 33){ // Soldaki taş index = 33;

            /*String leftTileStr = tilesThrown[3]; // gets the clicked left tile.
            print('GET TILE LEFT: $leftTileStr');*/

            if(toTile != -1){// When toTile is selected too.
              String toTileStr = toTile.toString();
              print('GET TILE LEFT: $toTileStr');
              String getReq = createGetRequestMessage('Y', toTileStr);

              _sendGetTileRequest(getReq);

              TurnbasedClickableRummyTileGlobals.isAnyClicked = false;
              EmptyRummyTileGlobals.isAnyEmptyClicked = false;
              // Resetting the global index of clicked.
              EmptyRummyTileGlobals.placedTileIndex = -1;

              TurnbasedClickableRummyTileGlobals.clickedTileIndex = -1;

              anyEmptyClicked = false;

              // Getting turn is passed. Now its time to throw.
              isTurn = false;
              isGet = true;

            }

          }

        }

        // If moved, we need to construct them again.
        constructThrown(rmtH, rmtW, isTurn, isGet);

        constructMiddle(rmtH, rmtW, isTurn);

        constructWinRummyTile(rmtH, rmtW, isTurn, isGet, won);

        // This function checks if user thrown any tile to win.
        if(ClickableRummyTileGlobals.isAnyClicked){

          if(toTile == 40){ // If win tile is selected after that,

            String thrownTileStr = tilesTakoz[fromTile]; // Gets the clicked tile,

            timer.cancel();

            _sendWinRequest(createWinRequestMessage());

            _showWinDialog(context);

            ClickableRummyTileGlobals.isAnyClicked = false;
            EmptyRummyTileGlobals.isAnyEmptyClicked = false;
            // Resetting the global index of clicked.
            EmptyRummyTileGlobals.placedTileIndex = -1;

            ClickableRummyTileGlobals.clickedTileIndex = -1;

            // Its thrown. All turns passed
            isTurn = false;
            isGet = false;

          }

        }




        // This function checks if user thrown any tile to board.
        if(ClickableRummyTileGlobals.isAnyClicked){

          if(toTile == 30){ // If right tile is selected after that,

            String thrownTileStr = tilesTakoz[fromTile]; // Gets the clicked tile,


            print('THROWN:$thrownTileStr');
            String throwReq = createThrowRequestMessage(thrownTileStr, won.toString());

            _sendThrowTileRequest(throwReq);

            ClickableRummyTileGlobals.isAnyClicked = false;
            EmptyRummyTileGlobals.isAnyEmptyClicked = false;
            // Resetting the global index of clicked.
            EmptyRummyTileGlobals.placedTileIndex = -1;

            ClickableRummyTileGlobals.clickedTileIndex = -1;

            // Its thrown. All turns passed
            isTurn = false;
            isGet = false;

          }

        }

        // If moved, we need to construct them again.
        constructThrown(rmtH, rmtW, isTurn, isGet);

        constructMiddle(rmtH, rmtW, isTurn);

        constructWinRummyTile(rmtH, rmtW, isTurn, isGet, won);

        updateFromTile();

        updateToTile();

        if(anyEmptyClicked){ // If user can and click any empty tile, it means user moved that tile.
          List<String> newTakoz = [];
          print("From: $fromTile To: $toTile");
// TODO: okey held?



          if(fromTile != -1  && toTile != -1){

            newTakoz = moveTile(tilesTakoz, fromTile, toTile);

            List<String> tempTakoz = [];
            tempTakoz.addAll(tilesTakoz);

            tempTakoz[fromTile] = 'E';

            // R1_2
            String shower = middleTiles[1];

            String showerT1 = shower.split('_')[0];

            int okeyNum = int.parse(showerT1.substring(1));

            if(okeyNum == 13){
              okeyNum = 1;
            }else{
              ++okeyNum;
            }

            String okeyToSend = showerT1[0] + okeyNum.toString();

            print('OKEY: $okeyToSend');

            won = numTilesInAllPers(tempTakoz.sublist(0,15),tempTakoz.sublist(15), okeyToSend);
            print('WON NUMBERRRRRRR :::::  $won');


            // fromTile checker
            bool fromTileFlag = false;
            if( -1<fromTile && fromTile<15 ){ // If first floor
              fromTileFlag = firstFloor.elementAt(fromTile) is ClickableRummyTile;
            }
            else if(14<fromTile){ // Second floor.
              fromTileFlag = secondFloor.elementAt(fromTile-15) is ClickableRummyTile;
            }

            // toTile checker
            bool toTileFlag = false;
            if( -1<toTile && toTile<15 ){ // If first floor
              toTileFlag = firstFloor.elementAt(toTile) is EmptyRummyTile;
            }
            else if(14<toTile){ // Second floor.
              toTileFlag = secondFloor.elementAt(toTile-15) is EmptyRummyTile;
            }

            //print("Fromtileflag: $fromTileFlag ToTileFlag: $toTileFlag");
            if(fromTileFlag && toTileFlag){
              //print("New Takoz: $newTakoz");
              String tempReq = createMoveRequestMessage(newTakoz,won.toString());
              //print("Request: $tempReq");
              _sendMoveRequest(tempReq);
            }

            ClickableRummyTileGlobals.isAnyClicked = false;
            EmptyRummyTileGlobals.isAnyEmptyClicked = false;
            // Resetting the global index of clicked.
            EmptyRummyTileGlobals.placedTileIndex = -1;

            ClickableRummyTileGlobals.clickedTileIndex = -1;

          }


        }



      });



      // Function to test initial state and provider. (Above the iterate data logically.)
      //print("Updated data: ${dataProvider.rumiData[dataProvider.index].middleTiles}");

      // We iterate through current data. All the data is logged rn at dataProvider.
      dataProvider.iterateIndex();

    });

    // Orientation for state.
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft]);

  }

  @override
  void dispose() {

    // We are stopping the timer when widget disposed.
    timer.cancel();

    // orientation set
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  // rummyTile height and weight used to carry to initial state.
  double rmtH = 0;
  double rmtW = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double holderWidth = size.width * 0.8;
    double holderHeight = holderWidth * 0.213;
    double rummyTileHeight = holderHeight * 0.35;
    double rummyTileWidth = (holderWidth * 0.78) / 15;

    rmtH = rummyTileHeight;
    rmtW = rummyTileWidth;

    return Scaffold(
      backgroundColor: const Color(0xff297446),
      //resizeToAvoidBottomInset: false,
      body: PopScope(
        canPop: false,
        onPopInvoked: (bool didPop) {
          _showExitDialog(context);
          return;
        },
        child: SafeArea(
          child: Stack(children: [
            Positioned(
              top: 16.0,
              left: 16.0,
              child: FloatingActionButton(
                onPressed: () {
                  _showExitDialog(context);
                },
                tooltip: 'Leave',
                child: const Icon(Icons.exit_to_app),
              ),
            ),
            // players -start
            Positioned(
              top: size.height * 0.275,
              left: size.width * 0.02,
              child: PlayerFrame(
                frameHeight: rummyTileHeight * 1.5,
                frameWidth: rummyTileWidth * 1.75,
                playerIcon: Image.asset(mainMenuGlobals.picList[
                widget.infoLUR[0].hashCode % mainMenuGlobals.ICON_NUMBER]),
                playerName: widget.infoLUR[0],
                turnInfo: playersTurnInfo,
              ),
            ),
            Positioned(
              top: size.height * 0.275,
              right: size.width * 0.02,
              child: PlayerFrame(
                frameHeight: rummyTileHeight * 1.5,
                frameWidth: rummyTileWidth * 1.75,
                playerIcon: Image.asset(mainMenuGlobals.picList[
                widget.infoLUR[2].hashCode % mainMenuGlobals.ICON_NUMBER]),
                playerName: widget.infoLUR[2],
                turnInfo: playersTurnInfo,
              ),
            ),
            Positioned(
              top: size.height * 0.02,
              left: size.width * 0.5 - (rummyTileWidth * 1.75) * 0.5,
              child: PlayerFrame(
                frameHeight: rummyTileHeight * 1.5,
                frameWidth: rummyTileWidth * 1.75,
                playerIcon: Image.asset(mainMenuGlobals.picList[
                widget.infoLUR[1].hashCode % mainMenuGlobals.ICON_NUMBER]),
                playerName: widget.infoLUR[1],
                turnInfo: playersTurnInfo,
              ),
            ),
            // players -end
            //okey tile
            Positioned(
                top: size.height * 0.3,
                right: size.width * 0.5 + 2,
                height: rummyTileHeight,
                width: rummyTileWidth,
                child: okeyRummyTile),
            // mid rummy tiles
            Positioned(
              top: size.height * 0.3,
              left: size.width * 0.5 + 2,
              height: rummyTileHeight,
              width: rummyTileWidth,
              child: midRummyTile,
            ),
            Positioned(
              top: size.height * 0.3,
              left: size.width * 0.548,
              height: rummyTileHeight,
              width: rummyTileWidth,
              child: winRummyTile,
            ),
        
            Positioned(
              top: size.height * 0.1,
              left: size.width * 0.15,
              height: rummyTileHeight,
              width: rummyTileWidth,
              child: rummyTilesOnTheFloorLeftTop,
            ),
            Positioned(
              top: size.height * 0.1,
              right: size.width * 0.15,
              height: rummyTileHeight,
              width: rummyTileWidth,
              child: rummyTilesOnTheFloorRightTop,
            ),
            Positioned(
              bottom: holderHeight + holderHeight * 0.08,
              right: size.width * 0.15,
              height: rummyTileHeight,
              width: rummyTileWidth,
              child: rummyTilesOnTheFloorRightBot,
            ),
            Positioned(
              bottom: holderHeight + holderHeight * 0.08,
              left: size.width * 0.15,
              height: rummyTileHeight,
              width: rummyTileWidth,
              child: rummyTilesOnTheFloorLeftBot,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                // board
                Positioned(
                  bottom: 0,
                  width: holderWidth,
                  height: holderHeight,
        
                  child: Container(
                    width: holderWidth,
                    height: holderHeight,
                    decoration: (playersTurnInfo == loginGlobals.username) || numberOfTiles == 15 ? BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellowAccent.withOpacity(1.0),
                          spreadRadius: 6,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ) : BoxDecoration(),
                    child: const Image(
                      image: AssetImage('assets/images/takoz.png'),
                    ),
                  ),
                ),
                // first floor
                Positioned(
                  bottom: holderHeight * 0.56,
                  height: rummyTileHeight + 3,
                  child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: firstFloor),
                ),
                //second floor
                Positioned(
                  bottom: holderHeight * 0.05,
                  //width: holderWidth * 0.92,
                  height: rummyTileHeight + 3,
                  child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: secondFloor),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    bool exit = false;

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Leaving the game will destroy the okey board and result in -1 point penalty!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                exit = false;
                Navigator.of(context).pop();
              },
              child: Text('No, I will stay.'),
            ),
            TextButton(
              onPressed: () {
                exit = true;
                Navigator.of(context).pop();
              },
              child: Text('Yes, leave anyway.'),
            ),
          ],
        );
      },
    );

    if (exit) {
      _sendQuitRequest(createQuitRequestMessage());
      _navigateToLobby();
    }

    return Future.value(!exit); // Return whether to allow or block the exit
  }

  void _showWinDialog(BuildContext context) async {

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('GAME OVER'),
          content: winnerPlayer == "empty" ? Text('The winner is: YOU! Congrats.') :
          Text('The winner is: $winnerPlayer'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToLobby();
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );

  }

  void _showQuitterDialog(BuildContext context) async {

    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('USER LEAVED GAME'),
          content: Text('The quitter  is: $quitterPlayer'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToLobby();
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToLobby() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LobbyScreen()),
    );
  }

}
