import 'package:flutter/material.dart';

// Notify listener.
class RoomDataProvider extends ChangeNotifier{

  late List<RoomData> _rooms;

  // Getter
  List<RoomData> get rooms => _rooms;

  void updateRoomData(RoomData data){
    _rooms.add(data);
    notifyListeners();
  }

}

class RoomData{
  RoomData(this.name, this.gameType, this.password, this.players);

  late String name;
  late String gameType;
  late String password;
  late List<String> players;
}