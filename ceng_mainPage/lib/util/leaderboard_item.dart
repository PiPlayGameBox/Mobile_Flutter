import 'package:flutter/material.dart';
import 'package:ceng_mainpage/screen/main_menu_screen.dart';

class LeaderboardItem extends StatelessWidget {
  int placeInBoard;
  String userName;
  int ludoPoints;
  int okeyPoints;
  double height;
  double width;

  LeaderboardItem({
    super.key,
    required this.placeInBoard,
    required this.userName,
    required this.ludoPoints,
    required this.okeyPoints,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: () {
          if (placeInBoard == 1) {
            return const Color(0xfff4cd70);
          } else if (placeInBoard == 2) {
            return const Color(0xff62e4f2);
          } else if (placeInBoard == 3) {
            return const Color(0xfff88089);
          } else {
            return const Color(0xfffaab70);
          }
        }(),
        borderRadius: const BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: width * 0.01,
          ),
          Container(
            child: () {
              if (placeInBoard == 1) {
                return Image.asset(
                  "assets/images/gold-medal.png",
                  height: height * 0.75,
                  width: height * 0.75,
                );
              } else if (placeInBoard == 2) {
                return Image.asset(
                  "assets/images/silver-medal.png",
                  height: height * 0.75,
                  width: height * 0.75,
                );
              } else if (placeInBoard == 3) {
                return Image.asset(
                  "assets/images/bronze-medal.png",
                  height: height * 0.75,
                  width: height * 0.75,
                );
              } else {
                return SizedBox(
                    height: height * 0.75,
                    width: height * 0.75,
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Text(
                        placeInBoard.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xffaa3b22),
                            fontSize: height * 0.5),
                      ),
                    ));
              }
            }(),
          ),
          SizedBox(
            width: width * 0.02,
          ),
          Container(
            width: height * 0.6,
            height: height * 0.6,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xffe1ac3e), width: 2.0),
              borderRadius:
              BorderRadius.all(Radius.circular(height * 0.6 * 0.5)),
            ),
            child: Image.asset(mainMenuGlobals.picList[
            userName.hashCode % mainMenuGlobals.ICON_NUMBER]),
          ),
          SizedBox(
            width: width * 0.03,
          ),
          SizedBox(
            width: width * 0.2,
            child: Text(
              userName,
              //overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: () {
                    if (placeInBoard == 1) {
                      return const Color(0xffbf8700);
                    } else if (placeInBoard == 2) {
                      return const Color(0xff38a4d1);
                    } else if (placeInBoard == 3) {
                      return const Color(0xffd83a38);
                    } else {
                      return const Color(0xffdf653d);
                    }
                  }(),
                  fontSize: height * 0.25,
                  fontWeight: FontWeight.w700),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
              decoration: BoxDecoration(
                color: () {
                  if (placeInBoard == 1) {
                    return const Color(0xffffcb51);
                  } else if (placeInBoard == 2) {
                    return const Color(0xff56b2d7);
                  } else if (placeInBoard == 3) {
                    return const Color(0xffd9504e);
                  } else {
                    return const Color(0xffe47f5d);
                  }
                }(),
                borderRadius: const BorderRadius.all(Radius.circular(6.0)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: width * 0.15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/ludo.png",
                          height: height * 0.4,
                          width: width * 0.1,
                        ),
                        Text(
                          ludoPoints.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: height * 0.25,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width * 0.01,
                  ),
                  SizedBox(
                    width: width * 0.15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/okey.png",
                          height: height * 0.4,
                          width: width * 0.1,
                        ),
                        Text(
                          okeyPoints.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: height * 0.25,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: width*0.01,)
        ],
      ),
    );
  }
}
