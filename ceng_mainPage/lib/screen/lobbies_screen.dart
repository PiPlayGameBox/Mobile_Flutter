import 'dart:convert';
import 'dart:io';

import 'package:ceng_mainpage/provider/LudoKing.dart';
import 'package:ceng_mainpage/provider/room_data_provider.dart';
import 'package:ceng_mainpage/provider/rummikub_data_provider.dart';
import 'package:ceng_mainpage/responsive/responsive.dart';
import 'package:ceng_mainpage/screen/ludo_screen.dart';
import 'package:ceng_mainpage/screen/rummikub_screen.dart';
import 'package:ceng_mainpage/util/color.dart';
import 'package:ceng_mainpage/widget/custom_text.dart';
import 'package:ceng_mainpage/widget/lobby.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String respToken = '0';

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
    _sendTCPRequest();
  }

  void _sendTCPRequest() async {
    try {
      // Create a new socket for each request
      Socket _socket = await Socket.connect('127.0.0.1', 8080);

      // Send a simple message to the server
      _socket.write('LOGIN|huseyin|123456');

      // Listen for responses from the server
      _socket.listen(
            (List<int> data) {
          // Convert the received data to a String
          String response = utf8.decode(data);

          // Update the UI with the received response
          print('Received from server: $response');

          List<String> parts = response.split('|');

          setState(() {
            respToken = parts[1];
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
                Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Lobby(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LudoScreen(/*token: respToken,*/)),
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
                            builder: (context) => RummikubScreen(token: respToken,), /*{
                              return FutureBuilder(
                                future: Provider.of<RummikubDataProvider>(context).fetchData(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    // If the future is still running, show a loading indicator or any other widget
                                    return const CircularProgressIndicator(backgroundColor: bgColor,);
                                  } else {
                                    // If the future is complete, navigate to the RummikubScreen
                                    List<RummikubData> fData = Provider.of<RummikubDataProvider>(context).fData;
                                    return RummikubScreen();
                                  }
                                },
                              );
                            },*//*=> const RummikubScreen()),*/
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
