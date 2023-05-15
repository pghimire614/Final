
import 'package:flutter/material.dart';
import 'package:shila/button/splashservices.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
    static const String idScreen = "SplashScreen";


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashServices splashScreen = SplashServices();
  @override
  void initState() {
    super.initState();
    splashScreen.islogin(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/car.jpg'), fit: BoxFit.cover)),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    " WELCOME TO MERORIDE ",
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.blue,
                      //fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
