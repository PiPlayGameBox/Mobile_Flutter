import 'dart:convert';
import 'dart:io';

import 'package:ceng_mainpage/main.dart';
import 'package:ceng_mainpage/screens/CustomButton.dart';
import 'package:ceng_mainpage/screens/login_screen.dart';
import 'package:flutter/material.dart';

String registerSuccess = '';

class SignupScreen extends StatefulWidget {
  static String routeName = '/signup';

  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  String createRegisterRequestMessage(String username, String password){ // Login request string creater.

    String created = '';

    const String register = 'REGISTER|';

    created += register;

    created += username;

    created += '|';

    created += 'dorime.com';

    created += '|';

    created += password;

    return created;
  }

  void _sendRegisterRequest(String registerReq) async {
    try {
      // Create a new socket for each request
      Socket _socket = await Socket.connect(loginGlobals.piIP, 8080); // 127.0.0.1 ...... 10.42.0.1

      // Send a simple message to the server
      _socket.write(registerReq);

      // Listen for responses from the server
      _socket.listen(
            (List<int> data) {
          // Convert the received data to a String
          String response = utf8.decode(data);

          // Update the UI with the received response
          print('Received from server: $response');

          List<String> parts = response.split('|');

          setState(() {
            registerSuccess = parts[0];
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

  Future<bool> onSignUp() async {

    if (userNameController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username or password can not be empty."),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(seconds: 1));
      return false;
    }
    //setver

    _sendRegisterRequest(createRegisterRequestMessage(userNameController.text, passwordController.text));
    await Future.delayed(const Duration(seconds: 1));
    if (registerSuccess == "OK") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You are successfully signed up."),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("The username is already taken."),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(seconds: 1));
      return false;
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
                  image: const AssetImage('assets/images/add_user.png'),
                  width: size.width * 0.3,
                  height: size.width * 0.3,
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
                Text(
                  "Welcome",
                  style: TextStyle(
                      color: Colors.grey[750], fontSize: size.width * 0.05),
                ),
                Text(
                  "Fun is one step away!",
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
                      //errorText: isOk ? "error" : null,
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
                  height: size.height * 0.01,
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                CustomButton(
                    onPress: () async {
                      bool isSuccess = false;
                      //BusyIndicator().show(context);
                      isSuccess = await onSignUp();
                      //BusyIndicator().dismiss();
                      if (isSuccess) {
                        Future.delayed(const Duration(seconds: 1), () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen()));
                        });
                      }
                    },
                    buttonText: "Sign Up",
                    buttonColor: Colors.black,
                    buttonTextColor: Colors.white,
                    radius: size.width * 0.3,
                    screenSize: size),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
