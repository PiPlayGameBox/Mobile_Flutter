import 'package:ceng_mainpage/provider/room_data_provider.dart';
import 'package:ceng_mainpage/util/color.dart';
import 'package:ceng_mainpage/widget/custom_button.dart';
import 'package:ceng_mainpage/widget/custom_textfield.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';


class Lobby extends StatelessWidget {
  final VoidCallback onTap; // Func that changes the action onTap.
  final RoomData roomData;
  final String gameTypeS = 'Game type:';
  final String playerLobbyS = 'Players in lobby:';

  final TextEditingController passwordController;


  const Lobby({
    Key? key,
    required this.onTap,
    required this.roomData,
    required this.passwordController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white54,
            boxShadow:
            const [
              BoxShadow(
                color: Colors.black,
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(5, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: ExpandablePanel(
              header: Text(roomData.name, style: const TextStyle(fontWeight: FontWeight.bold),),
              collapsed: Column( // Room info.
                children: [
                  Text('$gameTypeS ${roomData.gameType}', softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
                ],
              ),
              expanded: Column( // Room info expanded.
                children: [
                  Text('$gameTypeS ${roomData.gameType}', softWrap: true,),
                  Text('$playerLobbyS ${roomData.players}', softWrap: true),
                  const SizedBox(height: 10,),
                  CustomTextField(controller: passwordController, hintText: 'Lobby password',),
                  const SizedBox(height: 5,),
                  Container(
                    alignment: Alignment.center,
                    child: CustomButton(
                      onTap: onTap,
                      text: 'Enter',

                    ),
                  ),
                ],
              ),
              theme: const ExpandableThemeData(
                iconColor: Colors.deepPurple,
                headerAlignment: ExpandablePanelHeaderAlignment.center,
              ),
            ),
          ),
        ),
    );
  }
}
