import 'package:ceng_mainpage/main.dart';
import 'package:ceng_mainpage/responsive/responsive.dart';
import 'package:ceng_mainpage/widget/custom_button.dart';
import 'package:ceng_mainpage/widget/custom_textfield.dart';
import 'package:flutter/material.dart';

import '../widget/custom_text.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = '/profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  String displayText = userName;

  // To prevent memory leaks.
  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        child: Container(
          margin: const EdgeInsets.symmetric(
              // Symmetric in-sets.
              horizontal: 20
          ),
          child: Container(
            child: Column(
              // Children alligned to start.
              mainAxisAlignment: MainAxisAlignment.start,
              // Text center allignment.
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomText(
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black54,
                    )
                  ],
                  text: 'Profile',
                  fontSize: 50,
                ),
        
                Column( // Change nickname part.
                  children: [
                    const SizedBox(height: 20,),
                    Container(
                      child: SizedBox(
                        height: 150,
                        child: Image.asset('assets/images/profile1.jpg'),
                      ),
                    ),
                    const SizedBox(height: 50,),
                    Text(
                      displayText,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 50,),
                    CustomTextField(controller: _nameController, hintText: 'Write your new nickname here',),
                    const SizedBox(height: 10,),
                    CustomButton(onTap: (){
                      setState(() {
                        displayText = _nameController.text;
                        userName = displayText;
                      });
                      }, text: 'Change'
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
