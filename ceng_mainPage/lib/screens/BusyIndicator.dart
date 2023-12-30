import 'package:flutter/material.dart';

class BusyIndicator {
  static final BusyIndicator _singleton = BusyIndicator._internal();
  late BuildContext _context;
  bool isDisplayed = false;

  factory BusyIndicator() {
    return _singleton;
  }

  BusyIndicator._internal();

  show(BuildContext context, {String text = 'Loading...'}) {
    if (isDisplayed) {
      return;
    }
    showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _context = context;
          isDisplayed = true;
          return const PopScope(
            child: SimpleDialog(
              backgroundColor: Colors.white,

              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: 8, top: 16, right: 8, bottom: 16),
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(16),
                      //   child: Text(text),
                      // )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  dismiss() {
    if (isDisplayed) {
      Navigator.of(_context).pop();
      isDisplayed = false;
    }
  }
}
