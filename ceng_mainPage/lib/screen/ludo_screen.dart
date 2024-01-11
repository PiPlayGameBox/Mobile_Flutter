import 'package:ceng_mainpage/screen/lobby_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:ceng_mainpage/util/cell.dart';
import 'package:ceng_mainpage/util/player.dart';
import 'package:ceng_mainpage/screens/login_screen.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io';


const RED_PAWN_BASE_0_INDEX = 32;
const RED_PAWN_BASE_1_INDEX = 33;
const RED_PAWN_BASE_2_INDEX = 47;
const RED_PAWN_BASE_3_INDEX = 48;
const GREEN_PAWN_BASE_0_INDEX = 41;
const GREEN_PAWN_BASE_1_INDEX = 42;
const GREEN_PAWN_BASE_2_INDEX = 56;
const GREEN_PAWN_BASE_3_INDEX = 57;
const BLUE_PAWN_BASE_0_INDEX = 167;
const BLUE_PAWN_BASE_1_INDEX = 168;
const BLUE_PAWN_BASE_2_INDEX = 182;
const BLUE_PAWN_BASE_3_INDEX = 183;
const YELLOW_PAWN_BASE_0_INDEX = 176;
const YELLOW_PAWN_BASE_1_INDEX = 177;
const YELLOW_PAWN_BASE_2_INDEX = 191;
const YELLOW_PAWN_BASE_3_INDEX = 192;


class LudoScreen extends StatefulWidget {
  const LudoScreen({Key? key, required this.players}) : super(key: key);

  final List<String> players;

  @override
  State<LudoScreen> createState() => _LudoScreenState();
}

class _LudoScreenState extends State<LudoScreen> {

  // Example playerInfo: {"r":"doruk", "g":"ahmet", "Y":"tuba", "b":"samet"}
  Map<String, String> playerInfo={}; // Will be initialized in initState.

  int touchedPawnIndex = -1;
  double transformValue = 0;

  // first 4 for RED, second 4 for GREEN, third 4 for YELLOW, last 4 for BLUE
  // [R0, R1, R2, R3, G0, G1, G2, G3, Y0, Y1, Y2, Y3, B0, B1, B2 ,B3]
  List<int> pawnPositions = [
    RED_PAWN_BASE_0_INDEX,
    RED_PAWN_BASE_1_INDEX,
    RED_PAWN_BASE_2_INDEX,
    RED_PAWN_BASE_3_INDEX,
    GREEN_PAWN_BASE_0_INDEX,
    GREEN_PAWN_BASE_1_INDEX,
    GREEN_PAWN_BASE_2_INDEX,
    GREEN_PAWN_BASE_3_INDEX,
    YELLOW_PAWN_BASE_0_INDEX,
    YELLOW_PAWN_BASE_1_INDEX,
    YELLOW_PAWN_BASE_2_INDEX,
    YELLOW_PAWN_BASE_3_INDEX,
    BLUE_PAWN_BASE_0_INDEX,
    BLUE_PAWN_BASE_1_INDEX,
    BLUE_PAWN_BASE_2_INDEX,
    BLUE_PAWN_BASE_3_INDEX
  ];
  List<int> highlightedTilePositions = [];

  // Following variables are ADDED.
  late Timer timer;
  int dice = 0;
  String lastDice = "0";
  String myName = "";
  String myColor = "";
  String strWinner = "";
  String strQuitter = "";
  String strTurnName = "";
  String strTurnColor= "";
  late Random rng;
  bool rollBtnEnabled = false;

