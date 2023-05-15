import 'package:firebase_database/firebase_database.dart';

class TripsHistoryModel {
  String? time;
  String? originAddress;
  String? destinationAddress;
  String? status;
  String? fareAmount;
  String? userName;
  String? userPhone;
  String? ratings;
  String? driverName;
  String? vehicle_details;

  TripsHistoryModel(
      {this.time,
      this.originAddress,
      this.destinationAddress,
      this.status,
      this.ratings,
      this.vehicle_details,
      this.driverName,
      this.fareAmount,
      this.userName,
      this.userPhone});

  TripsHistoryModel.fromSnapshot(DataSnapshot dataSnapshot) {
    time = (dataSnapshot.value as Map)["time"];
    originAddress = (dataSnapshot.value as Map)["originAddress"];
    destinationAddress = (dataSnapshot.value as Map)["destinationAddress"];
    status = (dataSnapshot.value as Map)["status"];
    fareAmount = (dataSnapshot.value as Map)["fareAmount"];
    userName = (dataSnapshot.value as Map)["userName"];
    driverName = (dataSnapshot.value as Map)["driverName"];
    vehicle_details = (dataSnapshot.value as Map)["vehicle_details"];
    userPhone = (dataSnapshot.value as Map)["userPhone"];
  }
}
