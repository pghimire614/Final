import 'package:flutter/material.dart';
import 'package:shila/allscreen/signupmain.dart';
import 'Driver/loginscreen.dart';
import 'rider/loginscreen.dart';
class LoginMainScreen extends StatefulWidget {
  const LoginMainScreen({super.key});

  @override
  State<LoginMainScreen> createState() => _LoginMainScreenState();
}

class _LoginMainScreenState extends State<LoginMainScreen> {
  final _FormKey = GlobalKey<FormState>();
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
            "LOGIN PPAGE",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white60,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
            ),
          )),
      body: ListView(
         padding: const EdgeInsets.all(0),
         children :[
            Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              
              ElevatedButton(
                onPressed: () {
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => loginscreen()));
                  }
                },
                child: Text(
                  'Login as Rider',
                ),
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(
                    color: Colors.deepPurple,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19), // <-- Radius
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => loginscreenDriver()));
                  }
                },
                child: Text('Login as Driver'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19), // <-- Radius
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have  an account ?"),
                  TextButton(
                      onPressed: () {
                        {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen()));
                        }
                      },
                      child: Text(
                        "Sign up",
                      ))
                ],
              )
            ],
          ),
         ],
      ),
    );
  }
}
