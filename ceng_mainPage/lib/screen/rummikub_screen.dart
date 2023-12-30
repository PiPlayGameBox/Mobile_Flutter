import 'dart:convert';
import 'dart:io';

import 'package:ceng_mainpage/provider/rummikub_data_provider.dart';
import 'package:ceng_mainpage/widget/clickable_rummy_tile.dart';
import 'package:ceng_mainpage/widget/empty_rummy_tile.dart';
import 'package:ceng_mainpage/widget/mid_rummy_tile.dart';
import 'package:ceng_mainpage/widget/nonclickable_rummy_tile.dart';
import 'package:ceng_mainpage/widget/player_frame.dart';
import 'package:ceng_mainpage/widget/rummy_tile.dart';
import 'package:ceng_mainpage/widget/turnbased_clickable_rummy_tile.dart';
import 'package:ceng_mainpage/widget/turnbased_middle_rummy_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:async';

import 'package:provider/provider.dart';

String respToken = '0';
String resp = '0';
String exampleResponse = 'OK/E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|E|/E|E|E|E|/E|E|48';
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



class RummikubScreen extends StatefulWidget {
  static String routeName = '/rummikub';


  const RummikubScreen({
    Key? key,
    required this.token,
  }) : super(key: key);

  final String token;

  @override
  State<RummikubScreen> createState() => _RummikubScreenState();
}

class _RummikubScreenState extends State<RummikubScreen> {
  // Provider and Timer of Rummikub game.
  // We indexed and followed the state. Without iterateIndex method, we would only see the first provider.
  // So use the provider's current data, we need to use like: "dataProvider.rumiData[dataProvider.index].middleTiles" in example.
  late RummikubDataProvider dataProvider;
  late Timer timer;

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




  // Thrown tiles are coming from array 2.
  Widget rummyTilesOnTheFloorRightBot = Container();
  Widget rummyTilesOnTheFloorRightTop = Container();
  Widget rummyTilesOnTheFloorLeftTop = Container();
  Widget rummyTilesOnTheFloorLeftBot = Container();

