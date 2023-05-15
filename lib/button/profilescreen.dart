import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/route_manager.dart';
import 'package:shila/allscreen/constants.dart';

class profilescreen extends StatefulWidget {
  const profilescreen({super.key});

  @override
  State<profilescreen> createState() => _profilescreenState();
}

class _profilescreenState extends State<profilescreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController addressTextEditingController = TextEditingController();
  DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("rider");

  Future<void> showUserNameDialogAlert(BuildContext context, String name) {
    nameTextEditingController.text = name;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameTextEditingController,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  usersRef.child(firebaseAuth.currentUser!.uid).update({
                    "name": nameTextEditingController.text.trim(),
                  }).then((value) {
                    nameTextEditingController.clear();
                    Fluttertoast.showToast(
                        msg: "Updated Successfully reload to see changes");
                  }).catchError((errorMessage) {
                    Fluttertoast.showToast(
                        msg: "Error occured reload $errorMessage ");
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.red),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        );
      },
    );
  }

  Future<void> showUseraddressDialogAlert(
      BuildContext context, String address) {
    addressTextEditingController.text = address;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: addressTextEditingController,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  usersRef.child(firebaseAuth.currentUser!.uid).update({
                    "address": addressTextEditingController.text.trim(),
                  }).then((value) {
                    addressTextEditingController.clear();
                    Fluttertoast.showToast(
                        msg: "Updated Successfully reload to see changes");
                  }).catchError((errorMessage) {
                    Fluttertoast.showToast(
                        msg: "Error occured reload $errorMessage ");
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.red),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        );
      },
    );
  }

  Future<void> showUserphoneDialogAlert(BuildContext context, String phone) {
    phoneTextEditingController.text = phone;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Update"),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: phoneTextEditingController,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  usersRef.child(firebaseAuth.currentUser!.uid).update({
                    "phone": phoneTextEditingController.text.trim(),
                  }).then((value) {
                    phoneTextEditingController.clear();
                    Fluttertoast.showToast(
                        msg: "Updated Successfully reload to see changes");
                  }).catchError((errorMessage) {
                    Fluttertoast.showToast(
                        msg: "Error occured reload $errorMessage ");
                  });
                  Navigator.pop(context);
                },
                child: Text(
                  "Ok",
                  style: TextStyle(color: Colors.red),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.blue),
                ))
          ],
        );
      },
    );
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
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text(
            "Profile Screen",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 50),
            child: Column(
              children: [
                Center(
                  child: Image.asset(
                    "images/user_icon.png",
                    height: 80.0,
                    width: 80.0,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${userCurrentInfo!.name!}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          showUserNameDialogAlert(
                              context, userCurrentInfo!.name!);
                        },
                        icon: Icon(Icons.edit)),
                  ],
                ),
                Divider(
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${userCurrentInfo!.phone!}",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          showUserphoneDialogAlert(
                              context, userCurrentInfo!.phone!);
                        },
                        icon: Icon(Icons.edit)),
                  ],
                ),
                Divider(
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${userCurrentInfo!.address}",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          showUseraddressDialogAlert(
                              context, userCurrentInfo!.address!);
                        },
                        icon: Icon(Icons.edit)),
                  ],
                ),
                Divider(
                  thickness: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${userCurrentInfo!.email}",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
