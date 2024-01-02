import 'package:ceng_mainpage/util/leaderboard_item.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  static String routeName = '/leaderboard';
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  @override
  Widget build(BuildContext context) {
    double topPadding = MediaQuery.of(context).padding.top;
    double bottomPadding = MediaQuery.of(context).padding.bottom;
    Size size = MediaQuery.of(context).size;
    double safeAreaHeight = size.height - topPadding - bottomPadding;
    double leaderBoardItemHeight = safeAreaHeight * 0.75 * 0.15;
    double leaderBoardItemWidth = size.width * 0.9;
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
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LeaderboardItem(
                        width: leaderBoardItemWidth,
                        height: leaderBoardItemHeight,
                        avatar: "",
                        ludoPoints: 9999,
                          okeyPoints: 9999,
                        placeInBoard: 1,
                        userName: "AHMET",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LeaderboardItem(
                        width: leaderBoardItemWidth,
                        height: leaderBoardItemHeight,
                        avatar: "",
                        ludoPoints: 999,
                        okeyPoints: 999,
                        placeInBoard: 2,
                        userName: "AHMETDSGSDGSDKHSDKHSDh",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LeaderboardItem(
                        width: leaderBoardItemWidth,
                        height: leaderBoardItemHeight,
                        avatar: "",
                        ludoPoints: 999,
                        okeyPoints: 999,
                        placeInBoard: 3,
                        userName: "AHMET",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LeaderboardItem(
                        width: leaderBoardItemWidth,
                        height: leaderBoardItemHeight,
                        avatar: "",
                        ludoPoints: 999,
                        okeyPoints: 999,
                        placeInBoard: 4,
                        userName: "AHMET",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LeaderboardItem(
                        width: leaderBoardItemWidth,
                        height: leaderBoardItemHeight,
                        avatar: "",
                        ludoPoints: 10,
                        okeyPoints: 10,
                        placeInBoard: 5,
                        userName: "OZAN DORUK",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LeaderboardItem(
                        width: leaderBoardItemWidth,
                        height: leaderBoardItemHeight,
                        avatar: "",
                        ludoPoints: 10,
                        okeyPoints: 10,
                        placeInBoard: 6,
                        userName: "OZAN DORUK",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
