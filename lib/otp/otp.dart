import 'package:flutter/material.dart';
import '../button/round_button.dart';

class otp extends StatefulWidget {
  const otp({super.key});

  @override
  State<otp> createState() => _otpState();
}

class _otpState extends State<otp> {
  final phoneNumberController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter your phone no"),
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
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                hintText: "+9779807418573",
              ),
            ),
            SizedBox(
              height: 50,
            ),
            RoundButton(
                title: 'login',
                loading: loading,
                onTap: () {
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
