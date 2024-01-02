import 'package:ceng_mainpage/util/lobby_item.dart';
import 'package:flutter/material.dart';

class LobbyScreen extends StatefulWidget {
  static String routeName = '/lobby';
  const LobbyScreen({super.key});

  @override
  State<LobbyScreen> createState() => _LobbyScreenState();
}

class _LobbyScreenState extends State<LobbyScreen> {
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
                  lobbyName: "Ceng x3",
                  lobbyNumber: 1,
                  playerOneName: "John",
                  playerTwoName: "Matt",
                  playerThreeName: "Susan",
                  amIJoined: true,

                ),
                SizedBox(
                  height: safeAreaHeight * 0.02,
                ),
                LobbyItem(
                  itemHeight: size.width * 0.85,
                  itemWidth: size.width * 0.7,
                  lobbyName: "*-Private-*",
                  lobbyNumber: 2,
                  playerOneName: "Frank",
                  playerTwoName: "",
                  playerThreeName: "",
                  amIJoined: false,
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
