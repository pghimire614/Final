import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shila/allscreen/constants.dart';
import 'package:shila/models/userRideRequest.dart';

import 'notification.dart';

class PushNotificationSystem{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future initializeCloudMessaging(BuildContext context) async{
    //1.terminated
    //when the app is cloasewd abd opened directly from the push notification

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage){
if (remoteMessage != null){
   readUserRideRequestInformation(remoteMessage.data["riderequestId"],context);
}
    });

    //2.foreground 
    //when an app is poen and receive push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage){
      readUserRideRequestInformation(remoteMessage!.data["rideRequestId"],context);

    });

    //backgrouind
    //when an app is in the backgroudand opened directly from the push notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage){
      readUserRideRequestInformation(remoteMessage!.data["rideRequestId"],context);
    });

  }

 readUserRideRequestInformation(String userRideRequestId,BuildContext context){
FirebaseDatabase.instance.ref().child("All Ride Requests").child(userRideRequestId).child("driverId").onValue.listen((event) { 
  if(event.snapshot.value == "Waiting" || event.snapshot.value==firebaseAuth.currentUser!.uid){
    FirebaseDatabase.instance.ref().child("All Ride Requests").child(userRideRequestId).once().then((snapData){

//audio player

       if(snapData.snapshot.value!=null){

        // audioPlayer.open(Audio("nasme"));
        // audioPlayer.play();
        double originLat= double.parse((snapData.snapshot.value! as Map)["origin"]["lalitude"]);
        double originLng= double.parse((snapData.snapshot.value! as Map)["origin"]["longitude"]);
        String originAddress=(snapData.snapshot.value! as Map)["originAddress"];
        
        double destinationLat= double.parse((snapData.snapshot.value! as Map)["destination"]["lalitude"]);
        double destinationLng= double.parse((snapData.snapshot.value! as Map)["destination"]["longitude"]);
        String destinationAddress=(snapData.snapshot.value! as Map)["destinationAddress"];

        String userName=(snapData.snapshot.value! as Map)["userName"];
        String userPhone=(snapData.snapshot.value! as Map)["userPhone"];
        String? riderRequestId=snapData.snapshot.key;

        UserRideRequestInformation userRideRequestDetails=UserRideRequestInformation();
        userRideRequestDetails.originLatLng=LatLng(originLat,originLng);
        userRideRequestDetails.destinationLatLng=LatLng(destinationLat, destinationLng);
        userRideRequestDetails.originAddress=originAddress;
        userRideRequestDetails.destinationAddress= destinationAddress;
        userRideRequestDetails.userName=userName;
        userRideRequestDetails.userPhone=userPhone;
        
        userRideRequestDetails.rideRequestId= riderRequestId;

          showDialog(context: context, builder: (BuildContext context) => NotificationDialogBox(
            userRideRequestDetails: userRideRequestDetails,
          ));
       }
       else{
         Fluttertoast.showToast(msg: "This Ride Request id do not exist.");
       }
    });
  }
  else{
         Fluttertoast.showToast(msg: "This Ride Request has been Cancelled!!!!");
         Navigator.pop(context);
  }
 });
 }

Future generateAndGetToken() async{
  String? registrationToken= await messaging.getToken();

print("FCM Registration Token: ${registrationToken}");
FirebaseDatabase.instance.ref().child("driver").child(firebaseAuth.currentUser!.uid).child("token").set(registrationToken);
messaging.subscribeToTopic("allDrivers");
messaging.subscribeToTopic("allUsers");
}

}