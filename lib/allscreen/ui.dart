import 'package:flutter/material.dart';

import 'package:shila/allscreen/rider/map.dart';

class ui extends StatefulWidget {
  const ui({super.key});
  static const String idScreen = "ui";
  @override
  State<ui> createState() => _uiState();
}

class _uiState extends State<ui> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mero Ride",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: Color.fromARGB(255, 246, 240, 185),
      body: Column(
        children: [
          Center(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: GestureDetector(
                    onTap: () {
                      print("hello");
                    }, // Image tapped
                    child: Image.asset(
                      "images/logo1.png",
                      // fit: BoxFit.cover, // Fixes border issues
                      width: 120,
                      height: 120,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: GestureDetector(
                    onTap: () {
                      print("hello");
                    }, // Image tapped
                    child: Image.asset(
                      "images/bike.png",
                      // fit: BoxFit.cover, // Fixes border issues
                      width: 150,
                      height: 150,
                    ),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, map.idScreen, (route) => false);
            },
            child: Text(
              "pickup location",
              style: TextStyle(
                  color: Colors.black, fontSize: 20, fontFamily: "Brand black"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, map.idScreen, (route) => false);
            },
            child: Text(
              "pickup location",
              style: TextStyle(
                  color: Colors.black, fontSize: 20, fontFamily: "Brand black"),
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Text("find a driver")),
        ],
      ),
    );
  }
}
