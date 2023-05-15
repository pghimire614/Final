import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shila/Assistants/assistantMethods.dart';
import 'package:shila/allscreen/constants.dart';

import '../../../models/userRideRequest.dart';
import 'netripScreen.dart';

class NotificationDialogBox extends StatefulWidget {
  UserRideRequestInformation? userRideRequestDetails;
  NotificationDialogBox({this.userRideRequestDetails});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(onlinedriverData.Vehicle_type == "Car"
                ? "images/car.jpeg"
                : "images/bike.png"),

            SizedBox(
              height: 10,
            ),
            Text(
              "New ride Request",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.blue,
              ),
            ),

            SizedBox(
              height: 14,
            ),

            Divider(
              height: 2,
              thickness: 2,
              color: Colors.blue,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "images/pickicon.png",
                        height: 30,
                        width: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails!.originAddress!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Image.asset(
                        "images/desticon.png",
                        height: 30,
                        width: 30,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userRideRequestDetails!.destinationAddress!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(
              height: 2,
              thickness: 2,
              color: Colors.blue,
            ),
            //buttons for canceling ore accepting a ride
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        // audioPlayer.pause();
                        // audioPlayer.stop();
                        // audioPlayer= AssetsAudioPlayer();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      child: Text(
                        "cancel".toUpperCase(),
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        // audioPlayer.pause();
                        // audioPlayer.stop();
                        // audioPlayer= AssetsAudioPlayer();
                        acceptRideRequest(context);
                      },
                      style: ElevatedButton.styleFrom(primary: Colors.green),
                      child: Text(
                        "Accept".toUpperCase(),
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  acceptRideRequest(BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(firebaseAuth.currentUser!.uid)
        .child("newRideStatus")
        .once()
        .then((snap) {
      if (snap.snapshot.value == "idle") {
        FirebaseDatabase.instance
            .ref()
            .child("driver")
            .child(firebaseAuth.currentUser!.uid)
            .child("newRideStatus")
            .set("accepted");
        AssistanMethods.pauseLiveLocationUpdates();

        //trip  started now send driver to new screen

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => newTripScreen()));
      } else {
        Fluttertoast.showToast(msg: "This ride reuest do not exist");
      }
    });
  }
}
