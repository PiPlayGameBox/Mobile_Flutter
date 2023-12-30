import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
/*import 'package:socket_io_client/socket_io_client.dart' as IO;*/

String resp = '0';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

void _sendTCPRequest() async {
  try {
    // Create a new socket for each request
    Socket _socket = await Socket.connect('10.42.0.1', 8080);

    // Send a simple message to the server
    _socket.write('LOGIN|huseyin|123456');

    // Listen for responses from the server
    _socket.listen(
          (List<int> data) {
        // Convert the received data to a String
        String response = utf8.decode(data);

        // Update the UI with the received response
        print('Received from server: $response');

        List<String> parts = response.split('|');

        resp = parts[1];
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
// Resp rn: OK/B4_1|Y10_2|B13_1|K5_2|R4_1|R10_1|K11_2|B6_2|Y5_2|K9_2|K6_2|Y13_1|B12_1|B1_2|/E|E|E|E|/Y4_2|B7_2|47
void _sendTCPRequest2() async {
  try {
    // Create a new socket for each request
    Socket _socket = await Socket.connect('10.42.0.1', 8080);
    print(resp);
    // Send a simple message to the server
    _socket.write('GETGAMEBOARD|$resp|OKEY');

    // Listen for responses from the server
    _socket.listen(
          (List<int> data) {
        // Convert the received data to a String
        String response = utf8.decode(data);

        // Update the UI with the received response
        print('Received from server: $response');

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

class _MyHomePageState extends State<MyHomePage> {
/*  late IO.Socket socket;*/

  @override
  void initState() {
    super.initState();

  }
/*
  Future<void> initSocket() async {
    // Connect to the socket server
    socket = IO.io('http://localhost:12345', <String, dynamic>{
      'transports': ['websocket'],
    });

    // Listen for data from the server
    socket.on('connect', (_) {
      print('Connected to server');
      socket.emit('message', 'Hello, server!');
    });

    socket.on('message', (data) {
      print('Received data: $data');
      handleServerMessage(data);
    });
  }

  void handleServerMessage(String data) {
    // Parse the received message
    List<String> parts = data.split('|');
    if (parts.isNotEmpty && parts.first == 'OK') {
      String response = 'R${parts[1]}|R${parts[2]}|R${parts[3]}|${parts[4]}|E|Y${parts[6]}|Y${parts[7]}/';
      print('Sending response: $response');
      socket.emit('response', response);
    }
  }*/

  Future<void> sendMessageToServer() async {
    // Send a message to the server when the button is clicked
    String message = 'R9|R10|R11|R12|E|Y10|Y11/';
    print('Sending message: $message');
    _sendTCPRequest();
    /*socket.emit('message', message);*/
  }

  Future<void> sendMessageToServer2() async {
    // Send a message to the server when the button is clicked
    String message = 'R9';
    print('Sending message: $message');
    _sendTCPRequest2();
    /*socket.emit('message', message);*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Socket Client'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await sendMessageToServer();
              },
              child: Text('Send Message'),
            ),
            ElevatedButton(
              onPressed: () async {
                await sendMessageToServer2();
              },
              child: Text('Token: $resp'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Disconnect from the socket server when the app is closed
/*    socket.disconnect();*/
    super.dispose();
  }
}
/*
class _MyHomePageState extends State<MyHomePage> {
  List<List<String>> matrix =
      List.generate(2, (index) => List.filled(16, 'empty'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Okey input'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int row = 0; row < 2; row++)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int col = 0; col < 16; col++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 50,
                        height: 50,
                        color: matrix[row][col] == 'empty'
                            ? Colors.grey
                            : matrix[row][col] == 'R1'
                                ? Colors.red
                                : matrix[row][col] == 'Y1'
                                    ? Colors.yellow
                                    : Colors
                                        .blue, // Checks the matrix according to the color but this line will be very long for every tile.
                        child: Center(
                          child: Text(
                            matrix[row][col],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ElevatedButton(
              onPressed: () {
                updateMatrix();
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  void updateMatrix() {

    String exampleInput =
        'B10|B2|R1|R1|R1|R1|R1|empty|R1|Y1|R1|R1|R1|R1|R1|Y1|R1|R1|R1|R1|R1|R1|R1|empty|R1|R1|R1|R1|R1|R1|R1|R1|';

    // Parsing
    List<String> parts = exampleInput.split('|');

    int partIndex = 0;
    for (int row = 0; row < 2; row++) {
      for (int col = 0; col < 16; col++) {
        matrix[row][col] = parts[partIndex];
        partIndex++;
      }
    }

    setState(() {});
  }
}
*/