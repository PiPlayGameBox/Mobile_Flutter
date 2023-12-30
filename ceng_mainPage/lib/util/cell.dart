import 'package:flutter/material.dart';
import 'player.dart';
//import 'package:flutter/cupertino.dart';


// TODO: Immutable class? Belki stateless olduğundandır.
class Cell extends StatelessWidget{

  // Static fields

  static final Map pathDict = {
    Player.blu: "assets/images/blue_pawn.png",
    Player.red: "assets/images/red_pawn.png",
    Player.grn: "assets/images/green_pawn.png",
    Player.ylw: "assets/images/yellow_pawn.png",
  };

  // TODO: bu renkler gerçek board'a göre ayarlancak.
  static Color blu=Colors.blue;
  static Color red=Colors.red;
  static Color grn=Colors.green;
  static Color ylw=Colors.yellow;
  static Color wht=Colors.white;
  static Color cap=Colors.white24;

  static Color hili1clr=Colors.blue;
  static Color hili2clr=Colors.purple;

  static List<List<Color>> initialBoardDefClrs=[
    [red, red, red, red, red, red, wht, wht, grn, grn, grn, grn, grn, grn, grn],
    [red, wht, cap, wht, red, red, wht, grn, wht, grn, grn, wht, cap, wht, grn],
    [red, cap, cap, cap, red, red, wht, grn, wht, grn, grn, cap, cap, cap, grn],
    [red, wht, cap, wht, red, red, wht, grn, wht, grn, grn, wht, cap, wht, grn],
    [red, red, red, red, red, red, wht, grn, wht, grn, grn, grn, grn, grn, grn],
    [red, red, red, red, red, red, wht, grn, wht, grn, grn, grn, grn, grn, grn],
    [red, wht, wht, wht, wht, wht, cap, cap, cap, wht, wht, wht, wht, wht, wht],
    [wht, red, red, red, red, red, cap, cap, cap, ylw, ylw, ylw, ylw, ylw, wht],
    [wht, wht, wht, wht, wht, wht, cap, cap, cap, wht, wht, wht, wht, wht, ylw],
    [blu, blu, blu, blu, blu, blu, wht, blu, wht, ylw, ylw, ylw, ylw, ylw, ylw],
    [blu, blu, blu, blu, blu, blu, wht, blu, wht, ylw, ylw, ylw, ylw, ylw, ylw],
    [blu, wht, cap, wht, blu, blu, wht, blu, wht, ylw, ylw, wht, cap, wht, ylw],
    [blu, cap, cap, cap, blu, blu, wht, blu, wht, ylw, ylw, cap, cap, cap, ylw],
    [blu, wht, cap, wht, blu, blu, wht, blu, wht, ylw, ylw, wht, cap, wht, ylw],
    [blu, blu, blu, blu, blu, blu, blu, wht, wht, ylw, ylw, ylw, ylw, ylw, ylw]
  ];

  static List<List<Player?>> initialBoardPlayers=[
    [null, null,       null, null,       null, null, null, null, null, null, null, null,       null, null,       null],
    [null, Player.red, null, Player.red, null, null, null, null, null, null, null, Player.grn, null, Player.grn, null],
    [null, null,       null, null,       null, null, null, null, null, null, null, null,       null, null,       null],
    [null, Player.red, null, Player.red, null, null, null, null, null, null, null, Player.grn, null, Player.grn, null],
    [null, null,       null, null,       null, null, null, null, null, null, null, null,       null, null,       null],
    [null, null,       null, null,       null, null, null, null, null, null, null, null,       null, null,       null],
    [null, null,       null, null,       null, null, null, null, null, null, null, null,       null, null,       null],
    [null, null,       null, null,       null, null, null, null, null, null, null, null,       null, null,       null],
    [null, null,       null, null,       null, null, null, null, null, null, null, null,       null, null,       null],
    [null, null,       null, null,       null, null, null, null, null, null, null, null,       null, null,       null],
    [null, null,       null, null,       null, null, null, null, null, null, null, null,       null, null,       null],
    [null, Player.blu, null, Player.blu, null, null, null, null, null, null, null, Player.ylw, null, Player.ylw, null],
    [null, null,       null, null,       null, null, null, null, null, null, null, null,       null, null,       null],
    [null, Player.blu, null, Player.blu, null, null, null, null, null, null, null, Player.ylw, null, Player.ylw, null],
    [null, null,       null, null,       null, null, null, null, null, null, null, null,       null, null,       null]
  ];

