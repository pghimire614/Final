import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shila/Assistants/geofire_assisstant.dart';
import 'package:shila/Assistants/requestAssistant.dart';
import 'package:shila/models/directiondetails.dart';
import '../DataHandeler/appData.dart';
import '../allscreen/constants.dart';
import '../models/address.dart';
import '../models/allUsers.dart';
import '../models/trips_history_model.dart';
import 'package:http/http.dart' as http;

// for get and post
class AssistanMethods {
  //searchaddressForGeographicCoordinates  --> searchCoordinateAddress
  static Future<String> searchCoordinateAddress(
      Position position, context) async {
    String placeAddress = ""; //human readable for
    //String st1, st2, st3, st4;
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng= ${position.latitude}, ${position.longitude}  &key= $google_api_key";
    var response = await RequestAssistant.getRequest(url);
    if ((response != "failed")) {
      placeAddress = response["results"][0]["formatted_address"];
      // st1 = response["results"][0]["address_components"][3]["long_name"];
      // st2 = response["results"][0]["address_components"][4]["long_name"];
      // st3 = response["results"][0]["address_components"][5]["long_name"];
      // st4 = response["results"][0]["address_components"][6]["long_name"];
      // placeAddress = st1 + " ," + st2 + "," + st3 + ", " + st4;

      Address userPickUpAddress = new Address();
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatepickUpLocationAddress(userPickUpAddress);
    }
    return placeAddress;
  }

  //for direction between two point
  static Future<DirectionDetails?> obtainOriginToDestinationDirectionDetails(
      LatLng initialPosition, LatLng finalPosition) async {
    String directionurl =
        "https://maps.googleapis.com/maps/api/directions/json?destination=${finalPosition.latitude},${finalPosition.longitude}&origin=${initialPosition.latitude},${initialPosition.longitude}&key=$google_api_key";
    var res = await RequestAssistant.getRequest(directionurl);
    if (res == "failed") {
      return null;
    }
    DirectionDetails directionDetails = DirectionDetails();
    directionDetails.encodedPoints =
        res["routes"][0]["overview_polyline"]["points"];
    directionDetails.distanceText =
        res["routes"][0]["legs"][0]["distance"]["text"];
    directionDetails.distanceValue =
        res["routes"][0]["legs"][0]["distance"]["value"];
    directionDetails.durationText =
        res["routes"][0]["legs"][0]["duration"]["text"];
    directionDetails.durationValue =
        res["routes"][0]["legs"][0]["duration"]["value"];
    return directionDetails;
  }

  static double calculateFareAmountFromOriginToDestination(
      DirectionDetails directionDetails) {
    double timeTravelFareAmountPerMinute =
        (directionDetails.durationValue! / 60) * 0.1;
    double distanceTravelFareAmountPerKilometer =
        (directionDetails.durationValue! / 1000) * 0.1;
    double totalFareAmount =
        timeTravelFareAmountPerMinute + distanceTravelFareAmountPerKilometer;
    double localCurrencyTotalFare = totalFareAmount * 130;
    if (driverVehicleType == "Bike") {
      double resultFareAmount = ((localCurrencyTotalFare.truncate()) * 0.6);
      resultFareAmount;
    } else if (drivervehicleType == "Car") {
      double resultFareAmount = ((localCurrencyTotalFare.truncate()) * 2);
      resultFareAmount;
    } else {
      localCurrencyTotalFare.truncate().toDouble();
    }
    return localCurrencyTotalFare.truncate().toDouble();
  }

  static double calculateFaresBike(DirectionDetails directionDetails) {
    double distanceTravelFare =
        (directionDetails.distanceValue! / 1000) * 10; // 1 km 10 rs ho haii;
    return double.parse(distanceTravelFare.toStringAsFixed(1));
  }

//CODE FOR SENDING NOtification on driver screen
  static sendNotificationToDriverNow(
      String deviceRegistrationToken, String userRideRequestId, context) async {
    String destinationAddress = userDropOffAddress;
    Map<String, String> headerNotification = {
      'Content-Type': 'application/json',
      'Authorization': cloudMessagingServerToken,
    };
    Map bodyNotification = {
      "body": "Destination Address : $destinationAddress.",
      "title": "New Trip Request"
    };
    Map dataMap = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "rideRequestId": userRideRequestId
    };
    Map officialNotificationFormat = {
      "notification": bodyNotification,
      "data": dataMap,
      "priority": "high",
      "to": deviceRegistrationToken
    };
    var responseNotification = http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: headerNotification,
        body: jsonEncode(officialNotificationFormat));
  }

