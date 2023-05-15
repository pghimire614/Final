import 'package:flutter/material.dart';

class button extends StatelessWidget {
  button({super.key, required this.title, required this.click});
  String title;
  VoidCallback click;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 300,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 9, 29, 46),
      ),
      child: Text(
        title,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
