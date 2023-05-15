import "package:flutter/material.dart";

class dividerWidget extends StatelessWidget {
  const dividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1.0,
      color: Colors.yellowAccent,
      thickness: 1.0,
    );
  }
}
