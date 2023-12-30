import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  static String routeName = '/welcome';

  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text("Welcome"),
      ),
    );
  }
}