//readCurrentOnlineUserInfo --> getCurrentOnlineUserInfo

  //for getting user iinformation from database .. datasnapshot value
  static Future<void> getCurrentOnLineUserInfo() async {
    currentUser = await FirebaseAuth.instance.currentUser;
    String userId = currentUser!.uid;
    DatabaseReference reference = FirebaseDatabase.instance
        .ref()
        .child("rider")
        .child(userId); //refrence value

    reference.once().then((snap) {
      final dataSnapshot = snap.snapshot, value;
      if (dataSnapshot.value != null) {
        userCurrentInfo = Users.fromSnapshot(dataSnapshot);
      }
    });
  }

//retrive the trips keys for online user
//trip key= ride request key
  static void readTripsKeysFromOnlineDriver(context) {
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .orderByChild("driverId")
        .equalTo(firebaseAuth.currentUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        Map keysTripsId = snap.snapshot.value as Map;
//count total number trips and share it with provider
        int overAllTripsCounter = keysTripsId.length;
        Provider.of<AppData>(context, listen: false)
            .updateOverAllTripsCounter(overAllTripsCounter);
        //share trips keys with provider

        List<String> tripsKeysList = [];
        keysTripsId.forEach((key, value) {
          tripsKeysList.add(key);
        });
        Provider.of<AppData>(context, listen: false)
            .updateOverAllTripsKeys(tripsKeysList);

        //get trips keys data.  readtrips complete information

        readTripsHistoryInformation(context);
      }
    });
  }

  static void readTripsKeysFormOnlineUser(context) {
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Request")
        .orderByChild("userName")
        .equalTo(userModelCurrentInfo!.name)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        Map keysTripsId = snap.snapshot.value as Map;
//count total number trips and share it with provider
        int overAllTripsCounter = keysTripsId.length;
        Provider.of<AppData>(context, listen: false)
            .updateOverAllTripsCounter(overAllTripsCounter);
        //share trips keys with provider

        List<String> tripsKeysList = [];
        keysTripsId.forEach((key, value) {
          tripsKeysList.add(key);
        });
        Provider.of<AppData>(context, listen: false)
            .updateOverAllTripsKeys(tripsKeysList);

        //get trips keys data.  readtrips complete information

        readTripsHistoryInformation(context);
      }
    });
  }

  static void readTripsHistoryInformation(context) {
    var tripsAllKeys =
        Provider.of<AppData>(context, listen: false).historyTripskeyList;

    for (String eachkey in tripsAllKeys) {
      FirebaseDatabase.instance
          .ref()
          .child("All Ride Request")
          .child(eachkey)
          .once()
          .then((snap) {
        var eachTripHistory = TripsHistoryModel.fromSnapshot(snap.snapshot);
        if ((snap.snapshot.value as Map)["status"] == "ended") {
          //update or add each history to ovaeall history data list
          Provider.of<AppData>(context, listen: false)
              .udateOverAllTripsHistoryInformation(eachTripHistory);
        }
      });
    }
  }

  // readDriverEarnings
  static void readDriverEarnings(context) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(firebaseAuth.currentUser!.uid)
        .child("earnings")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String driverEarnings = snap.snapshot.value.toString();
        Provider.of<AppData>(context, listen: false)
            .updateDriverTotalEarning(driverEarnings);
      }
    });
    readTripsKeysFromOnlineDriver(ContextAction);
  }

  static void readDriverRatings(context) {
    FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(firebaseAuth.currentUser!.uid)
        .child("ratings")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String driverRatings = snap.snapshot.value.toString();
        Provider.of<AppData>(context, listen: false)
            .updateDriverTotalEarning(driverRatings);
      }
    });
  }

//anothwe solution for getcurrentt ¥userinfo

  //   static Future<void> getCurrentOnLineUserInfo() async {
  //   firebaseUser = await FirebaseAuth.instance.currentUser;
  //   String userId = firebaseUser!.uid;
  //   DatabaseReference reference =
  //       FirebaseDatabase.instance.ref().child("user").child(userId);

  //   final snapshot = await reference.get(); // you should use await on async methods
  //   if (snapshot!.value != null) {
  //     userCurrentInfo = Users.fromSnapshot(snapshot);
  //   }
  // }

  static pauseLiveLocationUpdates() {
    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(firebaseAuth.currentUser!.uid);
  }
  //calculateFareAmountFromOriginToDestination
  //if(driverVehi)
}
