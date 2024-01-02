import 'package:ceng_mainpage/screen/leaderboard_screen.dart';
import 'package:ceng_mainpage/screen/lobbies_screen.dart';
import 'package:ceng_mainpage/screen/lobby_screen.dart';
import 'package:ceng_mainpage/screen/profile_screen.dart';
import 'package:ceng_mainpage/widget/custom_imagebanner.dart';
import 'package:flutter/material.dart';

import '../responsive/responsive.dart';
import '../widget/custom_button.dart';

class MainMenuScreen extends StatelessWidget {
  static String routeName = '/main-menu';
  const MainMenuScreen({Key? key}) : super(key: key);

  void profile(BuildContext context){
    Navigator.pushNamed(context, ProfileScreen.routeName);
  }

  void lobbies(BuildContext context){
    Navigator.pushNamed(context, LobbiesScreen.routeName);
  }

  void lobby(BuildContext context){
    Navigator.pushNamed(context, LobbyScreen.routeName);
  }

  void leaderboard(BuildContext context){
    Navigator.pushNamed(context, LeaderboardScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // All are centered
          children: [
            SizedBox(
              height: 150,
              child: Image.asset('assets/images/bg_200_icon_ceng.png'),
            ),
            const SizedBox(height: 40,), // To separate buttons.
            CustomButton(
              onTap: () => profile(context),
              text: 'Profile',
            ),
            const SizedBox(height: 10,), // To separate buttons.
            CustomButton(
              onTap: () => lobbies(context),
              text: 'Show All Lobbies',
            ),
            const SizedBox(height: 10,), // To separate buttons.
            CustomButton(
              onTap: () => leaderboard(context),
              text: 'Leaderboard',
            ),

          ],
        ),
      ),
    );
  }
}