  static final Map<int, int> indexMap = {
    // Main path
    0: 90, 1: 91, 2: 92, 3: 93, 4: 94, 5: 95,
    6: 81, 7: 66, 8: 51, 9: 36, 10: 21, 11: 6,
    12: 7,
    13: 8, 14: 23, 15: 38, 16: 53, 17: 68, 18: 83,
    19: 99, 20: 100, 21: 101, 22: 102, 23: 103, 24: 104,
    25: 119,
    26: 134, 27: 133, 28: 132, 29: 131, 30: 130, 31: 129,
    32: 143, 33: 158, 34: 173, 35: 188, 36: 203, 37: 218,
    38: 217,
    39: 216, 40: 201, 41: 186, 42: 171, 43: 156, 44: 141,
    45: 125, 46: 124, 47: 123, 48: 122, 49: 121, 50: 120,
    51: 105,

    // Capture Areas (RGYB)
    52: 32, 53: 33, 54: 47, 55: 48,
    56: 41, 57: 42, 58: 56, 59: 57,
    60: 176, 61: 177, 62: 191, 63: 192,
    64: 167, 65: 168, 66: 182, 67: 183,

    // Safe Areas (RGYB)
    68: 106, 69: 107, 70: 108, 71: 109, 72: 110,
    73: 22, 74: 37, 75: 52, 76: 67, 77: 82,
    78: 118, 79: 117, 80: 116, 81: 115, 82: 114,
    83: 202, 84: 187, 85: 172, 86: 157, 87: 142
  };

  static final Map<String, List<int>> sublistMap = {
    'r': [0, 4],
    'g': [4, 8],
    'y': [8, 12],
    'b': [12, 16]
  };

  static final Map<String, Player> playerMap = {
    'r': Player.red,
    'g': Player.grn,
    'y': Player.ylw,
    'b': Player.blu
  };

  static final List<int> initialPawnPositions = [
    RED_PAWN_BASE_0_INDEX,
    RED_PAWN_BASE_1_INDEX,
    RED_PAWN_BASE_2_INDEX,
    RED_PAWN_BASE_3_INDEX,
    GREEN_PAWN_BASE_0_INDEX,
    GREEN_PAWN_BASE_1_INDEX,
    GREEN_PAWN_BASE_2_INDEX,
    GREEN_PAWN_BASE_3_INDEX,
    YELLOW_PAWN_BASE_0_INDEX,
    YELLOW_PAWN_BASE_1_INDEX,
    YELLOW_PAWN_BASE_2_INDEX,
    YELLOW_PAWN_BASE_3_INDEX,
    BLUE_PAWN_BASE_0_INDEX,
    BLUE_PAWN_BASE_1_INDEX,
    BLUE_PAWN_BASE_2_INDEX,
    BLUE_PAWN_BASE_3_INDEX
  ];

  static final Map<String, List<int>> winPositions = {
    'r':[107, 108, 109, 110],
    'g':[37, 52, 67, 82],
    'y':[117, 116, 115, 114],
    'b':[187, 172, 157, 142]
  };

  static final Map<String, int> pathStartLogIndexes ={
    'r': 0,
    'g': 13,
    'y': 26,
    'b': 39
  };

  // For dice animations.
  int counterTimer = 0;
  int currentImageIndex = 0;
  double diceTransformValue = 0;
  static const int counterTimerMax=12;
  static const int diceDurationMillis=120;

  List<String> diceImages = [
    "assets/images/dice_0.png",
    "assets/images/dice_1.png",
    "assets/images/dice_2.png",
    "assets/images/dice_3.png",
    "assets/images/dice_4.png",
    "assets/images/dice_5.png",
    "assets/images/dice_6.png"
  ];

