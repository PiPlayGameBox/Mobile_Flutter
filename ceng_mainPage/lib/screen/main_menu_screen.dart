import 'package:ceng_mainpage/screen/leaderboard_screen.dart';
import 'package:ceng_mainpage/screen/lobbies_screen.dart';
import 'package:ceng_mainpage/screen/lobby_screen.dart';
import 'package:ceng_mainpage/screen/profile_screen.dart';
import 'package:ceng_mainpage/screens/login_screen.dart';
import 'package:ceng_mainpage/widget/custom_imagebanner.dart';
import 'package:ceng_mainpage/widget/custom_text.dart';
import 'package:flutter/material.dart';

import '../responsive/responsive.dart';
import '../widget/custom_button.dart';

class mainMenuGlobals{
  static List<String> picList = [
    "assets/images/fox.png",
    "assets/images/frog.png",
    "assets/images/monkey.png",
    "assets/images/owl.png",
  ];
  static int ICON_NUMBER = picList.length;
}


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
              child: Image.asset(mainMenuGlobals.picList[
              loginGlobals.username.hashCode % mainMenuGlobals.ICON_NUMBER]),
            ),
            const SizedBox(height: 20,), // To separate buttons.
            Text(
              loginGlobals.username.toUpperCase(),
              style: TextStyle(
                color: Colors.grey[750],
                fontSize: 30,
                fontWeight: FontWeight.bold, // Add fontWeight if desired
                letterSpacing: 1.5, // Adjust the letter spacing
                shadows: const [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(2, 2), // Adjust the shadow offset
                    blurRadius: 1, // Adjust the blur radius
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,), // To separate buttons.
            CustomButton(
              onTap: () => lobby(context),
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