  // For different players to have rotated visions, numbers should have rotation symmetry.
  static List<List<int?>> initialBoardPawnNums=[
    [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null],
    [null, 0,    null, 1,    null, null, null, null, null, null, null, 3,    null, 0,    null],
    [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null],
    [null, 3,    null, 2,    null, null, null, null, null, null, null, 2,    null, 1,    null],
    [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null],
    [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null],
    [null, 1,    null, 2,    null, null, null, null, null, null, null, 2,    null, 3,    null],
    [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null],
    [null, 0,    null, 3,    null, null, null, null, null, null, null, 1,    null, 0,    null],
    [null, null, null, null, null, null, null, null, null, null, null, null, null, null, null]
  ];

  // Each map represent a moveSet of a specific cell, like this: {1: [[(i'=)3, (j'=0), (restriction=)Player?], [opt]]}
  // If map is null for a cell, then it is a non-interactive cell. onTap function is only given for non-null entries.
  // This is why last safe cell's of each colors has empty entries instead of null.
  // Moves from capture area to starting cell's don't actually require restriction but given anyway.
  // The same is also valid for safe area to safe area moves.
  // Move maps has only the keys which has at least 1 possible move.
  static List<List<Map?>> moveSetDict=[

    // Row 0
    [
      null, null, null, null, null, null,
      // Col 6
      {
        1: [[0, 7, null]],
        2: [[0, 8, null], [1, 7, Player.grn]],
        3: [[1, 8, null], [2, 7, Player.grn]],
        4: [[2, 8, null], [3, 7, Player.grn]],
        5: [[3, 8, null], [4, 7, Player.grn]],
        6: [[4, 8, null], [5, 7, Player.grn]]
      },
      // Col 7
      {
        1: [[0, 8, null], [1, 7, Player.grn]],
        2: [[1, 8, null], [2, 7, Player.grn]],
        3: [[2, 8, null], [3, 7, Player.grn]],
        4: [[3, 8, null], [4, 7, Player.grn]],
        5: [[4, 8, null], [5, 7, Player.grn]],
        6: [[5, 8, null]]
      },
      // Col 8
      {
        1: [[1, 8, null]],
        2: [[2, 8, null]],
        3: [[3, 8, null]],
        4: [[4, 8, null]],
        5: [[5, 8, null]],
        6: [[6, 9, null]]
      },
      null, null, null, null, null, null
    ],

    // Row 1
    [
      null,
      {6: [[6, 0, Player.red]]}, // Col 1
      null,
      {6: [[6, 0, Player.red]]}, // Col 3
      null, null,
      // Col 6
      {
        1: [[0, 6, null]],
        2: [[0, 7, null]],
        3: [[0, 8, null], [1, 7, Player.grn]],
        4: [[1, 8, null], [2, 7, Player.grn]],
        5: [[2, 8, null], [3, 7, Player.grn]],
        6: [[3, 8, null], [4, 7, Player.grn]]
      },
      // Col 7
      {
        1: [[2, 7, Player.grn]],
        2: [[3, 7, Player.grn]],
        3: [[4, 7, Player.grn]],
        4: [[5, 7, Player.grn]]
      },
      // Col 8
      {
        1: [[2, 8, null]],
        2: [[3, 8, null]],
        3: [[4, 8, null]],
        4: [[5, 8, null]],
        5: [[6, 9, null]],
        6: [[6, 10, null]]
      },
      null, null,
      {6: [[0, 8, Player.grn]]}, // Col 11
      null,
      {6: [[0, 8, Player.grn]]}, // Col 13
      null
    ],

    // Row 2
    [
      null, null, null, null, null, null,
      // Col 6
      {
        1: [[1, 6, null]],
        2: [[0, 6, null]],
        3: [[0, 7, null]],
        4: [[0, 8, null], [1, 7, Player.grn]],
        5: [[1, 8, null], [2, 7, Player.grn]],
        6: [[2, 8, null], [3, 7, Player.grn]]
      },
      // Col 7
      {
        1: [[3, 7, Player.grn]],
        2: [[4, 7, Player.grn]],
        3: [[5, 7, Player.grn]]
      },
      // Col 8
      {
        1: [[3, 8, null]],
        2: [[4, 8, null]],
        3: [[5, 8, null]],
        4: [[6, 9, null]],
        5: [[6, 10, null]],
        6: [[6, 11, null]]
      },
      null, null, null, null, null, null
    ],

    // Row 3
    [
      null,
      {6: [[6, 0, Player.red]]}, // Col 1
      null,
      {6: [[6, 0, Player.red]]}, // Col 3
      null, null,
      // Col 6
      {
        1: [[2, 6, null]],
        2: [[1, 6, null]],
        3: [[0, 6, null]],
        4: [[0, 7, null]],
        5: [[0, 8, null], [1, 7, Player.grn]],
        6: [[1, 8, null], [2, 7, Player.grn]]
      },
      // Col 7
      {
        1: [[4, 7, Player.grn]],
        2: [[5, 7, Player.grn]]
      },
      // Col 8
      {
        1: [[4, 8, null]],
        2: [[5, 8, null]],
        3: [[6, 9, null]],
        4: [[6, 10, null]],
        5: [[6, 11, null]],
        6: [[6, 12, null]]
      },
      null, null,
      {6: [[0, 8, Player.grn]]}, // Col 11
      null,
      {6: [[0, 8, Player.grn]]}, // Col 13
      null
    ],

    // Row 4
    [
      null, null, null, null, null, null,
      // Col 6
      {
        1: [[3, 6, null]],
        2: [[2, 6, null]],
        3: [[1, 6, null]],
        4: [[0, 6, null]],
        5: [[0, 7, null]],
        6: [[0, 8, null], [1, 7, Player.grn]]
      },
      {1: [[5, 7, Player.grn]]}, // Col 7
      // Col 8
      {
        1: [[5, 8, null]],
        2: [[6, 9, null]],
        3: [[6, 10, null]],
        4: [[6, 11, null]],
        5: [[6, 12, null]],
        6: [[6, 13, null]],
      },
      null, null, null, null, null, null
    ],

    // Row 5
    [
      // Col 6
      {
        1: [[4, 6, null]],
        2: [[3, 6, null]],
        3: [[2, 6, null]],
        4: [[1, 6, null]],
        5: [[0, 6, null]],
        6: [[0, 7, null]]
      },
      {/* Empty */}, // Col 7
      // Col 8
      {
        1: [[6, 9, null]],
        2: [[6, 10, null]],
        3: [[6, 11, null]],
        4: [[6, 12, null]],
        5: [[6, 13, null]],
        6: [[6, 14, null]]
      }
    ],

    // TODO: Bunları doldur.
    // Row 6
    [
      // Col 0
      {
        1: [[6, 1, null]],
        2: [[6, 2, null]],
        3: [[6, 3, null]],
        4: [[6, 4, null]],
        5: [[6, 5, null]],
        6: [[5, 6, null]]
      },
      // Col 1
      {
        1: [[6, 2, null]],
        2: [[6, 3, null]],
        3: [[6, 4, null]],
        4: [[6, 5, null]],
        5: [[5, 6, null]],
        6: [[4, 6, null]]
      },
      // Col 2
      {
        1: [[6, 3, null]],
        2: [[6, 4, null]],
        3: [[6, 5, null]],
        4: [[5, 6, null]],
        5: [[4, 6, null]],
        6: [[3, 6, null]]
      },
      // Col 3
      {
        1: [[6, 4, null]],
        2: [[6, 5, null]],
        3: [[5, 6, null]],
        4: [[4, 6, null]],
        5: [[3, 6, null]],
        6: [[2, 6, null]]
      },
      // Col 4
      {
        1: [[6, 5, null]],
        2: [[5, 6, null]],
        3: [[4, 6, null]],
        4: [[3, 6, null]],
        5: [[2, 6, null]],
        6: [[1, 6, null]]
      },
      // Col 5
      {
        1: [[5, 6, null]],
        2: [[4, 6, null]],
        3: [[3, 6, null]],
        4: [[2, 6, null]],
        5: [[1, 6, null]],
        6: [[0, 6, null]]
      },
      null, null, null,
      // Col 9
      {
        1: [[6, 10, null]],
        2: [[6, 11, null]],
        3: [[6, 12, null]],
        4: [[6, 13, null]],
        5: [[6, 14, null]],
        6: [[7, 14, null]]
      },
      // Col 10
      {
        1: [[6, 11, null]],
        2: [[6, 12, null]],
        3: [[6, 13, null]],
        4: [[6, 14, null]],
        5: [[7, 14, null]],
        6: [[8, 14, null], [7, 13, Player.ylw]]
      },
      // Col 11
      {
        1: [[6, 12, null]],
        2: [[6, 13, null]],
        3: [[6, 14, null]],
        4: [[7, 14, null]],
        5: [[8, 14, null], [7, 13, Player.ylw]],
        6: [[8, 13, null], [7, 12, Player.ylw]]
      },
      // Col 12
      {
        1: [[6, 13, null]],
        2: [[6, 14, null]],
        3: [[7, 14, null]],
        4: [[8, 14, null], [7, 13, Player.ylw]],
        5: [[8, 13, null], [7, 12, Player.ylw]],
        6: [[8, 12, null], [7, 11, Player.ylw]]
      },
      // Col 13
      {
        1: [[6, 14, null]],
        2: [[7, 14, null]],
        3: [[8, 14, null], [7, 13, Player.ylw]],
        4: [[8, 13, null], [7, 12, Player.ylw]],
        5: [[8, 12, null], [7, 11, Player.ylw]],
        6: [[8, 11, null], [7, 10, Player.ylw]]
      },
      // Col 14
      {
        1: [[7, 14, null]],
        2: [[8, 14, null], [7, 13, Player.ylw]],
        3: [[8, 13, null], [7, 12, Player.ylw]],
        4: [[8, 12, null], [7, 11, Player.ylw]],
        5: [[8, 11, null], [7, 10, Player.ylw]],
        6: [[8, 10, null], [7, 9, Player.ylw]]
      }
    ],

    // Row 7
    [
      // Col 0
      {
        1: [[6, 0, null], [7, 1, Player.red]],
        2: [[6, 1, null], [7, 2, Player.red]],
        3: [[6, 2, null], [7, 3, Player.red]],
        4: [[6, 3, null], [7, 4, Player.red]],
        5: [[6, 4, null], [7, 5, Player.red]],
        6: [[6, 5, null]]
      },
      // Col 1
      {
        1: [[7, 2, Player.red]],
        2: [[7, 3, Player.red]],
        3: [[7, 4, Player.red]],
        4: [[7, 5, Player.red]]
      },
      // Col 2
      {
        1: [[7, 3, Player.red]],
        2: [[7, 4, Player.red]],
        3: [[7, 5, Player.red]]
      },
      // Col 3
      {
        1: [[7, 4, Player.red]],
        2: [[7, 5, Player.red]]
      },
      {1: [[7, 5, Player.red]]}, // Col 4
      { /* Empty */ }, // Col 5
      null, null, null,
      { /* Empty */ }, // Col 9
      {1: [[7, 9, Player.ylw]]}, // Col 10
      // Col 11
      {
        1: [[7, 10, Player.ylw]],
        2: [[7, 9, Player.ylw]]
      },
      // Col 12
      {
        1: [[7, 11, Player.ylw]],
        2: [[7, 10, Player.ylw]],
        3: [[7, 9, Player.ylw]]
      },
      // Col 13
      {
        1: [[7, 12, Player.ylw]],
        2: [[7, 11, Player.ylw]],
        3: [[7, 10, Player.ylw]],
        4: [[7, 9, Player.ylw]]
      },
      // Col 14
      {
        1: [[8, 14, null], [7, 13, Player.ylw]],
        2: [[8, 13, null], [7, 12, Player.ylw]],
        3: [[8, 12, null], [7, 11, Player.ylw]],
        4: [[8, 11, null], [7, 10, Player.ylw]],
        5: [[8, 10, null], [7, 9, Player.ylw]],
        6: [[8, 9, null]]
      }
    ],

    // Row 8
    [
      // Col 0
      {
        1: [[7, 0, null]],
        2: [[6, 0, null], [7, 1, Player.red]],
        3: [[6, 1, null], [7, 2, Player.red]],
        4: [[6, 2, null], [7, 3, Player.red]],
        5: [[6, 3, null], [7, 4, Player.red]],
        6: [[6, 4, null], [7, 5, Player.red]]
      },
      // Col 1
      {
        1: [[8, 0, null]],
        2: [[7, 0, null]],
        3: [[6, 0, null], [7, 1, Player.red]],
        4: [[6, 1, null], [7, 2, Player.red]],
        5: [[6, 2, null], [7, 3, Player.red]],
        6: [[6, 3, null], [7, 4, Player.red]]
      },
      // Col 2
      {
        1: [[8, 1, null]],
        2: [[8, 0, null]],
        3: [[7, 0, null]],
        4: [[6, 0, null], [7, 1, Player.red]],
        5: [[6, 1, null], [7, 2, Player.red]],
        6: [[6, 2, null], [7, 3, Player.red]],
      },
      // Col 3
      {
        1: [[8, 2, null]],
        2: [[8, 1, null]],
        3: [[8, 0, null]],
        4: [[7, 0, null]],
        5: [[6, 0, null], [7, 1, Player.red]],
        6: [[6, 1, null], [7, 2, Player.red]],
      },
      // Col 4
      {
        1: [[8, 3, null]],
        2: [[8, 2, null]],
        3: [[8, 1, null]],
        4: [[8, 0, null]],
        5: [[7, 0, null]],
        6: [[6, 0, null], [7, 1, Player.red]],
      },
      // Col 5
      {
        1: [[8, 4, null]],
        2: [[8, 3, null]],
        3: [[8, 2, null]],
        4: [[8, 1, null]],
        5: [[8, 0, null]],
        6: [[7, 0, null]],
      },
      null, null, null,
      // Col 9
      {
        1: [[9, 8, null]],
        2: [[10, 8, null]],
        3: [[11, 8, null]],
        4: [[12, 8, null]],
        5: [[13, 8, null]],
        6: [[14, 8, null]]
      },
      // Col 10
      {
        1: [[8, 9, null]],
        2: [[9, 8, null]],
        3: [[10, 8, null]],
        4: [[11, 8, null]],
        5: [[12, 8, null]],
        6: [[13, 8, null]]
      },
      // Col 11
      {
        1: [[8, 10, null]],
        2: [[8, 9, null]],
        3: [[9, 8, null]],
        4: [[10, 8, null]],
        5: [[11, 8, null]],
        6: [[12, 8, null]]
      },
      // Col 12
      {
        1: [[8, 11, null]],
        2: [[8, 10, null]],
        3: [[8, 9, null]],
        4: [[9, 8, null]],
        5: [[10, 8, null]],
        6: [[11, 8, null]]
      },
      // Col 13
      {
        1: [[8, 12, null]],
        2: [[8, 11, null]],
        3: [[8, 10, null]],
        4: [[8, 9, null]],
        5: [[9, 8, null]],
        6: [[10, 8, null]],
      },
      // Col 14
      {
        1: [[8, 13, null]],
        2: [[8, 12, null]],
        3: [[8, 11, null]],
        4: [[8, 10, null]],
        5: [[8, 9, null]],
        6: [[9, 8, null]]
      }
    ],

    // Row 9
    [
      null, null, null, null,  null, null,
      // Col 6
      {
        1: [[8, 5, null]],
        2: [[8, 4, null]],
        3: [[8, 3, null]],
        4: [[8, 2, null]],
        5: [[8, 1, null]],
        6: [[8, 0, null]]
      },
      { /* Empty */ }, // Col 7
      // Col 8
      {
        1: [[10, 8, null]],
        2: [[11, 8, null]],
        3: [[12, 8, null]],
        4: [[13, 8, null]],
        5: [[14, 8, null]],
        6: [[14, 7, null]]
      },
      null, null, null, null, null, null
    ],

    // Row 10
    [
      null, null, null, null, null, null,
      // Col 6
      {
        1: [[9, 6, null]],
        2: [[8, 5, null]],
        3: [[8, 4, null]],
        4: [[8, 3, null]],
        5: [[8, 2, null]],
        6: [[8, 1, null]]
      },
      {1: [[9, 7, Player.blu]]} ,// Col 7
      // Col 8
      {
        1: [[11, 8, null]],
        2: [[12, 8, null]],
        3: [[13, 8, null]],
        4: [[14, 8, null]],
        5: [[14, 7, null]],
        6: [[14, 6, null], [13, 7, Player.blu]]
      },
      null, null, null, null, null, null
    ],

    // Row 11
    [
      null, null, null, null, null, null,
      // Col 6
      {
        1: [[10, 6, null]],
        2: [[9, 6, null]],
        3: [[8, 5, null]],
        4: [[8, 4, null]],
        5: [[8, 3, null]],
        6: [[8, 2, null]]
      },
      // Col 7
      {
        1: [[10, 7, Player.blu]],
        2: [[9, 7, Player.blu]]
      },
      // Col 8
      {
        1: [[12, 8, null]],
        2: [[13, 8, null]],
        3: [[14, 8, null]],
        4: [[14, 7, null]],
        5: [[14, 6, null], [13, 7, Player.blu]],
        6: [[13, 6, null], [12, 7, Player.blu]]
      },
      null, null, null, null, null, null
    ],

    // Row 12
    [
      null, null, null, null, null, null,
      // Col 6
      {
        1: [[11, 6, null]],
        2: [[10, 6, null]],
        3: [[9, 6, null]],
        4: [[8, 5, null]],
        5: [[8, 4, null]],
        6: [[8, 3, null]]
      },
      // Col 7
      {
        1: [[11, 7, Player.blu]],
        2: [[10, 7, Player.blu]],
        3: [[9, 7, Player.blu]]
      },
      // Col 8
      {
        1: [[13, 8, null]],
        2: [[14, 8, null]],
        3: [[14, 7, null]],
        4: [[14, 6, null], [13, 7, Player.blu]],
        5: [[13, 6, null], [12, 7, Player.blu]],
        6: [[12, 6, null], [11, 7, Player.blu]]
      },
      null, null, null, null, null, null
    ],

    // Row 13
    [
      null, null, null, null, null, null,
      // Col 6
      {
        1: [[12, 6, null]],
        2: [[11, 6, null]],
        3: [[10, 6, null]],
        4: [[9, 6, null]],
        5: [[8, 5, null]],
        6: [[8, 4, null]]
      },
      // Col 7
      {
        1: [[12, 7, Player.blu]],
        2: [[11, 7, Player.blu]],
        3: [[10, 7, Player.blu]],
        4: [[9, 7, Player.blu]]
      },
      // Col 8
      {
        1: [[14, 8, null]],
        2: [[14, 7, null]],
        3: [[14, 6, null], [13, 7, Player.blu]],
        4: [[13, 6, null], [12, 7, Player.blu]],
        5: [[12, 6, null], [11, 7, Player.blu]],
        6: [[11, 6, null], [10, 7, Player.blu]]
      },
      null, null, null, null, null, null
    ],

    // Row 14
    [
      null, null, null, null, null, null,
      // Col 6
      {
        1: [[13, 6, null]],
        2: [[12, 6, null]],
        3: [[11, 6, null]],
        4: [[10, 6, null]],
        5: [[9, 6, null]],
        6: [[8, 5, null]]
      },
      // Col 7
      {
        1: [[14, 6, null], [13, 7, Player.blu]],
        2: [[12, 7, Player.blu]],
        3: [[11, 7, Player.blu]],
        4: [[10, 7, Player.blu]],
        5: [[9, 7, Player.blu]]
      },
      // Col 8
      {
        1: [[14, 7, null]],
        2: [[14, 6, null], [13, 7, Player.blu]],
        3: [[13, 6, null], [12, 7, Player.blu]],
        4: [[12, 6, null], [11, 7, Player.blu]],
        5: [[11, 6, null], [10, 7, Player.blu]],
        6: [[10, 6, null], [9, 7, Player.blu]]
      },
      null, null, null, null, null, null
    ],
  ];

  // Instance variables

  final Color defClr;
  final void Function()? onTapF;

  int hiliLvl;
  Player? player;
  int? pawnNum;

  // Constructor

  Cell({super.key, required this.defClr, this.player, this.pawnNum, this.hiliLvl=0, this.onTapF});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTapF,
      child: Container(
        color: hiliLvl==0 ? defClr : (hiliLvl==1 ? hili1clr : hili2clr),
        child: player==null ? null : Image(image: AssetImage(pathDict[player]))
      ),
    );
  }
}

