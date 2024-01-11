import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ceng_mainpage/screen/ludo_screen.dart';
import 'package:ceng_mainpage/screen/rummikub_screen.dart';
import 'package:ceng_mainpage/screens/login_screen.dart';
import 'package:ceng_mainpage/screen/main_menu_screen.dart';
import 'package:flutter/material.dart';

class lobbyScreenGlobals{
  static List<LobbyInfo> lobbyInformations = [];
  static List<String> globPlayersLudo = ['empty', 'empty', 'empty', 'empty'];
  static List<String> globPlayersOkey = ['empty', 'empty', 'empty', 'empty'];
}

class LobbyItemGlobals {
  static int joinedLobby = -1;
  static bool ludoStart = false;
  static bool okeyStart = false;
  static bool stopCheck = false;
  static double ludoOpacity = 0.0;
  static double okeyOpacity = 0.0;
}

class LobbyInfo{

  String lobbyID = '';
  String lobbyType = '';
  List<String> lobbyPlayers = ["empty","empty","empty"];

  LobbyInfo(this.lobbyID, this.lobbyType, this.lobbyPlayers);
}

class LobbyScreen extends StatefulWidget {
  static String routeName = '/lobby';
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}



class _LobbyScreenState extends State<LobbyScreen> {

  late Timer timer;

  String createGetLobbiesMessage(){

    String created = '';

    const String getLobbies = 'GETLOBBIES|';

    created += getLobbies;

    created += loginGlobals.token;

    return created;
  }

