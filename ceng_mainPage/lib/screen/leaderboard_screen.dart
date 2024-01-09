import 'package:ceng_mainpage/util/leaderboard_item.dart';
import 'package:flutter/material.dart';
import 'package:ceng_mainpage/screens/login_screen.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

class LeaderBoardUserInfo {
  int ludoPoints = 0;
  int okeyPoints = 0;
  String userName = "";
  int totalPoints = 0;

  LeaderBoardUserInfo(
      this.userName, this.ludoPoints, this.okeyPoints, this.totalPoints);
}

class LeaderboardScreen extends StatefulWidget {
  static String routeName = '/leaderboard';

  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<LeaderBoardUserInfo> usersInfo = [];
  List<Widget> leaderBoardItemWidgets = <Widget>[];

  void constructWidgets(
      double leaderBoardItemHeight, double leaderBoardItemWidth) {
    leaderBoardItemWidgets.clear();
    for (int i = 0; i < usersInfo.length; ++i) {
      leaderBoardItemWidgets.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: LeaderboardItem(
          width: leaderBoardItemWidth,
          height: leaderBoardItemHeight,
          ludoPoints: usersInfo[i].ludoPoints,
          okeyPoints: usersInfo[i].okeyPoints,
          placeInBoard: i + 1,
          userName: usersInfo[i].userName,
        ),
      ));
    }
  }

  String _createUserStatsRequestMessage() {
    // Login request string creater.
    String created = '';
    const String getLobbies = 'GETUSERSTATS|';
    created += getLobbies;
    created += loginGlobals.token;
    return created;
  }

  void _sendUserStatsRequest(String getReq) async {
    leaderBoardItemWidgets.clear();
    usersInfo.clear();
    try {
      // Create a new socket for each request
      Socket _socket = await Socket.connect(
          loginGlobals.piIP, 8080); // 127.0.0.1 ...... 10.42.0.1
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

            for (int i = 1; i < parts.length - 1; ++i) {
              List<String> tempStat = parts[i].split('|');
              if (tempStat[0] != "admin") {
                usersInfo.add(LeaderBoardUserInfo(
                    tempStat[0],
                    (int.parse(tempStat[1]) - int.parse(tempStat[2])),
                    (int.parse(tempStat[3]) - int.parse(tempStat[4])),
                    ((int.parse(tempStat[1]) - int.parse(tempStat[2])) +
                        (int.parse(tempStat[3]) - int.parse(tempStat[4])))));
              }
            }
            usersInfo.sort((a, b) => b.totalPoints.compareTo(a.totalPoints));
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
    _sendUserStatsRequest(_createUserStatsRequestMessage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    Size size = MediaQuery.of(context).size;
    double safeAreaHeight = size.height - topPadding - bottomPadding;
    double leaderBoardItemHeight = safeAreaHeight * 0.75 * 0.15;
    double leaderBoardItemWidth = size.width * 0.9;

    constructWidgets(leaderBoardItemHeight, leaderBoardItemWidth);

    return Scaffold(
      backgroundColor: const Color(0xfffaab70),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: safeAreaHeight * 0.0,
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Container(
                    width: size.width * 0.8,
                    height: safeAreaHeight * 0.2,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/ribbon.png"),
                          fit: BoxFit.fill),
                    ),
                  ),
                ),
                Text(
                  "LEADERBOARD",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: safeAreaHeight * 0.035,
                  ),
                )
              ],
            ),
            Container(
              height: safeAreaHeight * 0.75,
              width: size.width * 0.9,
              decoration: const BoxDecoration(
                color: Color(0xffed9956),
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: leaderBoardItemWidgets,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
