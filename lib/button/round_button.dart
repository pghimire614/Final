import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;
  const RoundButton(
      {Key? key,
      required this.title,
      required this.onTap,
      this.loading = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 50,
        width: 380,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 227, 9, 9),
            borderRadius: BorderRadius.circular(18)),
        child: Center(
          child: loading
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
        ),
      ),
    );
  }
}
