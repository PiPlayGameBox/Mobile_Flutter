import 'package:flutter/material.dart';

// Notify listener.
class RummikubDataProvider extends ChangeNotifier{

  List<RummikubData> fData = [];
  late List<RummikubData> _rumiData = [];
  int _index = 0; // Index increases every second.

  // Getters
  List<RummikubData> get rumiData => _rumiData;
  int get index => _index;

  void updateRummikubData(RummikubData data){
    _rumiData.add(data);
    notifyListeners();
  }

  void iterateIndex(){
    _index = _index + 1;
    notifyListeners();
  }

  Future<void> fetchData() async {
    await Future.delayed(Duration(seconds: 2));
    fData = _rumiData;
    notifyListeners();
  }

}

class RummikubData{
  RummikubData(this.checker, this.tilesTakoz, this.tilesThrown, this.middleTiles, this.userTurn);

  late String checker;
  late List<String> tilesTakoz;
  late List<String> tilesThrown;
  late List<String> middleTiles;
  late String userTurn;
}