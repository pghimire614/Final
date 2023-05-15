
import 'package:flutter/material.dart';
//import 'package:shila/allscreen/rider/signup.dart';

import 'Driver/signup.dart';
//import 'mainlogin.dart';
import 'mainlogin.dart';
import 'rider/signup.dart';


class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  //final _FormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "SIGNNUPPAGE",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white60,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => signup()));
                }
              },
              child: Text(
                'Signup as Rider',
              ),
              style: ElevatedButton.styleFrom(
                textStyle: TextStyle(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // <-- Radius
                ),
              ),
            ),
            SizedBox(
              height: 35,
            ),
            ElevatedButton(
              onPressed: () {
                {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => signupdriver()));
                }
              },
              child: Text('Signup as Driver'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15), // <-- Radius
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have  an account ?"),
                TextButton(
                    onPressed: () {
                      {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginMainScreen()));
                      }
                    },
                    child: Text(
                      "Login",
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
