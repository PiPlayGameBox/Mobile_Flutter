import 'package:ceng_mainpage/main.dart';
import 'package:ceng_mainpage/widget/custom_button.dart';
import 'package:ceng_mainpage/widget/custom_textfield.dart';
import 'package:flutter/material.dart';

import '../widget/custom_text.dart';

// Image.asset('assets/images/profile1.jpg')
/*Text(
displayText,
style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
)*/

class ProfileScreen extends StatefulWidget {
  static String routeName = '/profile';
  const ProfileScreen({super.key, this.username="Doruk"}); // TODO: make real

  final String username;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _passAgainController = TextEditingController();

  // To prevent memory leaks.
  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _passController.dispose();
    _passAgainController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Profile"),
          backgroundColor: Colors.black45,
        ),
        body: LayoutBuilder(
            builder: (context, constraints) {
              double mW=constraints.maxWidth;
              double mH=constraints.maxHeight;


              return Center(
                  child: Column(
                    children: [
                      // space
                      SizedBox(height: 30, /*width: mW*/),
                      // Username text
                      Text(widget.username),
                      // space
                      SizedBox(height: 10),
                      // Avatar
                      Image(
                        //backgroundColor: Colors.amber,
                          image: AssetImage("assets/images/blue_pawn.png"),
                          //radius: (mW/4)-10,
                          height: mW/4,
                          fit: BoxFit.contain
                      ),
                      // space
                      SizedBox(height: 30),


                      // NewUsername text
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: mW/8),
                            child: Text("New username:"),
                          )
                      ),
                      // space
                      SizedBox(height: 4),
                      // NewUsernameField
                      SizedBox(
                        width: mW*(3/4),
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                            helperText: "",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      // space
                      SizedBox(height: 4),


                      // NewUsername text
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: mW/8),
                            child: Text("New password:"),
                          )
                      ),
                      // space
                      SizedBox(height: 4),
                      // NewUsernameField
                      SizedBox(
                        width: mW*(3/4),
                        child: TextField(
                          obscureText: true,
                          controller: _passController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                            helperText: "",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      // space
                      SizedBox(height: 4),


                      // NewUsername text
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: mW/8),
                            child: Text("New password again:"),
                          )
                      ),
                      // space
                      SizedBox(height: 4),
                      // NewUsernameField
                      SizedBox(
                        width: mW*(3/4),
                        child: TextField(
                          obscureText: true,
                          controller: _passAgainController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                            helperText: "",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      // space
                      SizedBox(height: 4),


                      // Apply button
                      SizedBox(
                        width: 100,
                        child: FloatingActionButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(30))),
                            onPressed: () {}, // TODO: implement
                            child: Text("Apply")
                        ),
                      ),
                      SizedBox(height: 20)
                    ],
                  )
              );
            }
        )
    );
  }
}
