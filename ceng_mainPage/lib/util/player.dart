import 'package:flutter/material.dart';

enum Player{blu, red, grn, ylw}

final Map colorDict={
  Player.blu: Colors.blue,
  Player.red: Colors.red,
  Player.grn: Colors.green,
  Player.ylw: Colors.yellow
};

final Map textColorDict={
  Player.blu: "blue",
  Player.red: "red",
  Player.grn: "green",
  Player.ylw: "yellow"
};

enum LudoKingGameState{rollDice, selPawn, selMove}
