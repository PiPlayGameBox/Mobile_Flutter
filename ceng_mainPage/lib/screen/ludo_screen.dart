import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'package:ceng_mainpage/util/cell.dart';
import 'package:ceng_mainpage/util/player.dart';


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
  const LudoScreen({Key? key, required this.token, required this.playerInfo}) : super(key: key);

  final String token; // Will be initialized in constructor

  // Example playerInfo: {"r":"doruk", "g":"ahmet", "Y":"tuba", "b":"samet"}
  // Order of colors should be as in example. Uppercase color name is this player.
  final Map<String, String> playerInfo; // Will be initialized in constructor.

  @override
  State<LudoScreen> createState() => _LudoScreenState();
}

class _LudoScreenState extends State<LudoScreen> {
  int touchedPawnIndex = -1;
  double transformValue = 0;

  // total of 16 indexes
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
  late Socket socket;
  int dice = 0;
  String lastDice = "0";
  String myName = "";
  String myColor = "";
  String strWinner = "";
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
    32: 143, 33: 158, 34: 173, 35: 188, 36: 195, 37: 218,
    38: 217,
    39: 216, 40: 195, 41: 186, 42: 171, 43: 156, 44: 141,
    45: 125, 46: 124, 47: 123, 48: 122, 49: 121, 50: 120,
    51: 105,

    // Capture Areas (RGYB)
    52: 32, 53: 33, 54: 47, 55: 48,
    56: 41, 57: 42, 58: 56, 59: 57,
    60: 176, 61: 177, 62: 191, 63: 191,
    64: 167, 65: 168, 66: 182, 67: 183,

    // Safe Areas (RGYB)
    68: 106, 69: 107, 70: 108, 71: 109, 72: 110,
    73: 22, 74: 37, 75: 52, 76: 67, 77: 82,
    78: 118, 79: 117, 80: 116, 81: 115, 82: 114,
    83: 195, 84: 187, 85: 172, 86: 157, 87: 142
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

  // For dice animations.
  int counterTimer = 0;
  int currentImageIndex = 0;
  double diceTransformValue = 0;
  static const int counterTimerMax=12;
  static const int diceDurationMillis=80;

  //int diceValue = 0;
  List<String> diceImages = [
    "assets/images/dice_0.png",
    "assets/images/dice_1.png",
    "assets/images/dice_2.png",
    "assets/images/dice_3.png",
    "assets/images/dice_4.png",
    "assets/images/dice_5.png",
    "assets/images/dice_6.png"
  ];

  bool checkRestriction(Player? targetClr) {
    if (targetClr != null && playerMap[myColor] != targetClr) {
      return false;
    }
    return true;
  }

  bool checkCollision(targetIndex) {
    if (pawnPositions
        .sublist(sublistMap[myColor]![0], sublistMap[myColor]![1])
        .contains(targetIndex)) {
      return false;
    }
    return true;
  }

  // Index'i verilen pawn hangi kareye gidebilir? (Gidemiyosa -1 döndürür.)
  int getMove(int index) {
    int i = index ~/ 15;
    int j = index % 15;

    Map<int, List<List<dynamic>>>? moveSet = Cell.moveSetDict[i][j];
    print("MoveSet: $moveSet");

    if (moveSet != null) {
      if (moveSet.containsKey(dice)) {
        List<List<dynamic>> moveList = moveSet[dice]!;
        print("MoveList: $moveList");

        late int targetIndex;
        late Player targetClr;

        if (moveList.length == 2) {
          targetIndex = moveList[1][0] * 15 + moveList[1][1];
          targetClr = moveList[1][2];

          if (checkCollision(targetIndex) && checkRestriction(targetClr)) {
            return targetIndex;
          }
        }

        // Check the first move.
        targetIndex = moveList[0][0] * 15 + moveList[0][1];
        targetClr = moveList[0][2];
        print("targetIndex: $targetIndex, targetClr: $targetClr");

        if (checkCollision(targetIndex) && checkRestriction(targetClr)) {
          return targetIndex;
        }
        else{
          print('Check FAILED');
        }
      }
    }

    return -1;
  }

