// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:shila/allscreen/trips_history_screen.dart';

// import '../../button/Divider.dart';
// import '../mainlogin.dart';

// class drawer extends StatelessWidget {
//   const drawer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: Colors.white,
//         width: 255.0,
//         child: Drawer(
//           child: ListView(
//             children: [
//               Container(
//                 height: 165.0,
//                 child: DrawerHeader(
//                   decoration: BoxDecoration(color: Colors.white),
//                   child: Row(
//                     children: [
//                       Image.asset(
//                         "images/user_icon.png",
//                         height: 65.0,
//                         width: 65.0,
//                       ),
//                       SizedBox(
//                         width: 16.0,
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             "profile Name",
//                             style: TextStyle(fontSize: 16.0),
//                           ),
//                           SizedBox(
//                             height: 6.0,
//                           ),
//                           Text(
//                             "visit Profile",
//                             style: TextStyle(fontSize: 16.0),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               dividerWidget(),
//               SizedBox(
//                 height: 12.0,
//               ),
//               ListTile(
//                 leading: Icon(Icons.history),
//                 title: GestureDetector(
//                   onTap: (){
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=> TripHistory()));
//                   },
//                   child: Text(
//                     "History",
//                     style: TextStyle(
//                         color: Colors.blue,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20),
//                   ),
//                 ),
//               ),
//               ListTile(
//                 leading: Icon(Icons.people),
//                 title: Text(
//                   "Visit profile",
//                   style: TextStyle(
//                       color: Colors.blue,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20),
//                 ),
//               ),
//               ListTile(
//                 leading: Icon(Icons.info),
//                 title: Text(
//                   "About",
//                   style: TextStyle(
//                       color: Colors.blue,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20),
//                 ),
//               ),

//             //SizedBox( height: 400,),
//                GestureDetector(
//                 onTap: () {
//                   FirebaseAuth.instance.signOut();
//                              Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => LoginMainScreen()),);

//                 },
//                  child: ListTile(
//                   leading: Icon(Icons.info),
//                   title: Text(
//                     "SignOut",
//                     style: TextStyle(
//                         color: Colors.red,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20),
//                   ),
//                              ),
//                ),
//             ],
//           ),
//         ),
//       );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shila/allscreen/constants.dart';
import 'package:shila/allscreen/trips_history_screen.dart';

import '../../button/Divider.dart';
import '../mainlogin.dart';

class drawer extends StatelessWidget {
  const drawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 255.0,
      child: Drawer(
        child: ListView(
          children: [
            Container(
              height: 165.0,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  children: [
                    Image.asset(
                      "images/user_icon.png",
                      height: 65.0,
                      width: 65.0,
                    ),
                    SizedBox(
                      width: 16.0,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "profile Name",
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(
                          height: 6.0,
                        ),
                        Text(
                          "visit Profile",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            dividerWidget(),
            SizedBox(
              height: 12.0,
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TripHistoryScreen()));
                },
                child: Text(
                  "History",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text(
                "Visit profile",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(
                "About",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),

            //SizedBox( height: 400,),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginMainScreen()),
                );
              },
              child: ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  "SignOut",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
