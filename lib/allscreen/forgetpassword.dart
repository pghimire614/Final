
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shila/allscreen/constants.dart';

import '../button/round_button.dart';
import 'mainlogin.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();

  void submit(){
    firebaseAuth.sendPasswordResetEmail(email: emailController.text.trim()).then((value) {Fluttertoast.showToast(msg: "we have sent you an email  to recover password, please check email");}).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: "Error Occured: ${error.toString()}");
    });
  }
  // AuthServicesR authServices = AuthServicesR();
  // void forgetpass() {
  //   authServices.forgetPassword(context: context, email: emailController.text);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () =>    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>  LoginMainScreen() )),
          ),
        ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            SizedBox(
              height: 10
            ),
            Center(child: Image.asset("images/logo.png")),
            Text(
              "Forgot password",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, fontFamily:"Brand semibold" ),
            ),
            SizedBox(
              height: 2,
            ), Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: emailController,
             inputFormatters: [LengthLimitingTextInputFormatter(100)],
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16)),
                  hintText: 'bob@gmail.com'),
            ),
            SizedBox(
              height: 40,
            ),
            RoundButton(
                title: 'Forgot',
                onTap: () {
              submit();
                })
          ],
        ),
      ),
    ],
          ),
      ),),);
  }
}
