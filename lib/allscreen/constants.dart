import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shila/allscreen/Driver/driverdata.dart';

import '../models/allUsers.dart';
import '../models/directiondetails.dart';

const String google_api_key = 

const Color primaryColor = Color.fromARGB(255, 83, 33, 198);
const double defaultPadding = 15.0;
User? currentUser; //user firebseruser

StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;

Users? userCurrentInfo;
Position? driverCurrentPosition;
//user? currentuser ko thau ma firebaseuser xa hamro signup ma

//AssetesAudioPlayer  assetesAudioPlayer=AssetsAudioPlayer();

final FirebaseAuth firebaseAuth =
    FirebaseAuth.instance; // instance of firebase is firebaseauth
DirectionDetails? tripdirectionDetailsInfo;

StreamSubscription<Position>? streamSubscriptionPositionDriverLivePosition;
Users? userModelCurrentInfo;

driverdata onlineDriverData = driverdata();
DirectionDetails? tripDirectionDetailsInfo;
String? driverVehicleType = "";
String userDropOffAddress = "";
String driverCarDetails = "";
String driverName = "";
String driverPhone = "";
String driverRatings = "";
String countRatings = "";
double countRatingStars = 0.0;
String titleStarsRating = "";
String cloudMessagingServerToken =
    "key = AAAAHPPBYGA:APA91bH4DwUnHi6AXTCsiPRmXB9L0ChHUbt2VV68r8tONFiE2efowMkItVf3Gvt2kGn2Ilo06geCl4bm1mCjj37yO0FBjipdlrKJraAbbo2hHB-J6nHnI96tCAvvPCkGDnW_nciJ_lGJ";

driverdata onlinedriverData = driverdata();
List driversList = [];

String drivervehicleType = "";
//AssetAudiooPlayer audiooPlayer= AssetAudioPlayer  for audo player
String driverVehicleDetails = "";
