import 'dart:convert';
import 'dart:io';

import 'package:ceng_mainpage/main.dart';
import 'package:ceng_mainpage/screen/lobbies_screen.dart';
import 'package:ceng_mainpage/screen/main_menu_screen.dart';
import 'package:ceng_mainpage/screens/CustomButton.dart';
import 'package:ceng_mainpage/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class loginGlobals{

  static String username = '';
  static String password = '';
  static String token = 'empty';
  static const String piIP = '10.42.0.1';

}


class LoginScreen extends StatefulWidget {
  static String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  String loginSuccess = 'ERROR';
  String loginMessage = 'Log-In for fun!';

  @override
  void initState() {
    super.initState();
  }

  String createLoginRequestMessage(String username, String password){ // Login request string creater.

    String created = '';

    const String login = 'LOGIN|';

    created += login;

    created += username;

    created += '|';

    created += password;

    return created;
  }

  void _sendLoginRequest(String loginReq) async {
    try {
      // Create a new socket for each request
      Socket _socket = await Socket.connect(loginGlobals.piIP, 8080); // 127.0.0.1 ...... 10.42.0.1

      // Send a simple message to the server
      _socket.write(loginReq);

      // Listen for responses from the server
      _socket.listen(
            (List<int> data) {
          // Convert the received data to a String
          String response = utf8.decode(data);

          // Update the UI with the received response
          print('Received from server: $response');

          List<String> parts = response.split('|');

          setState(() {
            loginSuccess = parts[0];
            loginGlobals.token = parts[1];

            if(loginSuccess == 'OK'){
              loginGlobals.username = userNameController.text;
              loginGlobals.password = passwordController.text;
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MainMenuScreen()),
              );
            }else if(loginSuccess == 'ERROR'){
              loginMessage = 'Invalid username or password!';
            }else{ // Unexpected error.
              loginMessage = 'Invalid!';
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                // logo
                Image(
                  image: const AssetImage('assets/images/user.png'),
                  width: size.width * 0.3,
                  height: size.width * 0.3,
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                      color: Colors.grey[750], fontSize: size.width * 0.05),
                ),
                Text(
                  loginMessage,
                  style: TextStyle(
                      color: Colors.grey[750], fontSize: size.width * 0.05),
                ),
                SizedBox(
                  height: size.height * 0.1,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                  child: TextField(
                    controller: userNameController,
                    obscureText: false,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.person),
                      hintText: "Username",
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      // errorText: widget.errorText,
                      // errorStyle: const TextStyle(
                      //     fontSize: 15, color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.08),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      hintText: "Password",
                      enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12)),
                      fillColor: Colors.grey.shade200,
                      filled: true,
                      errorStyle: const TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                CustomButton(
                    onPress: () async {
                      String inputUsername = userNameController.text;
                      String inputPassword = passwordController.text;

                      _sendLoginRequest(createLoginRequestMessage(inputUsername, inputPassword));
                    },
                    buttonText: "Sign In",
                    buttonColor: Colors.black,
                    buttonTextColor: Colors.white,
                    radius: size.width * 0.3,
                    screenSize: size),
                SizedBox(height: size.height * 0.02),
                const Divider(),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Not registered before?"),
                    const SizedBox(
                      width: 4,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()),
                        );
                      },
                      child: const Text(
                        "Register now",
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
