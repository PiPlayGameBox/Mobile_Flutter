import 'package:ceng_mainpage/provider/room_data_provider.dart';
import 'package:ceng_mainpage/screen/leaderboard_screen.dart';
import 'package:ceng_mainpage/screen/lobbies_screen.dart';
import 'package:ceng_mainpage/screen/lobby_screen.dart';
import 'package:ceng_mainpage/screen/main_menu_screen.dart';
import 'package:ceng_mainpage/screen/profile_screen.dart';
import 'package:ceng_mainpage/screen/rummikub_screen.dart';
import 'package:ceng_mainpage/screens/login_screen.dart';
import 'package:ceng_mainpage/screens/signup_screen.dart';
import 'package:ceng_mainpage/screens/splash_screen.dart';
import 'package:ceng_mainpage/screens/welcome_screen.dart';
import 'package:ceng_mainpage/util/MyHomePage.dart';
import 'package:ceng_mainpage/util/color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Map<String, String> usersMap = {};
String userName = 'player1';
String profilePhoto = '0';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider( // Uses provider extension.
      create: (context) => RoomDataProvider(),
      child: MaterialApp(
        title: 'PiPlay',
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: bgColor, // BG at util.
        ),
        routes: {
          MainMenuScreen.routeName: (context) => const MainMenuScreen(),
          ProfileScreen.routeName: (context) => const ProfileScreen(),
          LobbiesScreen.routeName: (context) => const LobbiesScreen(),
          SplashScreen.routeName: (context) => const SplashScreen(),
          WelcomeScreen.routeName: (context) => const WelcomeScreen(),
          SignupScreen.routeName: (context) => const SignupScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          LobbyScreen.routeName: (context) => const LobbyScreen(),
          LeaderboardScreen.routeName: (context) => const LeaderboardScreen(),
          /*RummikubScreen.routeName: (context) => const RummikubScreen(),*/
        },
        initialRoute: LoginScreen.routeName,
      ),
    );
  }
}

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}*/