  void showWinDialog(BuildContext context) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('GAME OVER'),
          content: strWinner == myName ? Text('YOU WON! Congrats.') : Text('The winner is: $strWinner'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LobbyScreen()));
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  void showQuitDialog(BuildContext context) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('PLAYER LEFT'),
          content: strQuitter == myName ? Text('You quit the game.') : Text('$strQuitter quit the game.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LobbyScreen()));
              },
              child: Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  // Sends request of type reqType to server, reads the returned answer.
  // May do additional things depending on the reqType.
  void sendRequest({required String reqType, required String request}) async {
    try{
      Socket sock=await Socket.connect("10.42.0.1", 8080); //  127.0.0.1
      sock.write(request);

      sock.listen(
              (List<int> data) {
            String receivedData=String.fromCharCodes(data);
            sock.close();

            //print("Received data is: $receivedData");

            switch(reqType){
              case "GETLUDO":
                handleGetLudo(receivedData);
                break;
            }
          },
          onDone: () {
            //print("Socket is closed.");
          },
          onError: (e) {
            sock.close();
            //print("An error occurred while sending the following request:\n$request");
            //print('Error: $e');
          },
          cancelOnError: true
      );
    }
    catch(error){
      //print("An error occurred while opening/writing socket.");
    }
  }

  void handleGetLudo(String receivedData){
    List<String> tokens = receivedData.split("/");

    List<int> newPawnPositions = tokens[1].split("|").map((strLogInd) {
      return convertLogicalIndex2Physical(int.parse(strLogInd));
    }).toList();

    List<String> lastDice_curTurn_winner_quitter_tokens = tokens[2].split("|");

    setState(() {
      lastDice = lastDice_curTurn_winner_quitter_tokens[0];
      pawnPositions = newPawnPositions;
      strWinner = lastDice_curTurn_winner_quitter_tokens[2];
      strQuitter = lastDice_curTurn_winner_quitter_tokens[3];

      if (strWinner=="empty" && strQuitter=="empty") {
        strTurnName = lastDice_curTurn_winner_quitter_tokens[1];

        for(var entry in playerInfo.entries){
          if(strTurnName==entry.value){
            switch(entry.key){
              case 'r':
              case 'R':
                strTurnColor="Red"; break;
              case 'g':
              case 'G':
                strTurnColor="Green"; break;
              case 'y':
              case 'Y':
                strTurnColor="Yellow"; break;
              case 'b':
              case 'B':
                strTurnColor="Blue"; break;
            }
            break;
          }
        }
      }
      else { // There is a winner or quitter
        // Make "whose turn" variables to no one's turn. (An invalid value.)
        strTurnName="";
        strTurnColor="No one";

        // TODO: IMPLEMENT

        if(strWinner!="empty"){
          showWinDialog(context);
        }
        else if(strQuitter!="empty"){
          if(strQuitter!=myName){
            showQuitDialog(context);
          }
        }
      }

      if (myName == strTurnName) {
        rollBtnEnabled = true;
      } else {
        rollBtnEnabled = false;
      }
    });

    if(myName!=strTurnName && strWinner=="empty" && strQuitter=="empty"){
      Future.delayed(const Duration(milliseconds: 500), () {
        sendRequest(reqType: "GETLUDO", request: "GETLUDO|${loginGlobals.token}");
      });
    }
  }

  /*bool didIwin(){
    bool win=true;
    for(int myPawnPos in pawnPositions.sublist(sublistMap[myColor]![0], sublistMap[myColor]![1])){
      if(!winPositions[myColor]!.contains(myPawnPos)){
        win=false;
        break;
      }
    }
    return win;
  }*/

  int calcProgressOfColor(String clr){
    int progress=0;
    int logIndex;

    for(int pawnPos in pawnPositions.sublist(sublistMap[clr]![0], sublistMap[clr]![1])){
      logIndex=convertPhysicalIndex2Logical(pawnPos);

      // If in path
      if(logIndex>=0 && logIndex<=51){
        progress += 6+((logIndex-pathStartLogIndexes[clr]!)%52);
      }
      // If in safe area (not in base)
      else if(!initialPawnPositions.sublist(sublistMap[clr]![0], sublistMap[clr]![1]).contains(pawnPos)){
        progress += 6+51+(5-(convertPhysicalIndex2Logical(winPositions[clr]![3])-logIndex));
      }
    }

    return progress;
  }

  // Returns a map containing the progress of the colors r, g, y, b.
  // Progress ratio for a player is calculated by dividing the returned integer by 242.
  Map<String, int> calcProgress(){
    return {
      'r': calcProgressOfColor('r'),
      'g': calcProgressOfColor('g'),
      'y': calcProgressOfColor('y'),
      'b': calcProgressOfColor('b')
    };
  }

  bool checkRestriction(Player? targetClr) {
    if (targetClr != null && playerMap[myColor] != targetClr) {
      return false;
    }
    return true;
  }

  bool checkCollision(targetIndex) {
    if (pawnPositions.sublist(sublistMap[myColor]![0], sublistMap[myColor]![1]).contains(targetIndex)) {
      return false;
    }
    return true;
  }

  // Index'i verilen pawn hangi kareye gidebilir? (Gidemiyosa -1 döndürür.)
  int getMove(int index) {
    int i = index ~/ 15;
    int j = index % 15;

    Map<int, List<List<dynamic>>>? moveSet = Cell.moveSetDict[i][j];

    if (moveSet != null) {
      if (moveSet.containsKey(dice)) {
        List<List<dynamic>> moveList = moveSet[dice]!;

        int targetIndex;
        Player? targetClr;

        if (moveList.length == 2) {
          targetIndex = moveList[1][0] * 15 + moveList[1][1];
          targetClr = moveList[1][2];

          if (checkRestriction(targetClr)) {
            if(checkCollision(targetIndex)){
              return targetIndex;
            }
            else{
              return -1;
            }
          }
        }

        // Check the first move.
        targetIndex = moveList[0][0] * 15 + moveList[0][1];
        targetClr = moveList[0][2];

        if (checkCollision(targetIndex) && checkRestriction(targetClr)) {
          return targetIndex;
        }
      }
    }

    return -1;
  }

  // Possibe return values: {}, {0: 99}, {0: 99, 3: 98}. // {pawnNumber:targetIndex}
  Map<int, int> getMoves() {
    List<int> myPawnPos = pawnPositions.sublist(sublistMap[myColor]![0], sublistMap[myColor]![1]);
    Map<int, int> moves = {};
    int move;

    for (int i = 0; i < 4; ++i) {
      move = getMove(myPawnPos[i]);
      if (move != -1) {
        moves[i] = move;
      }
    }

    return moves;
  }

  int convertLogicalIndex2Physical(int logicalIndex) {
    return indexMap.containsKey(logicalIndex) ? indexMap[logicalIndex]! : -1;
  }

  int convertPhysicalIndex2Logical(int physicalIndex) {
    for (var entry in indexMap.entries) {
      if (entry.value == physicalIndex) {
        return entry.key;
      }
    }
    return -1;
  }

  rollOnTap() async {

    setState(() {
      rollBtnEnabled = false;
    });

    // Generate dice value with animation
    Timer.periodic(const Duration(milliseconds: diceDurationMillis), (timer) {
      counterTimer++;
      setState(() {
        currentImageIndex = 1 + rng.nextInt(6);
        diceTransformValue = rng.nextDouble() * 180;
      });
      if (counterTimer == counterTimerMax) {
        timer.cancel();
        setState(() {
          counterTimer = 0;
          diceTransformValue = 0;
          dice = currentImageIndex;
        });
      }
    });

    // Wait for dice animation to complete.
    await Future.delayed(const Duration(milliseconds: diceDurationMillis*(counterTimerMax+2)));

    sendRequest(reqType: "ROLLDICE", request: "ROLLDICE|${loginGlobals.token}|$dice");

    Map<int, int> moves = getMoves();

    if (moves.isEmpty) {
      // No move is made.
      sendRequest(reqType: "PASSTURN", request: "PASSTURN|${loginGlobals.token}");

      // Yapabileceği hamle olmayan oyuncu en azından attığı zarın kaç olduğunu
      // görebilsin sıra bir sonraki kişiye geçmeden diye biraz bekle.
      await Future.delayed(const Duration(milliseconds: 1000));

      sendRequest(reqType: "GETLUDO", request: "GETLUDO|${loginGlobals.token}");
    }
    else{
      setState(() {
        highlightedTilePositions.clear();
        for (int key in moves.keys) {
          highlightedTilePositions.add(pawnPositions[sublistMap[myColor]![0] + key]);
        }
      });
    }
  }

  gridOnTap(int index) async {
    if (strTurnName == myName && strWinner == "empty" && dice!=0) {
      if (touchedPawnIndex == -1) {
        if (highlightedTilePositions.contains(index)) {
          setState(() {
            touchedPawnIndex = index;
            highlightedTilePositions.clear();
            highlightedTilePositions.add(index);
            highlightedTilePositions.add(getMove(index));
          });
        }
      }
      else { // touched pawnIndex!=-1
        if (highlightedTilePositions.contains(touchedPawnIndex)) {
          if (touchedPawnIndex == index) {
            setState(() {
              touchedPawnIndex = -1;

              // Convert highlighted positions to previous state.
              highlightedTilePositions.clear();

              Map<int, int> moves = getMoves();
              for (int key in moves.keys) {
                highlightedTilePositions.add(pawnPositions[sublistMap[myColor]![0] + key]);
              }
            });
          }
          // touchedPawnIndex != index
          else {
            String meAgain = (dice == 6 ? 'T' : 'F');
            int movedPawnNum = pawnPositions.indexOf(touchedPawnIndex);
            int movedPawnLogInd = convertPhysicalIndex2Logical(index);
            String moveRequest = "MAKEMOVE|${loginGlobals.token}|$meAgain|$movedPawnNum|$movedPawnLogInd";

            // For capture case
            if(pawnPositions.contains(index)){
              int eatenPawnNum = pawnPositions.indexOf(index);
              int eatenPawnLogInd = convertPhysicalIndex2Logical(initialPawnPositions[eatenPawnNum]);
              moveRequest += "|$eatenPawnNum|$eatenPawnLogInd";
            }

            Map<String, int> p=calcProgress();
            moveRequest += "|${p['r']}|${p['g']}|${p['y']}|${p['b']}";

            // Send the performed move.
            sendRequest(reqType: "MAKEMOVE", request: moveRequest);

            setState(() {
              // For capture case
              if (pawnPositions.contains(index)) {
                int eatenPawnNum = pawnPositions.indexOf(index);
                pawnPositions[eatenPawnNum] = initialPawnPositions[eatenPawnNum];
              }

              // Make the main move
              pawnPositions[movedPawnNum] = index;

              dice = 0;
              touchedPawnIndex = -1;
              highlightedTilePositions.clear();
            });

            if(p[myColor]==242){
              sendRequest(reqType: "WIN", request: "WIN|${loginGlobals.token}|1");
            }

            // Get the new board.
            // MAKEMOVE and WON requests "MUST" arrive to server before the following GETLUDO.
            // Increase the duration if necessary.
            await Future.delayed(Duration(milliseconds: 600));
            sendRequest(reqType: "GETLUDO", request: "GETLUDO|${loginGlobals.token}");
          }
        }
      }
    }
  }

  quitOnTap(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LobbyScreen()));
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    if(widget.players[0]==loginGlobals.username){
      playerInfo['R']=widget.players[0];
    }
    else{
      playerInfo['r']=widget.players[0];
    }

    if(widget.players[1]==loginGlobals.username){
      playerInfo['G']=widget.players[1];
    }
    else{
      playerInfo['g']=widget.players[1];
    }

    if(widget.players[2]==loginGlobals.username){
      playerInfo['Y']=widget.players[2];
    }
    else{
      playerInfo['y']=widget.players[2];
    }

    if(widget.players[3]==loginGlobals.username){
      playerInfo['B']=widget.players[3];
    }
    else{
      playerInfo['b']=widget.players[3];
    }

    rng = Random();

    dice=0;
    lastDice="0";
    rollBtnEnabled=false;
    strTurnName="";
    strTurnColor="...";

    for(var entry in playerInfo.entries){
      switch(entry.key){
        case 'R':
          myName = playerInfo['R']!;
          myColor = "r";
          transformValue = 0;
          break;
        case 'G':
          myName = playerInfo['G']!;
          myColor = "g";
          transformValue = -pi / 2;
          break;
        case 'Y':
          myName = playerInfo['Y']!;
          myColor = "y";
          transformValue = -pi;
          break;
        case 'B':
          myName = playerInfo['B']!;
          myColor = "b";
          transformValue = pi / 2;
          break;
      }
    }

    sendRequest(reqType: "GETLUDO", request: "GETLUDO|${loginGlobals.token}");
  }

  @override
  void dispose() {
    // TODO: QUIT sent here.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    sendRequest(reqType: "QUIT", request: "QUIT|${loginGlobals.token}|1");

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double topPadding = MediaQuery.of(context).padding.top;
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    Size size = MediaQuery.of(context).size;
    double safeAreaHeight = size.height - topPadding - bottomPadding;
    double turnInfoHeight = safeAreaHeight * 0.1;
    double boardHeight = size.width;
    double diceAreaHeight = safeAreaHeight - turnInfoHeight - boardHeight;

    return Scaffold(
      backgroundColor: const Color(0xff90ae90),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                height: turnInfoHeight,
                width: size.width,
                //color: Colors.red,
                child: Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.05,
                    ),
                    Container(
                      width: size.width * 0.6,
                      child: Row(
                        children: [
                          Text(
                            "Turn: ",
                            style: TextStyle(fontSize: turnInfoHeight * 0.3),
                          ),
                          Text(
                            (myName==strTurnName) ? "Your" : strTurnColor,
                            style: TextStyle(
                                color: () {
                                  if (strTurnColor == "Red") {
                                    return Colors.red[900];
                                  } else if (strTurnColor == "Green") {
                                    return Colors.green[900];
                                  } else if (strTurnColor == "Yellow") {
                                    return Colors.yellow[900];
                                  } else if (strTurnColor == "Blue") {
                                    return Colors.blue[900];
                                  } else {
                                    return Colors.black;
                                  }
                                }(),
                                fontWeight: FontWeight.bold,
                                fontSize: turnInfoHeight * 0.35),
                          ),
                          SizedBox(
                            width: size.width * 0.04,
                          ),
                          Text(
                            "Dice: ",
                            style: TextStyle(fontSize: turnInfoHeight * 0.3),
                          ),
                          SizedBox(
                            width: size.width * 0.01,
                          ),
                          Image.asset(
                            diceImages[int.parse(lastDice)],
                            height: turnInfoHeight * 0.4,
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: quitOnTap,
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: FittedBox(
                          fit: BoxFit.fitHeight,
                          child: Text(
                            "Quit",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.05,
                    ),
                  ],
                ),
              ),
              Container(
                height: boardHeight,
                width: size.width,
                //color: Colors.blue,
                child: Transform.rotate(
                  angle: transformValue,
                  child: Stack(
                    children: [
                      SizedBox(
                        height: boardHeight,
                        width: size.width,
                        child: const Image(
                          image: AssetImage(
                              'assets/images/ludo_board_homeless.png'),
                        ),
                      ),
                      Container(
                        height: boardHeight,
                        width: size.width,
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 15 * 15,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 15),
                          itemBuilder: (context, index) {
                            if (pawnPositions.sublist(0, 4).contains(index)) {
                              return GestureDetector(
                                onTap: convertPhysicalIndex2Logical(index) != -1
                                    ? () {
                                  gridOnTap(index);
                                }
                                    : null,
                                child: Padding(
                                  padding: EdgeInsets.all(boardHeight * 0.008),
                                  child:
                                  highlightedTilePositions.contains(index)
                                      ? DottedBorder(
                                    borderType: BorderType.RRect,
                                    strokeWidth: 2,
                                    color: Colors.black,
                                    child: SizedBox(
                                      height: boardHeight * 0.06,
                                      width: boardHeight * 0.06,
                                      child: Transform.rotate(
                                        angle: -transformValue,
                                        child: const Image(
                                          image: AssetImage(
                                              'assets/images/red_pawn.png'),
                                        ),
                                      ),
                                    ),
                                  )
                                      : SizedBox(
                                    height: boardHeight * 0.06,
                                    width: boardHeight * 0.06,
                                    child: Transform.rotate(
                                      angle: -transformValue,
                                      child: const Image(
                                        image: AssetImage(
                                            'assets/images/red_pawn.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else if (pawnPositions
                                .sublist(4, 8)
                                .contains(index)) {
                              return GestureDetector(
                                onTap: convertPhysicalIndex2Logical(index) != -1
                                    ? () {
                                  gridOnTap(index);
                                }
                                    : null,
                                child: Padding(
                                  padding: EdgeInsets.all(boardHeight * 0.008),
                                  child:
                                  highlightedTilePositions.contains(index)
                                      ? DottedBorder(
                                    borderType: BorderType.RRect,
                                    strokeWidth: 2,
                                    color: Colors.black,
                                    child: SizedBox(
                                      height: boardHeight * 0.06,
                                      width: boardHeight * 0.06,
                                      child: Transform.rotate(
                                        angle: -transformValue,
                                        child: const Image(
                                          image: AssetImage(
                                              'assets/images/green_pawn.png'),
                                        ),
                                      ),
                                    ),
                                  )
                                      : SizedBox(
                                    height: boardHeight * 0.06,
                                    width: boardHeight * 0.06,
                                    child: Transform.rotate(
                                      angle: -transformValue,
                                      child: const Image(
                                        image: AssetImage(
                                            'assets/images/green_pawn.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else if (pawnPositions.sublist(8, 12).contains(index)) {
                              return GestureDetector(
                                onTap: convertPhysicalIndex2Logical(index) != -1
                                    ? () {
                                  gridOnTap(index);
                                }
                                    : null,
                                child: Padding(
                                  padding: EdgeInsets.all(boardHeight * 0.008),
                                  child:
                                  highlightedTilePositions.contains(index)
                                      ? DottedBorder(
                                    borderType: BorderType.RRect,
                                    strokeWidth: 2,
                                    color: Colors.black,
                                    child: SizedBox(
                                      height: boardHeight * 0.06,
                                      width: boardHeight * 0.06,
                                      child: Transform.rotate(
                                        angle: -transformValue,
                                        child: const Image(
                                          image: AssetImage(
                                              'assets/images/yellow_pawn.png'),
                                        ),
                                      ),
                                    ),
                                  )
                                      : SizedBox(
                                    height: boardHeight * 0.06,
                                    width: boardHeight * 0.06,
                                    child: Transform.rotate(
                                      angle: -transformValue,
                                      child: const Image(
                                        image: AssetImage(
                                            'assets/images/yellow_pawn.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else if (pawnPositions.sublist(12, 16).contains(index)) {
                              return GestureDetector(
                                onTap: convertPhysicalIndex2Logical(index) != -1
                                    ? () {
                                  gridOnTap(index);
                                }
                                    : null,
                                child: Padding(
                                  padding: EdgeInsets.all(boardHeight * 0.008),
                                  child:
                                  highlightedTilePositions.contains(index)
                                      ? DottedBorder(
                                    borderType: BorderType.RRect,
                                    strokeWidth: 2,
                                    color: Colors.black,
                                    child: SizedBox(
                                      height: boardHeight * 0.06,
                                      width: boardHeight * 0.06,
                                      child: Transform.rotate(
                                        angle: -transformValue,
                                        child: const Image(
                                          image: AssetImage(
                                              'assets/images/blue_pawn.png'),
                                        ),
                                      ),
                                    ),
                                  )
                                      : SizedBox(
                                    height: boardHeight * 0.06,
                                    width: boardHeight * 0.06,
                                    child: Transform.rotate(
                                      angle: -transformValue,
                                      child: const Image(
                                        image: AssetImage(
                                            'assets/images/blue_pawn.png'),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }
                            if (highlightedTilePositions.contains(index)) {
                              return GestureDetector(
                                onTap: convertPhysicalIndex2Logical(index) != -1
                                    ? () {
                                  gridOnTap(index);
                                }
                                    : null,
                                child: Padding(
                                  padding: EdgeInsets.all(boardHeight * 0.008),
                                  child: DottedBorder(
                                    borderType: BorderType.RRect,
                                    strokeWidth: 2,
                                    color: Colors.black,
                                    child: SizedBox(
                                      height: boardHeight * 0.06,
                                      width: boardHeight * 0.06,
                                      //color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: diceAreaHeight,
                width: size.width,
                child: Column(
                  children: [
                    SizedBox(height: diceAreaHeight * 0.12,),
                    SizedBox(
                      height: diceAreaHeight * 0.5,
                      width: size.width,
                      child: Transform.rotate(
                        angle: diceTransformValue,
                        child: Image.asset(
                          diceImages[currentImageIndex],
                          height: diceAreaHeight * 0.5,
                        ),
                      ),
                    ),
                    SizedBox(height: diceAreaHeight * 0.06),
                    Opacity(
                      opacity: rollBtnEnabled ? 1.0 : 0.9,
                      child: ElevatedButton(
                        onPressed: rollBtnEnabled ? rollOnTap : null,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            "Roll",
                            style: TextStyle(fontSize: diceAreaHeight * 0.12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
