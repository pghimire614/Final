import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shila/allscreen/constants.dart';
import 'package:shila/button/profilescreen.dart';
import 'package:shila/models/allUsers.dart';
import '../allscreen/mainlogin.dart';
import '../button/Divider.dart';

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
                height: 180.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: 
                      Column(
                
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Center(
                             child: Image.asset(
                                                   "images/user_icon.png",
                                                   height: 80.0,
                                                   width: 80.0,
                                                 ),
                           ),
                      SizedBox(
                        height: 10,
                        width: 20.0,
                      ),
  
                          Center(
                            //child: Text((userCurrentInfo!.name!),
                              //style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
                           // ),
                          ),
                          SizedBox(
                            height: 6.0,
                          ),
                          GestureDetector(
                            onTap: () {
                                          Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => profilescreen()),);
                              
                            },
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold, color: Colors.blue),
                            ),
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
                title: Text(
                  "History",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
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
                  "Payment",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
                 ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  "Help",
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
                                    MaterialPageRoute(
                                        builder: (context) => LoginMainScreen()),);

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
