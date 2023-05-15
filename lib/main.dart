import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shila/DataHandeler/appData.dart';
import 'package:shila/allscreen/OrderTrackingPaage.dart';
import 'package:shila/allscreen/rider/loginscreen.dart';
import 'package:shila/allscreen/rider/map.dart';
import 'package:shila/allscreen/rider/rider.dart';
import 'package:shila/allscreen/rider/signup.dart';
import 'package:shila/allscreen/ui.dart';
import 'package:shila/button/splash.dart';

Future<void> main() async {
  //it may be void in future which is necessary for firebase initialization   ..asynchronous operation that does not return a value,
  WidgetsFlutterBinding
      .ensureInitialized(); // first   we need to initialization of firebase in order to store data on it
  await Firebase.initializeApp();
  runApp(app());
}

DatabaseReference usersRef = FirebaseDatabase.instance
    .ref()
    .child("rider"); //creating a node in database with name rider
DatabaseReference usersRefR = FirebaseDatabase.instance.ref().child("driver");

class app extends StatefulWidget {
  const app({super.key});

  @override
  State<app> createState() => _appState();
}

class _appState extends State<app> {
  @override
  Widget build(BuildContext context) {
    return //provider is desfined here to make data accessible through all pages
        ChangeNotifierProvider(
      //initialization of data
      create: (BuildContext context) =>
          AppData(), //for accessing the data over all pages
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "hello",
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),

        initialRoute: SplashScreen.idScreen,
        // FirebaseAuth.instance.currentUser == null?SplashScreen.idScreen : LoginMainScreen,
        routes: {
          signup.idScreen: (context) => signup(),
          loginscreen.idScreen: (context) => loginscreen(),
          SplashScreen.idScreen: (context) => SplashScreen(),
          map.idScreen: (context) => map(),
          ui.idScreen: (context) => ui(),
          rider.idScreen: (context) => rider(),
          OrderTrackingPage.idScreen: (context) => OrderTrackingPage(),
          //SearchScreen.idScreen:(context) => SearchScreen()
        },
      ),
    );
  }
}
