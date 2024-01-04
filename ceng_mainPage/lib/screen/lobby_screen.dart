import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ceng_mainpage/screens/login_screen.dart';
import 'package:ceng_mainpage/util/lobby_item.dart';
import 'package:flutter/material.dart';

class lobbyScreenGlobals{
  static List<LobbyInfo> lobbyInformations = [];
}

class LobbyInfo{

  String lobbyID = '';
  String lobbyType = '';
  String lobbyPlayer1 = '';
  String lobbyPlayer2 = '';
  String lobbyPlayer3 = '';

  LobbyInfo(this.lobbyID, this.lobbyType, this.lobbyPlayer1, this.lobbyPlayer2, this.lobbyPlayer3);
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

  String createConnectMessage(String lobbyId, String lobbyPass){

    String created = '';

    const String connect = 'CONNECT|';

    created += connect;

    created += loginGlobals.token;

    created += '|';

    created += lobbyId;

    created += '|';

    created += lobbyPass;

    return created;
  }

  void _sendGetLobbiesRequest(String getReq) async {
    try {
      // Create a new socket for each request
      Socket _socket = await Socket.connect(loginGlobals.piIP, 8080); // 127.0.0.1 ...... 10.42.0.1

      // Send a simple message to the server
      _socket.write(getReq);

      // Listen for responses from the server
      _socket.listen(
            (List<int> data) {
          // Convert the received data to a String
          String response = utf8.decode(data);

          // Update the UI with the received response
          print('Received from server: $response');

          List<String> parts = response.split('/');

          print('LOBBY RESPONSE: $parts');

          setState(() {
            String lobbySuccess = parts[0];

            for(int i=1; i<parts.length; ++i){

              List<String> tempInfo = parts[i].split('|');

              lobbyScreenGlobals.lobbyInformations.add(LobbyInfo(tempInfo[0],tempInfo[1],tempInfo[2],tempInfo[3],tempInfo[4]));

              print('${tempInfo[0]},${tempInfo[1]},${tempInfo[2]},${tempInfo[3]},${tempInfo[4]}');

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

  void _sendConnectRequest(String connectReq) async {
    try {
      // Create a new socket for each request
      Socket _socket = await Socket.connect(loginGlobals.piIP, 8080); // 127.0.0.1 ...... 10.42.0.1

      // Send a simple message to the server
      _socket.write(connectReq);

      // Listen for responses from the server
      _socket.listen(
            (List<int> data) {
          // Convert the received data to a String
          String response = utf8.decode(data);

          // Update the UI with the received response
          print('Received from server: $response');

          List<String> parts = response.split('/');

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _sendGetLobbiesRequest(createGetLobbiesMessage());

    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer){

      _sendGetLobbiesRequest(createGetLobbiesMessage());

    });
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
                LobbyItem(
                  itemHeight: size.width * 0.85,
                  itemWidth: size.width * 0.7,
                  lobbyName: "LOBBY ${lobbyScreenGlobals.lobbyInformations[0].lobbyID}",
                  lobbyNumber: 1,
                  playerOneName: "${lobbyScreenGlobals.lobbyInformations[0].lobbyPlayer1}",
                  playerTwoName: "${lobbyScreenGlobals.lobbyInformations[0].lobbyPlayer2}",
                  playerThreeName: "${lobbyScreenGlobals.lobbyInformations[0].lobbyPlayer3}",
                ),
                SizedBox(
                  height: safeAreaHeight * 0.02,
                ),
                LobbyItem(
                  itemHeight: size.width * 0.85,
                  itemWidth: size.width * 0.7,
                  lobbyName: "LOBBY ${lobbyScreenGlobals.lobbyInformations[1].lobbyID}",
                  lobbyNumber: 2,
                  playerOneName: "${lobbyScreenGlobals.lobbyInformations[1].lobbyPlayer1}",
                  playerTwoName: "${lobbyScreenGlobals.lobbyInformations[1].lobbyPlayer2}",
                  playerThreeName: "${lobbyScreenGlobals.lobbyInformations[1].lobbyPlayer3}",
                ),
                SizedBox(
                  height: safeAreaHeight * 0.04,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
