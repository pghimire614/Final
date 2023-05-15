import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shila/allscreen/Driver/push%20notification/pushNotificationSystem.dart';

import '../../../Assistants/assistantMethods.dart';
import '../../constants.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newgoogleMapController;
  var geoLocator = Geolocator();
  Position? currentPosition;
  double bottomPaddingOfmap = 0;
  String statusText = "Now Offline";
  Color buttonColor = Colors.grey;
  bool isDriverActive = false;
  LocationPermission? _locationPermission;

  // //for showing our current location on map screen
  void locateDriverPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = position;
    LatLng latLngPosition = LatLng(
        driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);
    newgoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String HhumanReadableAddress =
        await AssistanMethods.searchCoordinateAddress(
            driverCurrentPosition!, context);
    print("This is your address" + HhumanReadableAddress);
    AssistanMethods.readDriverRatings(context);
  }

  // readCurrentDriverInformation() async {
  //   currentUser = firebaseAuth.currentUser;
  //   FirebaseDatabase.instance
  //       .ref()
  //       .child("drivers")
  //       .child(currentUser!.uid)
  //       .once()
  //       .then((snap) {
  //         if(snap.snapshot.value!=null){
  //           onlineDriverData.id=(snap.snapshot.value as)
  //         }
  //       });
  // }

  //permission
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

// get current info of driver from database
  readCurrentDriverInformation() async {
    // firebaseUser = await FirebaseAuth.instance.currentUser;
    // String userId = firebaseUser!.uid;
    // DatabaseReference reference =
    //     FirebaseDatabase.instance.ref().child("driver").child(userId);

    currentUser = await FirebaseAuth.instance.currentUser;
    FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(currentUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        onlinedriverData.id = (snap.snapshot.value as Map)["id"];
        onlinedriverData.name = (snap.snapshot.value as Map)["name"];
        onlinedriverData.phone = (snap.snapshot.value as Map)["phone"];
        onlinedriverData.email = (snap.snapshot.value as Map)["email"];
        onlinedriverData.address = (snap.snapshot.value as Map)["address"];

        onlineDriverData.ratings = (snap.snapshot.value as Map)["ratings"];
        onlinedriverData.vehicle_Model =
            (snap.snapshot.value as Map)["car_details"]["vehicle_model"];
        onlinedriverData.vehicle_number =
            (snap.snapshot.value as Map)["car_details"]["vehicle_number"];

        ///agadi ko databadse ma gaye yo 2 oota comment
        onlinedriverData.vehicle_color =
            (snap.snapshot.value as Map)["car_details"]["vehicle_color"];
        onlinedriverData.Vehicle_type =
            (snap.snapshot.value as Map)["car_details"]["type"];
        drivervehicleType = (snap.snapshot.value as Map)["car_details"]["type"];

        onlinedriverData.vehicle_Model =
            (snap.snapshot.value as Map)["vehicle_details"]["vehicle_model"];
        onlinedriverData.vehicle_number =
            (snap.snapshot.value as Map)["vehicle_details"]["vehicle_number"];

        ///agadi ko databadse ma gaye yo 2 oota uncomment
        onlinedriverData.vehicle_color =
            (snap.snapshot.value as Map)["vehicle_details"]["vehicle_color"];
        onlinedriverData.Vehicle_type =
            (snap.snapshot.value as Map)["vehicle_details"]["type"];
      }
      //  reference.once().then((event) {
      // final dataSnapshot = event.snapshot;
      // if (dataSnapshot.value != null) {
      //   userCurrentInfo = Users.fromSnapshot(dataSnapshot);
      // }
    });
    AssistanMethods.readDriverEarnings(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    readCurrentDriverInformation();
    PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
    pushNotificationSystem.initializeCloudMessaging(context);
    pushNotificationSystem.generateAndGetToken();
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      //drawer: drawer(),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(top: 40),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newgoogleMapController = controller;

              locateDriverPosition();
              _determinePosition();
            },
          ),

          //ui for online/offline driver
          statusText != "Now Online"
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  color: Color.fromARGB(91, 55, 50, 50),
                )
              : Container(),

          //button for online/offline driver
          Positioned(
            top: statusText != "Now Online"
                ? MediaQuery.of(context).size.height * 0.45
                : 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (isDriverActive != true) {
                      driverisOnlinenow();
                      updatedriverlocationRealtime();

                      setState(() {
                        statusText = "Now Online";
                        isDriverActive = true;
                        buttonColor = Colors.transparent;
                      });
                    } else {
                      driverIsOfflineNow();
                      setState(() {
                        statusText = "Now Offline";
                        isDriverActive = false;
                        buttonColor = Colors.grey;
                      });
                      Fluttertoast.showToast(msg: "You are Offline now");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: buttonColor,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26))),
                  child: statusText != "Now Online"
                      ? Text(
                          statusText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          Icons.phonelink_ring,
                          color: Colors.black,
                          size: 26,
                        ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void driverisOnlinenow() async {
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = pos;
    Geofire.initialize("activeDrivers"); //currentuser
    Geofire.setLocation(currentUser!.uid, driverCurrentPosition!.latitude,
        driverCurrentPosition!.longitude);
    DatabaseReference ref = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(currentUser!.uid)
        .child("newRideStatus");
    ref.set("idle");
    ref.onValue.listen((event) {});
  }

  updatedriverlocationRealtime() {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      if (isDriverActive == true) {
        Geofire.setLocation(currentUser!.uid, driverCurrentPosition!.latitude,
            driverCurrentPosition!.longitude);
      }
      LatLng latLng = LatLng(
          driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);
      newgoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  driverIsOfflineNow() {
    Geofire.removeLocation(currentUser!.uid);
    DatabaseReference? ref = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(currentUser!.uid)
        .child("newRideStatus");
    ref.onDisconnect();
    ref.remove();
    ref = null;
    Future.delayed(Duration(microseconds: 2000), () {
      SystemChannels.platform.invokeMethod("SystemNavigator.pop");
    });
  }
}