  void constructThrown(double rummyTileHeight, double rummyTileWidth){

    String thrown0 = dataProvider.rumiData[dataProvider.index].tilesThrown[0];
    String thrown1 = dataProvider.rumiData[dataProvider.index].tilesThrown[1];
    String thrown2 = dataProvider.rumiData[dataProvider.index].tilesThrown[2];
    String thrown3 = dataProvider.rumiData[dataProvider.index].tilesThrown[3];

    // Index 0
    if(thrown0 == 'E'){
      rummyTilesOnTheFloorRightBot = EmptyRummyTile(
          rummyTileHeight: rummyTileHeight,
          rummyTileWidth: rummyTileWidth,
          anyRummyClicked: anyRummyClicked,
          takozIndex: '30',
/*          isMoved: isMoved,*/
      );
    }
    else{

      List<String> parsedTile = thrown0.split('_'); // We parse tile to 2. index 0 is R1 and index 1 is 1 (clone number) in example.

      String tileWithColor = parsedTile[0]; // R10, R9
      String cloneNumber = parsedTile[1]; // 1 or 2

      String tileColor = tileWithColor[0]; // Color is always on index 0.

      // When we ignore the color at index 0, remaining part is tile number.
      String tileNumber = tileWithColor.substring(1);

      rummyTilesOnTheFloorRightBot = NonclickableRummyTile(
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

    // Index 1
    if(thrown1 == 'E'){
      rummyTilesOnTheFloorRightTop = EmptyRummyTile(
        rummyTileHeight: rummyTileHeight,
        rummyTileWidth: rummyTileWidth,
        anyRummyClicked: anyRummyClicked,
        takozIndex: '31',
/*        isMoved: isMoved,*/
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
      rummyTilesOnTheFloorLeftTop = EmptyRummyTile(
        rummyTileHeight: rummyTileHeight,
        rummyTileWidth: rummyTileWidth,
        anyRummyClicked: anyRummyClicked,
        takozIndex: '32',
/*        isMoved: isMoved,*/
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

    // Index 3 Which can be selected by user.
    if(thrown3 == 'E'){
      rummyTilesOnTheFloorLeftBot = EmptyRummyTile(
        rummyTileHeight: rummyTileHeight,
        rummyTileWidth: rummyTileWidth,
        anyRummyClicked: anyRummyClicked,
        takozIndex: '33',
/*        isMoved: isMoved,*/
      );
    }
    else{

      List<String> parsedTile = thrown3.split('_'); // We parse tile to 2. index 0 is R1 and index 1 is 1 (clone number) in example.

      String tileWithColor = parsedTile[0]; // R10, R9
      String cloneNumber = parsedTile[1]; // 1 or 2

      String tileColor = tileWithColor[0]; // Color is always on index 0.

      // When we ignore the color at index 0, remaining part is tile number.
      String tileNumber = tileWithColor.substring(1);

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

  }


  // Middle tiles are coming from array 3.
  Widget midRummyTile = Container();
  Widget okeyRummyTile = Container();


  void constructMiddle(double rummyTileHeight, double rummyTileWidth){
    String middle0 = dataProvider.rumiData[dataProvider.index].middleTiles[0];
    String okey1 = dataProvider.rumiData[dataProvider.index].middleTiles[1];
    String tilesRemaining = dataProvider.rumiData[dataProvider.index].middleTiles[2];

    // Middle tile
    if(middle0 == 'E'){
      midRummyTile = EmptyRummyTile(
        rummyTileHeight: rummyTileHeight,
        rummyTileWidth: rummyTileWidth,
        anyRummyClicked: anyRummyClicked,
        takozIndex: '34',
/*        isMoved: isMoved,*/
      );
    }
    else{

      List<String> parsedTile = middle0.split('_'); // We parse tile to 2. index 0 is R1 and index 1 is 1 (clone number) in example.

      String tileWithColor = parsedTile[0]; // R10, R9
      String cloneNumber = parsedTile[1]; // 1 or 2

      String tileColor = tileWithColor[0]; // Color is always on index 0.

      // When we ignore the color at index 0, remaining part is tile number.
      String tileNumber = tileWithColor.substring(1);

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
  String createMoveRequestMessage(List<String> newTakoz){

    String created = '';

    const String myHand = 'MYHAND|';

    created += myHand;

    created += respToken;

    for(int i=0;i<30;i++){
      created += '|';
      created += newTakoz[i];
    }

    return created;
  }

  String createThrowRequestMessage(String thrownTile){

    String created = '';

    const String playTurn = 'PLAYTURN|';

    created += playTurn;

    created += respToken;

    created += '|';

    created += thrownTile;

    return created;
  }

  void _sendBoardRequest() async {
    try {
      // Create a new socket for each request
      Socket _socket = await Socket.connect('127.0.0.1', 8080);
      //print('Token::::');
      //print(respToken);
      // Send a simple message to the server
      _socket.write('GETGAMEBOARD|$respToken|OKEY');

      // Listen for responses from the server
      _socket.listen(
            (List<int> data) {
          // Convert the received data to a String
          String response = utf8.decode(data);

          // Update the UI with the received response
          //print('Received from server: $response');

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
      Socket _socket = await Socket.connect('127.0.0.1', 8080);

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
      Socket _socket = await Socket.connect('127.0.0.1', 8080);

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

  /*void _sendTCPRequest() async {
    try {
      // Create a new socket for each request
      Socket _socket = await Socket.connect('10.42.0.1', 8080);

      // Send a simple message to the server
      _socket.write('LOGIN|huseyin|123456');

      // Listen for responses from the server
      _socket.listen(
            (List<int> data) {
          // Convert the received data to a String
          String response = utf8.decode(data);

          // Update the UI with the received response
          print('Received from server: $response');

          List<String> parts = response.split('|');

          respToken = parts[1];
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
  }*/

  // Our initial state is here.
  @override
  void initState(){
    super.initState();
    respToken = widget.token;

    dataProvider = RummikubDataProvider();

    String strChecker = '';
    String strTilesTakoz = '';
    String strTilesThrown = '';
    String strMiddleTiles = '';


    timer = Timer.periodic(const Duration(milliseconds: 100), (Timer timer) {

      setState(() {

        List<String> array = exampleResponse.split('/'); // We parse the response here.

        if(array.length>=2){
          strChecker = array[0];
          strTilesTakoz = array[1];
          strTilesThrown = array[2];
          strMiddleTiles = array[3];
        }

        String checker = strChecker;    // We get the checker here.
        List<String> tilesTakoz = strTilesTakoz.split('|'); // We parse the tiles on takoz here.
        List<String> tilesThrown = strTilesThrown.split('|');    // We parse the tiles thrown to board here.
        List<String> middleTiles = strMiddleTiles.split('|');    // We parse the middle tiles here.

        RummikubData newRummikubData = RummikubData(checker, tilesTakoz, tilesThrown, middleTiles);

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

        /*print('After::::');
        print(exampleResponse);*/

        firstFloor.clear();
        constructFirstFloorWidgets(rmtH, rmtW);

        secondFloor.clear();
        constructSecondFloorWidgets(rmtH, rmtW);

        /*print("First Floor Length: ${firstFloor.length}");
        print("Second Floor Length: ${secondFloor.length}");*/


        constructThrown(rmtH, rmtW);

        constructMiddle(rmtH, rmtW);

        checkAnyRummyClicked();

        checkAnyEmptyClicked();

        updateFromTile();

        updateToTile();

        // This function checks if user thrown any tile to board.
        if(ClickableRummyTileGlobals.isAnyClicked){

          if(toTile == 30){ // If right tile is selected after that,

            String thrownTileStr = tilesTakoz[fromTile]; // Gets the cliked tile,


            print('THROWN:$thrownTileStr');
            String throwReq = createThrowRequestMessage(thrownTileStr);

            _sendThrowTileRequest(throwReq);

            ClickableRummyTileGlobals.isAnyClicked = false;
            EmptyRummyTileGlobals.isAnyEmptyClicked = false;
            // Resetting the global index of clicked.
            EmptyRummyTileGlobals.placedTileIndex = -1;

            ClickableRummyTileGlobals.clickedTileIndex = -1;

          }

        }

        updateFromTile();

        updateToTile();

        if(anyEmptyClicked){ // If user can and click any empty tile, it means user moved that tile.
          List<String> newTakoz = [];
          print("From: $fromTile To: $toTile");
          if(fromTile != -1  && toTile != -1){
            newTakoz = moveTile(tilesTakoz, fromTile, toTile);



            // fromTile checker
            bool fromTileFlag = false;
            if( -1<fromTile && fromTile<15 ){ // If first floor
              fromTileFlag = firstFloor.elementAt(fromTile) is ClickableRummyTile;
            }
            else if(15<fromTile){ // Second floor.
              fromTileFlag = secondFloor.elementAt(fromTile-15) is ClickableRummyTile;
            }

            // toTile checker
            bool toTileFlag = false;
            if( -1<toTile && toTile<15 ){ // If first floor
              toTileFlag = firstFloor.elementAt(toTile) is EmptyRummyTile;
            }
            else if(15<toTile){ // Second floor.
              toTileFlag = secondFloor.elementAt(toTile-15) is EmptyRummyTile;
            }

            //print("Fromtileflag: $fromTileFlag ToTileFlag: $toTileFlag");
            if(fromTileFlag && toTileFlag){
              //print("New Takoz: $newTakoz");
              String tempReq = createMoveRequestMessage(newTakoz);
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
      body: SafeArea(
        child: Stack(children: [
          // players -start
          Positioned(
            top: size.height * 0.275,
            left: size.width * 0.02,
            child: PlayerFrame(
              frameHeight: rummyTileHeight * 1.5,
              frameWidth: rummyTileWidth * 1.75,
              playerIcon: const Icon(Icons.person),
              playerName: "Mehmet",
            ),
          ),
          Positioned(
            top: size.height * 0.275,
            right: size.width * 0.02,
            child: PlayerFrame(
              frameHeight: rummyTileHeight * 1.5,
              frameWidth: rummyTileWidth * 1.75,
              playerIcon: const Icon(Icons.person),
              playerName: "Selin",
            ),
          ),
          Positioned(
            top: size.height * 0.02,
            left: size.width * 0.5 - (rummyTileWidth * 1.75) * 0.5,
            child: PlayerFrame(
              frameHeight: rummyTileHeight * 1.5,
              frameWidth: rummyTileWidth * 1.75,
              playerIcon: const Icon(Icons.person),
              playerName: "Emre",
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
                child: const Image(
                  image: AssetImage('assets/images/takoz.png'),
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
    );
  }
}