  // Possibe return values: {}, {0: 99}, {0: 99, 3: 98}. // {pawnNumber:targetIndex}
  Map<int, int> getMoves() {
    List<int> myPawnPos =
        pawnPositions.sublist(sublistMap[myColor]![0], sublistMap[myColor]![1]);
    Map<int, int> moves = {};
    int move;

    for (int i = 0; i < 4; ++i) {
      move = getMove(myPawnPos[i]);
      print("Move: $move");
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

    Timer.periodic(const Duration(milliseconds: diceDurationMillis), (timer) {
      counterTimer++;
      setState(() {
        currentImageIndex = 6 /*1 + rng.nextInt(6)*/;
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

    await Future.delayed(const Duration(milliseconds: diceDurationMillis*(counterTimerMax+2)));

    socket.write("ROLLDICE|${widget.token}|$dice");

    Map<int, int> moves = getMoves();
    print("Moves: $moves");
    if (moves.isEmpty) {
      /*setState(() {
        dice = 0;
      });*/
      socket.write("MAKEMOVE|${widget.token}|0|-1|-1"); // No move is made.
      await Future.delayed(const Duration(milliseconds: 1000));
      socket.write("GETLUDO|${widget.token}");
    } else {
      setState(() {
        highlightedTilePositions.clear();
        for (int key in moves.keys) {
          highlightedTilePositions.add(pawnPositions[sublistMap[myColor]![0] + key]);

        }
      });
    }
  }

  gridOnTap(int index) async {
    if (strTurnName == myName && strWinner == "empty") {
      if (dice != 0) {
        if (touchedPawnIndex == -1) {
          if (highlightedTilePositions.contains(index)) {
            setState(() {
              touchedPawnIndex = index;
              highlightedTilePositions.clear();
              highlightedTilePositions.add(index);

              Map<int, int> moves = getMoves();
              moves.forEach((key, value) {
                highlightedTilePositions.add(value);
              });
            });
          }
        }

        // touched pawnIndex!=-1
        else {
          if (highlightedTilePositions.contains(touchedPawnIndex)) {
            if (touchedPawnIndex == index) {
              setState(() {
                touchedPawnIndex = -1;

                // Convert highlighted positions to previous state.
                highlightedTilePositions.clear();
                highlightedTilePositions.add(index);

                Map<int, int> moves = getMoves();
                moves.forEach((key, value) {
                  highlightedTilePositions.add(value);
                });
              });
            }

            // touchedPawnIndex != index
            else {
              setState(() {
                int meAgain = (dice == 6 ? 1 : 0);
                int movedPawnNum = pawnPositions.indexOf(touchedPawnIndex);
                int movedPawnLogInd = convertPhysicalIndex2Logical(index);
                String moveRequest = "MAKEMOVE|${widget.token}|$meAgain|$movedPawnNum|$movedPawnLogInd";

                // Capture case.
                if (pawnPositions.contains(index)) {
                  int eatenPawnNum = pawnPositions.indexOf(index);
                  int eatenPawnLogInd = convertPhysicalIndex2Logical(initialPawnPositions[eatenPawnNum]);
                  moveRequest += "|$eatenPawnNum|$eatenPawnLogInd";

                  // First make capture
                  pawnPositions[eatenPawnNum] = initialPawnPositions[eatenPawnNum];
                }

                // Make the main move
                pawnPositions[movedPawnNum] = index;

                dice = 0;
                touchedPawnIndex = -1;
                highlightedTilePositions.clear();

                // Send the performed move via MAKEMOVE request.
                socket.write(moveRequest);
                socket.write("GETLUDO|${widget.token}");
              });
            }
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // From this point on is ADDED.

    rng = Random();

    // Always red player starts first.
    strWinner = "empty";
    for(var entry in widget.playerInfo.entries){
      if(entry.key=='r' || entry.key=='R'){
        strTurnName=entry.value;
        break;
      }
    }
    strTurnColor = "Red";

    for(var entry in widget.playerInfo.entries){
      switch(entry.key){
        case 'R':
          myName = widget.playerInfo['R']!;
          myColor = "r";
          transformValue = 0;
          break;
        case 'G':
          myName = widget.playerInfo['G']!;
          myColor = "g";
          transformValue = -pi / 2;
          break;
        case 'Y':
          myName = widget.playerInfo['Y']!;
          myColor = "y";
          transformValue = -pi;
          break;
        case 'B':
          myName = widget.playerInfo['B']!;
          myColor = "b";
          transformValue = pi / 2;
          break;
      }
    }

    if (myName == strTurnName) {
      rollBtnEnabled = true;
    } else {
      rollBtnEnabled = false;
    }

    Socket.connect("127.0.0.1", 8080).then((s) {
      socket = s;
      socket.listen(
        (List<int> data) {
          String receivedData = String.fromCharCodes(data);

          // DELETE later.
          print("Data is: [$receivedData]\n");

          if (receivedData.split("|").length > 2) {
            List<String> tokens = receivedData.split("/");

            List<int> newPawnPositions = tokens[1].split("|").map((strLogInd) {
              return convertLogicalIndex2Physical(int.parse(strLogInd));
            }).toList();

            List<String> lastDice_curTurn_winner_tokens = tokens[2].split("|");

            setState(() {
              lastDice = lastDice_curTurn_winner_tokens[0];
              pawnPositions = newPawnPositions;
              strWinner = lastDice_curTurn_winner_tokens[2];

              rollBtnEnabled = false;

              if (strWinner == "empty") {
                strTurnName = lastDice_curTurn_winner_tokens[1];

                for(var entry in widget.playerInfo.entries){
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

                if (strTurnName == myName) {
                  rollBtnEnabled = true;
                }
              }

              // There is a winner
              else {
                // Make "whose turn" variable to no one's turn. (An invalid value.)
                strTurnName="";
                strTurnColor="No one";

                // TODO: Buraya eklenmeyecek ama, aşağıdaki build metod'u winner'ı kontrol edip
                // TODO: "empty" ise: Şu anki yaptığını yapması lazım.
                // TODO: "empty" değil ise: Şu anki yaptığına ek, "$strWinner has won! [Back to main menu]"
                // TODO: diye bir popup çıkarması lazım ya da diğer şeyleri küçültüp buna yer açarak
                // TODO: altına falan da koyabilir bunu.
              }
            });
          }
        },
        onError: (error) {
          print("Soket okunamadı: $error");
        },
        cancelOnError: false,
      );
    });

    /*timer=Timer.periodic(Duration(milliseconds: 1000), (timer) {
      socket.write("GETLUDO|$token"); // TODO
    });*/
  }

  @override
  void dispose() {
    // TODO: implement dispose
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
                      onPressed: () { /* TODO */ },
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
                            } else if (pawnPositions
                                .sublist(8, 12)
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
                            } else if (pawnPositions
                                .sublist(12, 16)
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
