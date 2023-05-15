
import 'package:flutter/material.dart';

import '../button/round_button.dart';
class verifycode extends StatefulWidget {
  final String verificationId;
  const verifycode({super.key, required this.verificationId});

  @override
  State<verifycode> createState() => _verifycodeState();
}

class _verifycodeState extends State<verifycode> {
  final phoneNumberController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("verify"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: "verify your phone",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16))),
            ),
            SizedBox(
              height: 50,
            ),
            RoundButton(
                title: 'Verify',
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });
                })
          ],
        ),
      ),
    );
  }
}
