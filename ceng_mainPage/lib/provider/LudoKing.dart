import 'package:flutter/material.dart';
import '../util/cell.dart';
import '../util/player.dart';
//import 'package:flutter/rendering.dart';


class LudoKing extends StatefulWidget {
  static String routeName = '/ludo';
  const LudoKing({super.key});

  @override
  State<LudoKing> createState() => _LudoKingState();
}

class _LudoKingState extends State<LudoKing> {

  static Color bgColor1=const Color.fromRGBO(43, 43, 43, 1);
  static List<Player> turnOrder=[Player.blu, Player.red, Player.grn, Player.ylw];

  LudoKingGameState state=LudoKingGameState.rollDice;
  Player whoseTurn=Player.blu;
  String rollText="";
  int? diceVal;
  bool madeMove=false;
  int? selPawnInd;

  List<List<Player?>>? curBoardPlayers;
  List<List<int?>>? curBoardPawnNums;
  List<List<int>>? curHiliLvls;


  // TODO: Cell class'ındaki listeleri buraya da yapcam, burdakinler değişcek, bu builder burdakini kullancak.
  Widget gridItemBuilder(context, index) {

    int i = index ~/ 15;
    int j = index % 15;

    //print("AAA i:$i, j:$j");

    /*return Cell(
      defClr: Cell.initialBoardDefClrs[0][0],
      player: curBoardPlayers![0][0],
      pawnNum: curBoardPawnNums![0][0],
      hiliLvl: curHiliLvls![0][0],
      onTapF: Cell.moveSetDict[0][0]==null ? null : cellOnTapF
    );*/

    return Cell(
      defClr: Cell.initialBoardDefClrs[i][j],
      player: Cell.initialBoardPlayers[i][j],
      pawnNum: Cell.initialBoardPawnNums[i][j],
      hiliLvl: 0, //curHiliLvls![i][j],
      onTapF: Cell.moveSetDict[0][0]==null ? null : cellOnTapF,
    );
  }

  Player nextTurnWho(Player curTurn, int diceVal, bool madeMove) {
    return (diceVal==6 && madeMove) ?  curTurn : Player.values[(curTurn.index+1) % Player.values.length];
  }

  void cellOnTapF() {

  }

  @override
  void initState() {
    super.initState();

    whoseTurn=Player.blu;
    rollText="Roll the dice!";
    madeMove=false;
    state=LudoKingGameState.rollDice;

    curBoardPlayers=List<List<Player?>>.empty(growable: true);
    curBoardPawnNums=List<List<int?>>.empty(growable: true);
    curHiliLvls=List<List<int>>.empty(growable: true);

    int i=0, j=0;

    for(i=0; i<15; ++i){

      //curBoardPlayers!.add(List<Player?>.empty(growable: true));
      //curBoardPawnNums!.add(List<int?>.empty(growable: true));
      //curHiliLvls!.add(List<int>.empty(growable: true));

      for(j=0; j<15; ++j){
        //curBoardPlayers![i].add(Cell.initialBoardPlayers[i][j]);
        //curBoardPawnNums![i].add(Cell.initialBoardPawnNums[i][j]);
        //curHiliLvls![i].add(0);
      }
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            textDirection: TextDirection.ltr,
            children: [
              // Top space
              Expanded(
                flex: 1,
                child: Container(color: bgColor1)
              ),
              // Turn-Timer-Quit row.
              Expanded(
                flex: 2,
                child: Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    // Turn
                    Expanded(
                      child: Container(
                        color: bgColor1,
                        child: Center(
                          child: RichText(
                            textDirection: TextDirection.ltr,
                            text: TextSpan(
                              text: "It's ",
                              style: TextStyle(color: Colors.white, backgroundColor: bgColor1), //DefaultTextStyle.of(context).style,
                              children: <TextSpan>[
                                TextSpan(
                                  text: textColorDict[whoseTurn],
                                  style: TextStyle(fontWeight: FontWeight.bold, color: colorDict[whoseTurn])
                                ),
                                const TextSpan(text: "'s turn!")
                              ]
                            )
                          ),
                        ),
                      )
                    ),
                    // Timer
                    Expanded(
                      child: Container(
                        color: bgColor1,
                        child: const Center(
                          child: Text("30s", textDirection: TextDirection.ltr, textAlign: TextAlign.center, style: TextStyle(color: Colors.white),)
                        ),
                      )
                    ),
                    // Quit
                    Expanded(
                      child: Container(
                        color: bgColor1,
                        child: Center(
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: ElevatedButton(
                              child: Text("Quit", textAlign: TextAlign.center),
                              onPressed: ()  => Navigator.pop(context),
                              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                            ),
                          ),
                        ),
                      )
                    )
                  ],
                )
              ),
              // Space between Turn-Timer-Quit row and board
              Expanded(
                flex: 1,
                child: Container(color: bgColor1)
              ),
              // board
              Expanded(
                flex: 27/*24*/,
                child: Container(
                  color: bgColor1 /* TODO Colors.blue */,
                  child: Center(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 15),
                        padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                        itemCount: 225 /* 15*15 */,
                        itemBuilder: gridItemBuilder
                      ),
                    ),
                  ),
                )
              ),
              // Space between board and manager effect
              Expanded(
                flex: 1,
                child: Container(color: bgColor1)
              ),
              // Manager effect
              Expanded(
                  flex: 2,
                  child: Container(
                    color: bgColor1,
                    padding: EdgeInsets.only(left: 20),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("You can only roll: 1, 2, 4, 5, 6!", textDirection: TextDirection.ltr, style: TextStyle(color: Colors.white),)
                    )
                  )
              ),
              // Dice roll area
              Expanded(
                flex: 5,
                child: Container(
                  color: bgColor1 /* TODO Colors.orange */,
                  child: Center(child: Text(rollText, textDirection: TextDirection.ltr, style: TextStyle(fontSize: 20, color: Colors.white)))
                )
              ),
              // Space between dice roll area and roll-endTurn
              Expanded(
                flex: 1,
                child: Container(color: bgColor1)
              ),
              // roll-endTurn
              Expanded(
                flex: 3,
                child: Row(
                  textDirection: TextDirection.ltr,
                  children: [
                    // roll
                    Expanded(
                      child: Container(
                        color: bgColor1,
                        child: Center(
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: ElevatedButton(
                              child: Text("Roll"),
                              onPressed: () {}
                            ),
                          ),
                        ),
                      )
                    ),
                    // endTurn
                    Expanded(
                      child: Container(
                        color: bgColor1,
                        child: Center(
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: ElevatedButton(
                              child: Text("End Turn"),
                              onPressed: () {}
                            ),
                          )
                        ),
                      )
                    )
                  ],
                )
              ),
              // Bottom space
              Expanded(
                  flex: 1,
                  child: Container(color: bgColor1)
              )
            ],
          ),
        ),
      ),
    );
  }
}
