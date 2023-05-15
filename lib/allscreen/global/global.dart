import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shila/allscreen/Driver/driverdata.dart';
import 'package:shila/models/allUsers.dart';
import 'package:shila/models/directiondetails.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

User? currentUser;
StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionPositionDriverLivePosition;
Users? userModelCurrentInfo;
Position? driverCurrentPosition;
driverdata onlineDriverData = driverdata();
DirectionDetails? tripDirectionDetailsInfo;
String? driverVehicleType = "";
// DirectionDetailsInfo? tripDirectionDetailsInfo;