  void _sendGetLobbiesRequest(String getReq) async {
    try {

      clearLobbyInformation();
      // Create a new socket for each request
      Socket _socket = await Socket.connect(loginGlobals.piIP, 8080); // 127.0.0.1 ...... 10.42.0.1

      // Send a simple message to the server
      _socket.write(getReq);

      // Listen for responses from the server
      _socket.listen(
            (List<int> data) {
          // Convert the received data to a String
          String response = utf8.decode(data);

          setState(() {

            // Update the UI with the received response
            print('Received from server: $response');

            List<String> parts = response.split('/');

            print('LOBBY RESPONSE: $parts');

            String lobbySuccess = parts[0];

            for(int i=1; i<parts.length; ++i){

              List<String> tempInfo = parts[i].split('|');

              List<String> tempPlayers = ['empty','empty','empty','empty'];

              tempPlayers[0] = tempInfo[2];

              tempPlayers[1] = tempInfo[3];

              tempPlayers[2] = tempInfo[4];

              tempPlayers[3] = tempInfo[5];

              if(tempInfo[1] == 'LUDO'){
                lobbyScreenGlobals.globPlayersLudo = tempPlayers;
              }else if(tempInfo[1] == 'OKEY'){
                lobbyScreenGlobals.globPlayersOkey = tempPlayers;
              }

              lobbyScreenGlobals.lobbyInformations.add(LobbyInfo(tempInfo[0],tempInfo[1],tempPlayers));

              print('IMDAT: ${tempInfo[0]},${tempInfo[1]},${tempPlayers}');

            }


          });

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

  String createConnectMessage(String lobbyId) {
    String created = '';

    const String connect = 'CONNECT|';

    created += connect;

    created += loginGlobals.token;

    created += '|';

    created += lobbyId;

    return created;
  }

  void _sendConnectRequest(String connectReq) async {
    try {
      // Create a new socket for each request
      Socket _socket = await Socket.connect(
          loginGlobals.piIP, 8080); // 127.0.0.1 ...... 10.42.0.1

      // Send a simple message to the server
      _socket.write(connectReq);

      // Listen for responses from the server
      _socket.listen(
            (List<int> data) {
          // Convert the received data to a String
          String response = utf8.decode(data);

          // Update the UI with the received response
          print('Received from server: $response');

          List<String> parts = response.split('|');

          print('LOBBY RESPONSE: $parts');

          setState(() {
            String lobbySuccess = parts[0];
            String connectMessage = parts[1];

            print(connectMessage);
          });

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

  String createDisconnectMessage(String lobbyId) {
    String created = '';

    const String connect = 'DISCONNECT|';

    created += connect;

    created += loginGlobals.token;

    created += '|';

    created += lobbyId;

    return created;
  }

  void _sendDisconnectRequest(String disconnectReq) async {
    try {
      // Create a new socket for each request
      Socket _socket = await Socket.connect(
          loginGlobals.piIP, 8080); // 127.0.0.1 ...... 10.42.0.1

      // Send a simple message to the server
      _socket.write(disconnectReq);

      // Listen for responses from the server
      _socket.listen(
            (List<int> data) {
          // Convert the received data to a String
          String response = utf8.decode(data);

          // Update the UI with the received response
          print('Received from server: $response');

          List<String> parts = response.split('|');

          print('LOBBY RESPONSE: $parts');

          setState(() {
            String lobbySuccess = parts[0];
            String connectMessage = parts[1];

            print(connectMessage);
          });

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

  void clearLobbyInformation() {
    setState(() {
      lobbyScreenGlobals.lobbyInformations.clear();
    });
  }


  void _ludoStartCheck(){
    int counter = 0;

    for(int i = 0; i<4; ++i){
      if(lobbyScreenGlobals.globPlayersLudo[i] != 'empty'){

        ++counter;

      }
    }

    if(counter == 4){
      LobbyItemGlobals.ludoStart = true;
      LobbyItemGlobals.ludoOpacity = 1.0;
      _navigateToLudo(); // TODO: fix?
    }
    else{
      LobbyItemGlobals.ludoStart = false;
      LobbyItemGlobals.ludoOpacity = 0.0;
    }
    print('LUDO: ');
    print(LobbyItemGlobals.ludoStart);

  }

  void _okeyStartCheck(){

    int counter = 0;

    for(int i = 0; i<4; ++i){
      if(lobbyScreenGlobals.globPlayersOkey[i] != 'empty'){

        ++counter;

      }
    }

    if(counter == 4){
      LobbyItemGlobals.okeyStart = true;
      LobbyItemGlobals.okeyOpacity = 1.0;
      _navigateToOkey(); // TODO: fix?
    }
    else{
      LobbyItemGlobals.okeyStart = false;
      LobbyItemGlobals.okeyOpacity = 0.0;
    }

    print('OKEY: ');
    print(LobbyItemGlobals.okeyStart);

  }


  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    /*_sendGetLobbiesRequest(createGetLobbiesMessage());*/

    LobbyItemGlobals.joinedLobby = -1;
    LobbyItemGlobals.ludoStart = false;
    LobbyItemGlobals.okeyStart = false;
    LobbyItemGlobals.stopCheck = false;

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {

        _sendGetLobbiesRequest(createGetLobbiesMessage());

        /*if(!LobbyItemGlobals.stopCheck){
          ludoStartCheck();
          okeyStartCheck();
        }*/
        /*_ludoStartCheck();
        _okeyStartCheck();*/

        /*if(LobbyItemGlobals.ludoStart == true){

          // Reset
          LobbyItemGlobals.ludoStart = false;
          LobbyItemGlobals.okeyStart = false;
          LobbyItemGlobals.stopCheck = true;

          print(LobbyItemGlobals.stopCheck);

          print(LobbyItemGlobals.ludoStart);

          _navigateToLudo();
          _showStartDialog(context, 'LUDO');


        }
        else if(LobbyItemGlobals.okeyStart == true){

          // Reset
          LobbyItemGlobals.ludoStart = false;
          LobbyItemGlobals.okeyStart = false;
          LobbyItemGlobals.stopCheck = true;

          LobbyItemGlobals.okeyOpacity = 1.0;


          _navigateToOkey();
          _showStartDialog(context, 'OKEY');


        }*/


      });
    });

  }


  @override
  void dispose() {

    // We are stopping the timer when widget disposed.
    timer.cancel();


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    Size size = MediaQuery.of(context).size;
    double safeAreaHeight = size.height - topPadding - bottomPadding;

    return Scaffold(
      backgroundColor: const Color(0xffa8b6a8),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 3,
        backgroundColor: const Color(0xffa8b6a8),
        shadowColor: Colors.black,
        title: Text(
          "Lobbies",
          style: TextStyle(fontSize: safeAreaHeight * 0.06),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: safeAreaHeight * 0.04,
                ),
                //// LUDO LOBBY
                SizedBox(
                  width: size.width * 0.7,
                  height: size.width * 0.85,
                  child: Column(
                    children: [
                      Container(
                        width: size.width * 0.7,
                        height: (size.width * 0.85 - size.width * 0.7) * 0.9,
                        decoration: const BoxDecoration(
                          // border: Border.all(color: Colors.black, width: 3),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xff004c5f),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width * 0.85 * 0.15,
                              decoration: const BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                                color: Colors.red,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                  width: size.width * 0.85 * 0.15,
                                  height: size.width * 0.85 * 0.15,
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          size.width * 0.85 * 0.15 * 0.5),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      1.toString(),
                                      style: TextStyle(
                                        fontSize:
                                        size.width * 0.85 * 0.10 * 0.8,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.7 * 0.08,
                            ),
                            Text(
                              "LUDO",
                              style: TextStyle(
                                  fontSize:
                                  (size.width * 0.85 - size.width * 0.7) *
                                      0.9 *
                                      0.4,
                                  color: Colors.white),
                            ),
                            Container(child:() {
                              if (LobbyItemGlobals.ludoOpacity == 0.0) {
                                return Opacity(opacity: LobbyItemGlobals.ludoOpacity + 0.3, child: const Icon(Icons.play_circle, color: Colors.white,),);
                              } else {
                                return Opacity(opacity: LobbyItemGlobals.ludoOpacity, child: IconButton(onPressed: () { _navigateToLudo(); },icon: Icon(Icons.play_circle, color: Colors.green,), iconSize: (size.width * 0.85 - size.width * 0.7) *
                                    0.9 *
                                    0.4, ),);
                              }
                            }(),),
                            /*Opacity(opacity: LobbyItemGlobals.okeyOpacity, child: IconButton(onPressed: () { _navigateToOkey(); },icon: Icon(Icons.start), ),),*/
                            const Spacer(),
                            Image.asset(
                              "assets/images/ludo.png",
                              height: size.width * 0.85 * 0.15,
                              width: size.width * 0.85 * 0.15,
                            ),
                            SizedBox(
                              width: size.width * 0.7 * 0.06,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height:
                          (size.width * 0.85 - size.width * 0.7) * 0.06),
                      Container(
                        width: size.width * 0.7,
                        height: size.width * 0.7,
                        child: Stack(
                          children: [
                            Positioned(
                              top: size.width * 0.7 * 0.1,
                              left: size.width * 0.7 * 0.1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  "assets/images/wooden_board.png",
                                  height: size.width * 0.7 * 0.8,
                                  width: size.width * 0.7 * 0.8,
                                ),
                              ),
                            ),

                            // join-leave
                            Positioned(
                              top: size.width * 0.7 * 0.33,
                              left: size.width * 0.7 * 0.35,
                              child: GestureDetector(
                                onTap: (LobbyItemGlobals.joinedLobby == -1)
                                    ? () {
                                  setState(() {
                                    LobbyItemGlobals.joinedLobby = 1;

                                    _sendConnectRequest(
                                        createConnectMessage(
                                            1.toString()));
                                  });
                                }
                                    : () {
                                  setState(() {
                                    if (LobbyItemGlobals.joinedLobby ==
                                        1) {
                                      _sendDisconnectRequest(
                                          createDisconnectMessage(
                                              1.toString()));

                                      LobbyItemGlobals.joinedLobby = -1;
                                    }
                                  });
                                },
                                child: Container(
                                  width: size.width * 0.7 * 0.3,
                                  height: size.width * 0.7 * 0.3,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.orange, width: 5.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              size.width * 0.7 * 0.3 * 0.5)),
                                      color: Colors.black87),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: (LobbyItemGlobals.joinedLobby != 1)
                                        ? const FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "PLAY",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                        : const FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "LEAVE",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // top player
                            Positioned(
                              top: 0.0,
                              left: size.width * 0.7 * 0.35,
                              child: Container(
                                width: size.width * 0.7 * 0.3,
                                height: size.width * 0.7 * 0.3,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff0E77F2), width: 5.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            size.width * 0.7 * 0.3 * 0.5)),
                                    color: const Color(0xff04203f)),
                                child: () {
                                  if (lobbyScreenGlobals
                                      .lobbyInformations.isNotEmpty) {
                                    if (lobbyScreenGlobals.lobbyInformations[0]
                                        .lobbyPlayers[0] ==
                                        'empty') {
                                      return const Icon(Icons.person_off);
                                    }
                                    return Image.asset(mainMenuGlobals.picList[
                                    lobbyScreenGlobals.lobbyInformations[0]
                                        .lobbyPlayers[0].hashCode %
                                        mainMenuGlobals.ICON_NUMBER]);
                                  } else {
                                    return const Icon(Icons.person_off);
                                  }
                                }(),
                              ),
                            ),

                            // right player
                            Positioned(
                              top: size.width * 0.85 * 0.27,
                              right: 0.0,
                              child: Container(
                                width: size.width * 0.7 * 0.3,
                                height: size.width * 0.7 * 0.3,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff0E77F2), width: 5.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            size.width * 0.7 * 0.3 * 0.5)),
                                    color: const Color(0xff04203f)),
                                child: () {
                                  if (lobbyScreenGlobals
                                      .lobbyInformations.isNotEmpty) {
                                    if (lobbyScreenGlobals.lobbyInformations[0]
                                        .lobbyPlayers[1] ==
                                        'empty') {
                                      return const Icon(Icons.person_off);
                                    }
                                    return Image.asset(mainMenuGlobals.picList[
                                    lobbyScreenGlobals.lobbyInformations[0]
                                        .lobbyPlayers[1].hashCode %
                                        mainMenuGlobals.ICON_NUMBER]);
                                  } else {
                                    return const Icon(Icons.person_off);
                                  }
                                }(),
                              ),
                            ),

                            // bottom player
                            Positioned(
                              bottom: 0.0,
                              left: size.width * 0.7 * 0.35,
                              child: Container(
                                width: size.width * 0.7 * 0.3,
                                height: size.width * 0.7 * 0.3,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff0E77F2), width: 5.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            size.width * 0.7 * 0.3 * 0.5)),
                                    color: const Color(0xff04203f)),
                                child: () {
                                  if (lobbyScreenGlobals
                                      .lobbyInformations.isNotEmpty) {
                                    if (lobbyScreenGlobals.lobbyInformations[0]
                                        .lobbyPlayers[2] ==
                                        'empty') {
                                      return const Icon(Icons.person_off);
                                    }
                                    return Image.asset(mainMenuGlobals.picList[
                                    lobbyScreenGlobals.lobbyInformations[0]
                                        .lobbyPlayers[2].hashCode %
                                        mainMenuGlobals.ICON_NUMBER]);
                                  } else {
                                    return const Icon(Icons.person_off);
                                  }
                                }(),
                              ),
                            ),

                            // left player
                            Positioned(
                              top: size.width * 0.85 * 0.27,
                              left: 0.0,
                              child: Container(
                                width: size.width * 0.7 * 0.3,
                                height: size.width * 0.7 * 0.3,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff0E77F2), width: 5.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            size.width * 0.7 * 0.3 * 0.5)),
                                    color: const Color(0xff04203f)),
                                child: () {
                                  if (lobbyScreenGlobals
                                      .lobbyInformations.isNotEmpty) {
                                    if (lobbyScreenGlobals.lobbyInformations[0]
                                        .lobbyPlayers[3] ==
                                        'empty') {
                                      return const Icon(Icons.person_off);
                                    }
                                    return Image.asset(mainMenuGlobals.picList[
                                    lobbyScreenGlobals.lobbyInformations[0]
                                        .lobbyPlayers[3].hashCode %
                                        mainMenuGlobals.ICON_NUMBER]);
                                  } else {
                                    return const Icon(Icons.person_off);
                                  }
                                }(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ////

                SizedBox(
                  height: safeAreaHeight * 0.02,
                ),
                //// OKEY LOBBY
                SizedBox(
                  width: size.width * 0.85,
                  height: size.width * 0.7,
                  child: Column(
                    children: [
                      Container(
                        width: size.width * 0.7,
                        height: (size.width * 0.85 - size.width * 0.7) * 0.9,
                        decoration: const BoxDecoration(
                          // border: Border.all(color: Colors.black, width: 3),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Color(0xff004c5f),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width * 0.85 * 0.15,
                              decoration: const BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8)),
                                color: Colors.red,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Container(
                                  width: size.width * 0.85 * 0.15,
                                  height: size.width * 0.85 * 0.15,
                                  decoration: BoxDecoration(
                                    color: Colors.redAccent,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          size.width * 0.85 * 0.15 * 0.5),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      2.toString(),
                                      style: TextStyle(
                                        fontSize:
                                        size.width * 0.85 * 0.10 * 0.8,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.7 * 0.08,
                            ),
                            Text(
                              "OKEY",
                              style: TextStyle(
                                  fontSize:
                                  (size.width * 0.85 - size.width * 0.7) *
                                      0.9 *
                                      0.4,
                                  color: Colors.white),
                            ),
                            Container(child:() {
                              if (LobbyItemGlobals.okeyOpacity == 0.0) {
                                return Opacity(opacity: LobbyItemGlobals.okeyOpacity + 0.3, child: const Icon(Icons.play_circle, color: Colors.white,),);
                              } else {
                                return Opacity(opacity: LobbyItemGlobals.okeyOpacity, child: IconButton(onPressed: () { _navigateToOkey(); },icon: Icon(Icons.play_circle, color: Colors.green,), iconSize: (size.width * 0.85 - size.width * 0.7) *
                                    0.9 *
                                    0.4, ),);
                              }
                            }(),),
                            const Spacer(),
                            IconButton(onPressed: (){_okeyStartCheck();}, icon: Icon(Icons.refresh)),
                            Image.asset(
                              "assets/images/okey.png",
                              height: size.width * 0.85 * 0.15,
                              width: size.width * 0.85 * 0.15,
                            ),
                            SizedBox(
                              width: size.width * 0.7 * 0.06,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height:
                          (size.width * 0.85 - size.width * 0.7) * 0.06),
                      Container(
                        width: size.width * 0.7,
                        height: size.width * 0.7,
                        child: Stack(
                          children: [
                            Positioned(
                              top: size.width * 0.7 * 0.1,
                              left: size.width * 0.7 * 0.1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  "assets/images/wooden_board.png",
                                  height: size.width * 0.7 * 0.8,
                                  width: size.width * 0.7 * 0.8,
                                ),
                              ),
                            ),

                            // join-leave
                            Positioned(
                              top: size.width * 0.7 * 0.33,
                              left: size.width * 0.7 * 0.35,
                              child: GestureDetector(
                                onTap: (LobbyItemGlobals.joinedLobby == -1)
                                    ? () {
                                  setState(() {
                                    LobbyItemGlobals.joinedLobby = 2;

                                    _sendConnectRequest(
                                        createConnectMessage(
                                            2.toString()));
                                  });
                                }
                                    : () {
                                  setState(() {
                                    if (LobbyItemGlobals.joinedLobby ==
                                        2) {
                                      _sendDisconnectRequest(
                                          createDisconnectMessage(
                                              2.toString()));

                                      LobbyItemGlobals.joinedLobby = -1;
                                    }
                                  });
                                },
                                child: Container(
                                  width: size.width * 0.7 * 0.3,
                                  height: size.width * 0.7 * 0.3,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.orange, width: 5.0),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              size.width * 0.7 * 0.3 * 0.5)),
                                      color: Colors.black87),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: (LobbyItemGlobals.joinedLobby != 2)
                                        ? const FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "PLAY",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                        : const FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "LEAVE",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // top player
                            Positioned(
                              top: 0.0,
                              left: size.width * 0.7 * 0.35,
                              child: Container(
                                width: size.width * 0.7 * 0.3,
                                height: size.width * 0.7 * 0.3,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff0E77F2), width: 5.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            size.width * 0.7 * 0.3 * 0.5)),
                                    color: const Color(0xff04203f)),
                                child: () {
                                  if (lobbyScreenGlobals
                                      .lobbyInformations.isNotEmpty) {
                                    if (lobbyScreenGlobals.lobbyInformations[1]
                                        .lobbyPlayers[0] ==
                                        'empty') {
                                      return const Icon(Icons.person_off);
                                    }
                                    return Image.asset(mainMenuGlobals.picList[
                                    lobbyScreenGlobals.lobbyInformations[1]
                                        .lobbyPlayers[0].hashCode %
                                        mainMenuGlobals.ICON_NUMBER]);
                                  } else {
                                    return const Icon(Icons.person_off);
                                  }
                                }(),
                              ),
                            ),

                            // right player
                            Positioned(
                              top: size.width * 0.85 * 0.27,
                              right: 0.0,
                              child: Container(
                                width: size.width * 0.7 * 0.3,
                                height: size.width * 0.7 * 0.3,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff0E77F2), width: 5.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            size.width * 0.7 * 0.3 * 0.5)),
                                    color: const Color(0xff04203f)),
                                child: () {
                                  if (lobbyScreenGlobals
                                      .lobbyInformations.isNotEmpty) {
                                    if (lobbyScreenGlobals.lobbyInformations[1]
                                        .lobbyPlayers[1] ==
                                        'empty') {
                                      return const Icon(Icons.person_off);
                                    }
                                    return Image.asset(mainMenuGlobals.picList[
                                    lobbyScreenGlobals.lobbyInformations[1]
                                        .lobbyPlayers[1].hashCode %
                                        mainMenuGlobals.ICON_NUMBER]);
                                  } else {
                                    return const Icon(Icons.person_off);
                                  }
                                }(),
                              ),
                            ),

                            // bottom player
                            Positioned(
                              bottom: 0.0,
                              left: size.width * 0.7 * 0.35,
                              child: Container(
                                width: size.width * 0.7 * 0.3,
                                height: size.width * 0.7 * 0.3,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff0E77F2), width: 5.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            size.width * 0.7 * 0.3 * 0.5)),
                                    color: const Color(0xff04203f)),
                                child: () {
                                  if (lobbyScreenGlobals
                                      .lobbyInformations.isNotEmpty) {
                                    if (lobbyScreenGlobals.lobbyInformations[1]
                                        .lobbyPlayers[2] ==
                                        'empty') {
                                      return const Icon(Icons.person_off);
                                    }
                                    return Image.asset(mainMenuGlobals.picList[
                                    lobbyScreenGlobals.lobbyInformations[1]
                                        .lobbyPlayers[2].hashCode %
                                        mainMenuGlobals.ICON_NUMBER]);
                                  } else {
                                    return const Icon(Icons.person_off);
                                  }
                                }(),
                              ),
                            ),

                            // left player
                            Positioned(
                              top: size.width * 0.85 * 0.27,
                              left: 0.0,
                              child: Container(
                                width: size.width * 0.7 * 0.3,
                                height: size.width * 0.7 * 0.3,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff0E77F2), width: 5.0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            size.width * 0.7 * 0.3 * 0.5)),
                                    color: const Color(0xff04203f)),
                                child: () {
                                  if (lobbyScreenGlobals
                                      .lobbyInformations.isNotEmpty) {
                                    if (lobbyScreenGlobals.lobbyInformations[1]
                                        .lobbyPlayers[3] ==
                                        'empty') {
                                      return const Icon(Icons.person_off);
                                    }
                                    return Image.asset(mainMenuGlobals.picList[
                                    lobbyScreenGlobals.lobbyInformations[1]
                                        .lobbyPlayers[3].hashCode %
                                        mainMenuGlobals.ICON_NUMBER]);
                                  } else {
                                    return const Icon(Icons.person_off);
                                  }
                                }(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: safeAreaHeight * 0.1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showStartDialog(BuildContext context, String gameType) async {
    bool start = false;



    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('GAME STARTED!'),
          content: const Text('Press the button to play.'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                start = true;
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.start),
            ),
          ],
        );
      },
    );

    if (start) {

      if(gameType == 'LUDO'){

        _navigateToLudo();

      }else if (gameType == 'OKEY'){

        _navigateToOkey();

      }else{ //Invalid game.

      }

    }

    return Future.value(!start); // Return whether to allow or block the start.
  }

  void _navigateToLudo(){
    print('A');
    print(lobbyScreenGlobals.globPlayersLudo[3]);
    print('B');
    print(LobbyItemGlobals.ludoStart);

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LudoScreen(players:  lobbyScreenGlobals.globPlayersLudo ,)),
    );
  }

  void _navigateToOkey() {

    List<String> LUR = ['','',''];// Left up right.
    print("oky strt");
    // AAA BBB CCC DDD
    //  0   1   2   3
    if(loginGlobals.username == lobbyScreenGlobals.globPlayersOkey[0]){ // AAA
      LUR[0] = lobbyScreenGlobals.globPlayersOkey[3]; // Left
      LUR[1] = lobbyScreenGlobals.globPlayersOkey[2]; // Middle
      LUR[2] = lobbyScreenGlobals.globPlayersOkey[1]; // Right

    }else if(loginGlobals.username == lobbyScreenGlobals.globPlayersOkey[1]){ // BBB
      LUR[0] = lobbyScreenGlobals.globPlayersOkey[0]; // Left
      LUR[1] = lobbyScreenGlobals.globPlayersOkey[3]; // Middle
      LUR[2] = lobbyScreenGlobals.globPlayersOkey[2]; // Right
    }else if(loginGlobals.username == lobbyScreenGlobals.globPlayersOkey[2]){ // CCC
      LUR[0] = lobbyScreenGlobals.globPlayersOkey[1]; // Left
      LUR[1] = lobbyScreenGlobals.globPlayersOkey[0]; // Middle
      LUR[2] = lobbyScreenGlobals.globPlayersOkey[3]; // Right
    }else if(loginGlobals.username == lobbyScreenGlobals.globPlayersOkey[3]){ // DDD
      LUR[0] = lobbyScreenGlobals.globPlayersOkey[2]; // Left
      LUR[1] = lobbyScreenGlobals.globPlayersOkey[1]; // Middle
      LUR[2] = lobbyScreenGlobals.globPlayersOkey[0]; // Right
    }else{ // If none,

    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => RummikubScreen(token: loginGlobals.token,userName: loginGlobals.username, infoLUR: LUR)),
    );

  }

}
