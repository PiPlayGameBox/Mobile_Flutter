import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:math';

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

  const LudoScreen({super.key});

  /*const LudoScreen({
    Key? key,
    required this.token,
  }) : super(key: key);

  final String token;*/ // widget.token ile ulaşılabilir.

  @override
  State<LudoScreen> createState() => _LudoScreenState();
}

class _LudoScreenState extends State<LudoScreen> {
  int touchedPawnIndex = 0;
  int turnInfo = 0;
  double transformValue = 0;

  // total of 16 indexes
  // first 4 for RED
  // second 4 for GREEN
  // third 4 for YELLOW
  // last 4 for BLUE
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
    99,
    BLUE_PAWN_BASE_2_INDEX,
    BLUE_PAWN_BASE_3_INDEX
  ];
  List<int> highlightedTilePositions = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
      backgroundColor: const Color(0xffa8b6a8),
      body: SafeArea(
        child: Column(
          children: [
            Container(
                height: turnInfoHeight, width: size.width, color: Colors.red
                // child: FittedBox(
                //   fit: BoxFit.contain,
                //   child: RichText(
                //     text: const TextSpan(
                //         style: TextStyle(
                //           color: Colors.black,
                //           //fontWeight: FontWeight.bold,
                //         ),
                //         children: <TextSpan>[
                //           TextSpan(text: "It's "),
                //           TextSpan(
                //               text: "Blue",
                //               style: TextStyle(
                //                 color: Colors.blue,
                //                 //fontWeight: FontWeight.bold,
                //               )),
                //           TextSpan(text: "'s turn"),
                //         ]),
                //   ),
                // ),
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
                        image: AssetImage('assets/images/ludo_board_homeless.png'),
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
                              onTap: () {
                                setState(() {
                                  print("Red Pawn");
                                  highlightedTilePositions.clear();
                                  highlightedTilePositions.add(99);
                                  highlightedTilePositions.add(90);
                                  highlightedTilePositions.add(92);
                                  highlightedTilePositions.add(94);
                                  touchedPawnIndex = index;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(boardHeight * 0.008),
                                child: highlightedTilePositions.contains(index)
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
                              onTap: () {
                                setState(() {
                                  print("Green Pawn");
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(boardHeight * 0.008),
                                child: highlightedTilePositions.contains(index)
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
                              onTap: () {
                                setState(() {
                                  print("Yellow Pawn");
                                  highlightedTilePositions.clear();
                                  pawnPositions[pawnPositions
                                      .indexOf(touchedPawnIndex)] = index;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(boardHeight * 0.008),
                                child: highlightedTilePositions.contains(index)
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
                              onTap: () {
                                setState(() {
                                  print("blue Pawn");
                                  highlightedTilePositions.clear();
                                  pawnPositions[pawnPositions
                                      .indexOf(touchedPawnIndex)] = index;
                                  pawnPositions[13] = BLUE_PAWN_BASE_1_INDEX;
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.all(boardHeight * 0.008),
                                child: highlightedTilePositions.contains(index)
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
                              onTap: () {
                                setState(() {
                                  highlightedTilePositions.clear();
                                  pawnPositions[pawnPositions
                                      .indexOf(touchedPawnIndex)] = index;
                                });
                              },
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
                          }
                          else {
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
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
