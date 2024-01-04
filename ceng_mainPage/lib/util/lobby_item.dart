import 'package:flutter/material.dart';

class LobbyItemGlobals {
  static int joinedLobby = -1;
  static String lobbyPass = '';
}

class LobbyItem extends StatefulWidget {
  double itemWidth;
  double itemHeight;
  String lobbyName;
  String playerOneName = "ahmet";
  String playerTwoName = "mert";
  String playerThreeName = "doruk";
  int lobbyNumber;

  LobbyItem({
    super.key,
    required this.itemWidth,
    required this.itemHeight,
    required this.lobbyName,
    required this.lobbyNumber,
    required this.playerOneName,
    required this.playerTwoName,
    required this.playerThreeName,
  });

  @override
  State<LobbyItem> createState() => _LobbyItemState();
}

class _LobbyItemState extends State<LobbyItem> {
  late TextEditingController textEditingController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController = TextEditingController();
    build(context);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.itemWidth,
      height: widget.itemHeight,
      child: Column(
        children: [
          Container(
            width: widget.itemWidth,
            height: (widget.itemHeight - widget.itemWidth) * 0.9,
            decoration: const BoxDecoration(
              // border: Border.all(color: Colors.black, width: 3),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Color(0xff004c5f),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: widget.itemHeight * 0.15,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Colors.red,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      width: widget.itemHeight * 0.15,
                      height: widget.itemHeight * 0.15,
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.all(
                          Radius.circular(widget.itemHeight * 0.15 * 0.5),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          widget.lobbyNumber.toString(),
                          style: TextStyle(
                            fontSize: widget.itemHeight * 0.10 * 0.8,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: widget.itemWidth * 0.08,
                ),
                Text(
                  widget.lobbyName,
                  style: TextStyle(
                      fontSize:
                      (widget.itemHeight - widget.itemWidth) * 0.9 * 0.4,
                      color: Colors.white),
                ),
                Spacer(),
                Icon(
                  Icons.password,
                  color: Colors.white,
                  size: widget.itemHeight * 0.10,
                ),
                SizedBox(
                  width: widget.itemWidth * 0.06,
                ),
              ],
            ),
          ),
          SizedBox(height: (widget.itemHeight - widget.itemWidth) * 0.06),
          Container(
            width: widget.itemWidth,
            height: widget.itemWidth,
            child: Stack(
              children: [
                Positioned(
                  top: widget.itemWidth * 0.1,
                  left: widget.itemWidth * 0.1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/images/wooden_board.png",
                      height: widget.itemWidth * 0.8,
                      width: widget.itemWidth * 0.8,
                    ),
                  ),
                ),

                // top player
                Positioned(
                  top: 0.0,
                  left: widget.itemWidth * 0.35,
                  child: GestureDetector(
                    onTap: (LobbyItemGlobals.joinedLobby == -1)
                        ? () {
                      setState(() async {
                        var password = await openDialog();
                        if (password == null || password.isEmpty) return;

                        LobbyItemGlobals.joinedLobby = widget.lobbyNumber;
                        LobbyItemGlobals.lobbyPass = password;
                      });
                    }
                        : () {
                      setState(() {
                        if (LobbyItemGlobals.joinedLobby ==
                            widget.lobbyNumber) {
                          LobbyItemGlobals.joinedLobby = -1;
                        }
                      });
                    },
                    child: Container(
                      width: widget.itemWidth * 0.3,
                      height: widget.itemWidth * 0.3,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.orange, width: 5.0),
                          borderRadius: BorderRadius.all(
                              Radius.circular(widget.itemWidth * 0.3 * 0.5)),
                          color: Colors.black87),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child:
                        (LobbyItemGlobals.joinedLobby != widget.lobbyNumber)
                            ? const FittedBox(
                          fit: BoxFit.contain,
                          child: Text(
                            "PLAY",
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
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
                ),

                // right player
                Positioned(
                  top: widget.itemHeight * 0.27,
                  right: 0.0,
                  child: Container(
                    width: widget.itemWidth * 0.3,
                    height: widget.itemWidth * 0.3,
                    decoration: BoxDecoration(
                        border:
                        Border.all(color: Color(0xff0E77F2), width: 5.0),
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.itemWidth * 0.3 * 0.5)),
                        color: const Color(0xff04203f)),
                    child: Image.asset("assets/images/fox.png"),
                  ),
                ),

                // bottom player
                Positioned(
                  bottom: 0.0,
                  left: widget.itemWidth * 0.35,
                  child: Container(
                    width: widget.itemWidth * 0.3,
                    height: widget.itemWidth * 0.3,
                    decoration: BoxDecoration(
                        border:
                        Border.all(color: Color(0xff0E77F2), width: 5.0),
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.itemWidth * 0.3 * 0.5)),
                        color: const Color(0xff04203f)),
                    child: Image.asset("assets/images/fox.png"),
                  ),
                ),

                // left player
                Positioned(
                  top: widget.itemHeight * 0.27,
                  left: 0.0,
                  child: Container(
                    width: widget.itemWidth * 0.3,
                    height: widget.itemWidth * 0.3,
                    decoration: BoxDecoration(
                        border:
                        Border.all(color: Color(0xff0E77F2), width: 5.0),
                        borderRadius: BorderRadius.all(
                            Radius.circular(widget.itemWidth * 0.3 * 0.5)),
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

  Future<String?> openDialog() => showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Password"),
      content: TextField(
        autofocus: true,
        decoration: const InputDecoration(hintText: "Enter lobby password"),
        controller: textEditingController,
        onSubmitted: (_) => passwordEntered(),
      ),
      actions: [
        TextButton(onPressed: passwordEntered, child: Text("ENTER"))
      ],
    ),
  );

  void passwordEntered() {
    Navigator.of(context).pop(textEditingController.text);
    textEditingController.clear();
  }
}
