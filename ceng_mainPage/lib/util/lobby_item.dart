import 'package:flutter/material.dart';

class LobbyItem extends StatelessWidget {
  double itemWidth;
  double itemHeight;
  String lobbyName;
  String playerOneName = "ahmet";
  String playerTwoName = "mert";
  String playerThreeName = "doruk";
  bool amIJoined = true;
  int lobbyNumber;

  LobbyItem(
      {super.key,
      required this.itemWidth,
      required this.itemHeight,
      required this.lobbyName,
      required this.lobbyNumber,
      required this.playerOneName,
      required this.playerTwoName,
      required this.playerThreeName,
      required this.amIJoined});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: itemWidth,
      height: itemHeight,
      child: Column(
        children: [
          Container(
            width: itemWidth,
            height: (itemHeight - itemWidth) * 0.9,
            decoration: const BoxDecoration(
              // border: Border.all(color: Colors.black, width: 3),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0xff004c5f),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: itemHeight * 0.15,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.red,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      width: itemHeight * 0.15,
                      height: itemHeight * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(itemHeight * 0.15 * 0.5),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          lobbyNumber.toString(),
                          style: TextStyle(
                            fontSize: itemHeight * 0.10 * 0.8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: itemWidth * 0.08,
                ),
                Text(
                  lobbyName,
                  style: TextStyle(
                      fontSize: (itemHeight - itemWidth) * 0.9 * 0.4,
                      color: Colors.white),
                ),
                Spacer(),
                Icon(
                  Icons.password,
                  color: Colors.white,
                  size: itemHeight * 0.10,
                ),
                SizedBox(
                  width: itemWidth * 0.06,
                ),
              ],
            ),
          ),
          SizedBox(height: (itemHeight - itemWidth) * 0.06),
          Container(
            width: itemWidth,
            height: itemWidth,
            child: Stack(
              children: [
                Positioned(
                  top: itemWidth * 0.1,
                  left: itemWidth * 0.1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/images/wooden_board.png",
                      height: itemWidth * 0.8,
                      width: itemWidth * 0.8,
                    ),
                  ),
                ),

                // top player
                Positioned(
                  top: 0.0,
                  left: itemWidth * 0.35,
                  child: Container(
                    width: itemWidth * 0.3,
                    height: itemWidth * 0.3,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.orange, width: 5.0),
                        borderRadius: BorderRadius.all(
                            Radius.circular(itemWidth * 0.3 * 0.5)),
                        color: Colors.black87),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: !amIJoined
                          ? const FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                "PLAY",
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,),
                              ),
                            )
                          : const FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                "LEAVE",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                  ),
                ),

                // right player
                Positioned(
                  top: itemHeight * 0.27,
                  right: 0.0,
                  child: Container(
                    width: itemWidth * 0.3,
                    height: itemWidth * 0.3,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xff0E77F2), width: 5.0),
                        borderRadius: BorderRadius.all(
                            Radius.circular(itemWidth * 0.3 * 0.5)),
                        color: const Color(0xff04203f)),
                    child: Image.asset("assets/images/fox.png"),
                  ),
                ),

                // bottom player
                Positioned(
                  bottom: 0.0,
                  left: itemWidth * 0.35,
                  child: Container(
                    width: itemWidth * 0.3,
                    height: itemWidth * 0.3,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xff0E77F2), width: 5.0),
                        borderRadius: BorderRadius.all(
                            Radius.circular(itemWidth * 0.3 * 0.5)),
                        color: const Color(0xff04203f)),
                    child: Image.asset("assets/images/fox.png"),
                  ),
                ),

                // left player
                Positioned(
                  top: itemHeight * 0.27,
                  left: 0.0,
                  child: Container(
                    width: itemWidth * 0.3,
                    height: itemWidth * 0.3,
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: Color(0xff0E77F2), width: 5.0),
                        borderRadius: BorderRadius.all(
                            Radius.circular(itemWidth * 0.3 * 0.5)),
                        color: const Color(0xff04203f)),
                    child: Image.asset("assets/images/fox.png"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
