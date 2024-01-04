import 'dart:convert';
import 'dart:io';

import 'package:ceng_mainpage/provider/room_data_provider.dart';
import 'package:ceng_mainpage/provider/rummikub_data_provider.dart';
import 'package:ceng_mainpage/responsive/responsive.dart';
import 'package:ceng_mainpage/screen/ludo_screen.dart';
import 'package:ceng_mainpage/screen/rummikub_screen.dart';
import 'package:ceng_mainpage/screens/login_screen.dart';
import 'package:ceng_mainpage/util/color.dart';
import 'package:ceng_mainpage/widget/custom_text.dart';
import 'package:ceng_mainpage/widget/lobby.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String usernameToken = 'huseyin';
String printResponseLogin = '';

class LobbiesScreen extends StatefulWidget {
  static String routeName = '/lobbies';

  const LobbiesScreen({super.key});

  void ludo(BuildContext context){
    Navigator.pushNamed(context, LobbiesScreen.routeName);
  }

  @override
  State<LobbiesScreen> createState() => _LobbiesScreenState();
}

class _LobbiesScreenState extends State<LobbiesScreen> {
  final TextEditingController _passwordController1 = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final TextEditingController _passwordController3 = TextEditingController();
  // Can be implemented as radio buttons but if two loby has same password,
  // user will sign in to same lobby, must me implemented with backend.

  @override
  void initState() {
    super.initState();
  }

  // To prevent memory leaks.
  @override
  void dispose() {
    super.dispose();
    _passwordController1.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(
                // Symmetric in-sets.
                horizontal: 20),
            child: Column(
              // Children aligned to start.
              mainAxisAlignment: MainAxisAlignment.start,
              // Text center alignment.
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomText(
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black54,
                    )
                  ],
                  text: 'Lobbies',
                  fontSize: 50,
                ),
                CustomText(
                  text: printResponseLogin,
                  fontSize: 50, shadows: [],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Lobby(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LudoScreen(token: loginGlobals.token,playerInfo: {'r':'huseyin', 'g':'doruk', 'y':'abdullah', 'B':'samet'},)),
                      ),
                      roomData: RoomData(
                        'Lobby1','LUDO','pass123',['p1','p2','Cool player B)']
                      ),
                      passwordController: _passwordController1,
                    ),
                    Lobby(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RummikubScreen(token: loginGlobals.token,userName: loginGlobals.username),
                        ),
                      ),
                      roomData: RoomData(
                          'Elite Lobby','OKEY','elite2001',['Max Verstappen']
                      ),
                      passwordController: _passwordController2,
                    ),
                    Lobby(
                      onTap: () {},
                      roomData: RoomData(
                          'Do Not Get Angry','LUDO','grr123',['Bruce Banner','Donald Duck','Squidward']
                      ),
                      passwordController: _passwordController3,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
