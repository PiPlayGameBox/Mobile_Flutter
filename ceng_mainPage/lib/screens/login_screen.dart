import 'package:ceng_mainpage/main.dart';
import 'package:ceng_mainpage/screen/main_menu_screen.dart';
import 'package:ceng_mainpage/screens/CustomButton.dart';
import 'package:ceng_mainpage/screens/signup_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/login';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<bool> onSignIn() async {

    if (usersMap.containsKey(userNameController.text)) {
      if (usersMap[userNameController.text] == passwordController.text) {
        await Future.delayed(const Duration(seconds: 1));
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("The username or password is not correct."),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
        await Future.delayed(const Duration(seconds: 1));
        return false;
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("The username or password is not correct."),
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
                  "Log-In for fun!",
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
                      bool isSuccess = false;
                      isSuccess = await onSignIn();
                      if (isSuccess == true) {
                        // change screen
                        Future.delayed(const Duration(milliseconds: 30), () {
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                          const MainMenuScreen()), (Route<dynamic> route) => false);
                        });
                      }
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
