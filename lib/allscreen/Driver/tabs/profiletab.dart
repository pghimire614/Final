import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shila/allscreen/global/global.dart';
import 'package:shila/button/splash.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({super.key});

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  final nameTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  DatabaseReference userRef = FirebaseDatabase.instance.ref().child("drivers");

  Future<void> showDriverNameDialogAlert(BuildContext contect, String name) {
    nameTextEditingController.text = name;

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Upload"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameTextEditingController,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "name": nameTextEditingController.text.trim(),
                  }).then((value) {
                    nameTextEditingController.clear();
                    Fluttertoast.showToast(
                        msg: "updated successfully  \n $Error ");
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  "Ok",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> showDriverPhoneDialogAlert(BuildContext contect, String name) {
    nameTextEditingController.text = name;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Upload"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameTextEditingController,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "name": nameTextEditingController.text.trim(),
                  }).then((value) {
                    nameTextEditingController.clear();
                    Fluttertoast.showToast(
                        msg: "updated successfully  \n $Error ");
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  "Ok",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future<void> showDriverAddressDialogAlert(BuildContext contect, String name) {
    nameTextEditingController.text = name;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Upload"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameTextEditingController,
                  )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  userRef.child(firebaseAuth.currentUser!.uid).update({
                    "name": nameTextEditingController.text.trim(),
                  }).then((value) {
                    nameTextEditingController.clear();
                    Fluttertoast.showToast(
                        msg: "updated successfully  \n $Error ");
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  "Ok",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: Text(
            "Profile Screen ",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: ListView(
          padding: EdgeInsets.all(2),
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(50),
                      decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${onlineDriverData.name}",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDriverNameDialogAlert(
                                context, onlineDriverData.name!);
                          },
                          icon: Icon(Icons.edit),
                          color: Colors.blue,
                        )
                      ],
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${onlineDriverData.phone!}",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDriverNameDialogAlert(
                                context, onlineDriverData.phone!);
                          },
                          icon: Icon(Icons.edit),
                          color: Colors.blue,
                        )
                      ],
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${onlineDriverData.address}",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDriverNameDialogAlert(
                                context, onlineDriverData.address!);
                          },
                          icon: Icon(Icons.edit),
                          color: Colors.blue,
                        )
                      ],
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Text(
                      "${onlineDriverData.email}",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${onlineDriverData.vehicle_Model!} \n ${onlineDriverData.vehicle_color!} \n ${onlineDriverData.vehicle_number!} ",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Image.asset(
                          onlineDriverData.Vehicle_type == "Car"
                              ? "Images/Car.png"
                              : "Image/Bike.png",
                          scale: 2,
                        ),

                        // IconButton(
                        //   onPressed: () {
                        //     showDriverNameDialogAlert(
                        //         context, onlineDriverData.address!);
                        //   },
                        //   icon: Icon(Icons.edit),
                        //   color: Colors.blue,
                        // )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      leading: Icon(Icons.history),
                      title: GestureDetector(
                        onTap: () {
                          firebaseAuth.signOut();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => SplashScreen()));
                        },
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
