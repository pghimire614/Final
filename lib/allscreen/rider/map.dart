import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shila/Assistants/geofire_assisstant.dart';
import 'package:shila/DataHandeler/appData.dart';
import 'package:shila/allscreen/Driver/tabs/rateDriverscreen.dart';
import 'package:shila/allscreen/constants.dart';
import 'package:shila/allscreen/rider/active_nearby_available_drivers.dart';
import 'package:shila/allscreen/rider/searchScreen.dart';
import 'package:shila/button/drawer.dart';
import 'package:shila/button/splash.dart';
import 'package:shila/models/directiondetails.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Assistants/assistantMethods.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../button/progress.dart';
import '../Driver/payfare.dart';

Future<void> _makephonecall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw "Could not launch $url";
  }
}

String Locationaddress = '';

class map extends StatefulWidget {
  const map({super.key});

  static const String idScreen = "map";
  @override
  State<map> createState() => _mapState();
}

class _mapState extends State<map> with TickerProviderStateMixin {
  LatLng? pickLocation;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();

  static const colorizeColors = [
    Colors.green,
    Colors.purple,
    Colors.pink,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 50.0,
    fontFamily: 'Signatra',
    fontWeight: FontWeight.bold,
  );

  List<LatLng> pLineCoordinate = [];
  List<ActiveNearByAvailableDrivers> onlineNearByAvailableDriversList = [];

  GoogleMapController? newgoogleMapController;

  Position? currentPosition;

  DirectionDetails? tripdirectionDetails;

  var geoLocator = Geolocator();

  double bottomPaddingOfmap = 0;
  double suggestedRidesContainerHeight = 0;
  double searchLocationContainerHeight = 200;
  double searchingForDriverContainerHeight = 0;
  double waitingResponseFromDriverContainerHeight = 0;
  double assignedDriverForContainer = 0;

  Set<Polyline> polyLinesSet = {};
  Set<Marker> markers = {};
  Set<Circle> circles = {};

  String selectedVehicleType = "Car";
  String userName = ""; //thapeko
  String userEmail = ""; //thapeko
  String userRideRequestStatus = "";
  String driverRideStatus = "Driver is coming";

  bool openDrawer = true; //thapeko
  bool activeNearbyDriverKeysLoaded = false; // this is locally created
  bool requestPositionInfo = true;

  BitmapDescriptor?
      activeNearbyIcon; // is a classto representt  an icon or image that can be displayed on a Marker on a GoogleMap widget

  StreamSubscription<DatabaseEvent>? tripRideRequestInfoStreamSubscription;

  DatabaseReference? referenceRideRequest;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AssistanMethods.getCurrentOnLineUserInfo(); //for geetiing user information
  }

  void showSearchingForDriversContainer() {
    setState(() {
      searchingForDriverContainerHeight = 200;
    });
  }

  void saveRideRequestInformation(String selectedVechicleType) {
    //save ride request information
    referenceRideRequest =
        FirebaseDatabase.instance.ref().child("All Ride Requests").push();
    var originLocation =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    var destinationLocation =
        Provider.of<AppData>(context, listen: false).dropOffLocation;

    Map originLocationMap = {
      //key: value
      "latitude": originLocation!.latitude.toString(),
      "longitude": originLocation.longitude.toString(),
    };
    Map destinationLocationMap = {
      "latitude": destinationLocation!.latitude.toString(),
      "longitude": destinationLocation.longitude
          .toString(), //not nullable effect late ley thapeko
    };

    Map userinformationMap = {
      "driverId": "waiting",
      "payment_method": "cash",
      "origin": originLocationMap,
      "destination": destinationLocationMap,
      "time": DateTime.now().toString(),
      "userName": userCurrentInfo!.name,
      "userPhone": userCurrentInfo!.phone,
      "originAddress": originLocation.placeName,
      "destinationAddress": destinationLocation.placeName,
    };
    referenceRideRequest!.set(userinformationMap); // thapeko
    tripRideRequestInfoStreamSubscription =
        referenceRideRequest!.onValue.listen((eventSnap) async {
      if (eventSnap.snapshot.value == null) {
        return;
      }

      if ((eventSnap.snapshot.value as Map)["vehicle_details"] != null) {
        setState(() {
          driverVehicleDetails =
              (eventSnap.snapshot.value as Map)["vehicle_details"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverPhone"] != null) {
        setState(() {
          driverPhone =
              (eventSnap.snapshot.value as Map)["driverPhone"].toString();
        });
      }
      if ((eventSnap.snapshot.value as Map)["ratings"] != null) {
        setState(() {
          driverRatings =
              (eventSnap.snapshot.value as Map)["ratings"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverName"] != null) {
        setState(() {
          driverName =
              (eventSnap.snapshot.value as Map)["driverName"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["status"] != null) {
        setState(() {
          userRideRequestStatus =
              (eventSnap.snapshot.value as Map)["status"].toString();
        });
      }

      if ((eventSnap.snapshot.value as Map)["driverLocation"] != null) {
        double driverCurrentPositionLat = double.parse(
            (eventSnap.snapshot.value as Map)["driverLocation"]["latitude"]
                .toString());
        double driverCurrentPositionLng = double.parse(
            (eventSnap.snapshot.value as Map)["driverLocation"]["longitude"]
                .toString());

        LatLng driverCurrentPositionLatLng =
            LatLng(driverCurrentPositionLat, driverCurrentPositionLng);

        //status = accepted
        if (userRideRequestStatus == "accepted") {
          updateArrivalTimeToUserPickUpLocation(driverCurrentPositionLatLng);
        }

        //status =arrived
        if (userRideRequestStatus == "arrived") {
          setState(() {
            driverRideStatus = "Driver has arrived";
          });
        }

        //status =ontrip
        if (userRideRequestStatus == "ontrip") {
          updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng);
        }

        //trip is ended
        if (userRideRequestStatus == "ended") {
          if ((eventSnap.snapshot.value as Map)["fareAmount"] != null) {
            double fareAmount = double.parse(
                (eventSnap.snapshot.value as Map)["fareAmount"].toString());

            var response = await showDialog(
              context: context,
              builder: (BuildContext context) => PayFareAmountDialog(
                fareAmount: fareAmount,
              ),
            );

            if (response == "Cash Paid") {
              //usercan rate the driver now
              if ((eventSnap.snapshot.value as Map)["driverId"] != null) {
                String assignedDriverId =
                    (eventSnap.snapshot.value as Map)["driverId"].toString();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RateDriverScreen(assignedDriverId)));

                referenceRideRequest!.onDisconnect();
                tripRideRequestInfoStreamSubscription!.cancel();
              }
            }
          }
        }
      }
    });

    onlineNearByAvailableDriversList =
        GeofireAssistant.activeNearByAvailableDriversList;
    searchNearestOnlineDrivers(selectedVehicleType); // (selectedVehicleType )
  }

  searchNearestOnlineDrivers(
      String selectedVehicleType) async //(String selectedVehicleType)
  {
    if (onlineNearByAvailableDriversList.length == 0) {
      // cancel the ride request
      referenceRideRequest!.remove();
      setState(() {
        polyLinesSet.clear();
        markers.clear();
        circles.clear();
        pLineCoordinate.clear();
      });
      Fluttertoast.showToast(msg: "No online Nearest  Driver Available");
      Fluttertoast.showToast(msg: "Search Again  \n Restarting the App ");
      Future.delayed(Duration(microseconds: 4000), () {
        referenceRideRequest!.remove();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SplashScreen()));
      });
      return;
    }

    await retrieveOnlineDriversInformation(onlineNearByAvailableDriversList);
    print("Driver list  : " + driversList.toString());

    for (int i = 0; i < driversList.length; i++) {
      if (driversList[i]["vehicle_details"]["type"] == selectedVehicleType) {
        AssistanMethods.sendNotificationToDriverNow(
            driversList[i]["token"], referenceRideRequest!.key!, context);
      }
    }
    Fluttertoast.showToast(msg: "Notification sent successfully");

    showSearchingForDriversContainer();
    //requestRideDetailsContainer();

    await FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .child(referenceRideRequest!.key!)
        .child("driverId")
        .onValue
        .listen((eventRideRequestSnapshot) {
      print("EventSnapshot: ${eventRideRequestSnapshot.snapshot.value}");

      if (eventRideRequestSnapshot.snapshot.value != null) {
        if (eventRideRequestSnapshot.snapshot.value != "waiting") {
          showUIforAssignedDriverInfo();
        }
      }
    });
  }

  updateArrivalTimeToUserPickUpLocation(driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;
      LatLng userPickUpPosition =
          LatLng(currentPosition!.latitude, currentPosition!.longitude);
      var directionDetailsInfo =
          await AssistanMethods.obtainOriginToDestinationDirectionDetails(
        driverCurrentPositionLatLng,
        userPickUpPosition,
      );

      if (directionDetailsInfo == null) {
        return;
      }
      setState(() {
        driverRideStatus =
            "Driver is coming: " + directionDetailsInfo.durationText.toString();
      });

      requestPositionInfo = true;
    }
  }

  updateReachingTimeToUserDropOffLocation(driverCurrentPositionLatLng) async {
    if (requestPositionInfo == true) {
      requestPositionInfo = false;
      var dropOffLocation =
          Provider.of<AppData>(context, listen: false).dropOffLocation;
      LatLng userDestinationPosition =
          LatLng(dropOffLocation!.latitude!, dropOffLocation.longitude!);
      var directionDetailsInfo =
          await AssistanMethods.obtainOriginToDestinationDirectionDetails(
              driverCurrentPositionLatLng, userDestinationPosition);
      if (directionDetailsInfo == null) {
        return;
      }
      setState(() {
        driverRideStatus = "Going towards Destination:" +
            directionDetailsInfo.durationText
                .toString(); //duration_text ->durationText
      });
      requestPositionInfo = true;
    }
  }

  showUIforAssignedDriverInfo() {
    setState(() {
      waitingResponseFromDriverContainerHeight = 0;
      searchLocationContainerHeight = 0;
      assignedDriverForContainer = 200;
      searchingForDriverContainerHeight = 400;
      suggestedRidesContainerHeight = 0;
      bottomPaddingOfmap = 300;
    });
  }

  retrieveOnlineDriversInformation(List onlineNearestDriversList) async {
    driversList.clear();
    DatabaseReference ref = FirebaseDatabase.instance.ref().child("driver");

    for (int i = 0; i < onlineNearestDriversList.length; i++) {
      await ref
          .child(onlineNearestDriversList[i].driverId.toString())
          .once()
          .then((dataSnapshot) {
        var driverKeyInfo = dataSnapshot.snapshot.value;

        driversList.add(driverKeyInfo);
        print("driver key information = " + driversList.toString());
      });
    }
  }

  void cancelRideRequest() {
    referenceRideRequest!.remove();
  }

//for showing our current location on map screen
  void locateUserPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLatPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);
    newgoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String address =
        await AssistanMethods.searchCoordinateAddress(position, context);
    print("This is your address" + address);
    userName = userCurrentInfo!.name!;

    userName = userCurrentInfo!.name!;
    initialGeoFireListener();
    AssistanMethods.readTripsKeysFormOnlineUser(context);
  }

  //thapeko ho for show car/bike icon on map
  initialGeoFireListener() {
    Geofire.initialize("activeDrivers"); //10 km radius
    Geofire.queryAtLocation(
            currentPosition!.latitude, currentPosition!.longitude, 10)!
        .listen((map) {
      print(map);

      if (map != null) {
        var callBack = map["callBack"];

        switch (callBack) {
          //whenever any  driver is active or online
          case Geofire.onKeyEntered:
            GeofireAssistant.activeNearByAvailableDriversList.clear();
            ActiveNearByAvailableDrivers activeNearByAvailableDrivers =
                ActiveNearByAvailableDrivers();
            activeNearByAvailableDrivers.locationLatitude = map["latitude"];
            activeNearByAvailableDrivers.locationLongitude = map["longitude"];
            activeNearByAvailableDrivers.driverId = map["key"];
            GeofireAssistant.activeNearByAvailableDriversList
                .add(activeNearByAvailableDrivers);
            if (activeNearbyDriverKeysLoaded == true) {
              displayActiveDriversOnUserMap();
            }
            break;
          // whenever driver is non active/online
          case Geofire.onKeyExited:
            GeofireAssistant.deleteOfflineDriverFromList(map["key"]);
            displayActiveDriversOnUserMap();

            break;
          //whenever drver moves update driverlocation
          case Geofire.onKeyMoved:
            ActiveNearByAvailableDrivers activeNearByAvailableDrivers =
                ActiveNearByAvailableDrivers();
            activeNearByAvailableDrivers.locationLatitude = map["latitude"];
            activeNearByAvailableDrivers.locationLongitude = map["longitude"];
            activeNearByAvailableDrivers.driverId = map["key"];
            GeofireAssistant.updateActiveNearByAvailableDriverLocation(
                activeNearByAvailableDrivers);
            displayActiveDriversOnUserMap();
            break;

          //drsplay those online active drivers on users map
          case Geofire.onGeoQueryReady:
            activeNearbyDriverKeysLoaded = true;
            displayActiveDriversOnUserMap();
            break;
        }
      }
      setState(() {});
    });
  }

//displaying active driver on map
  displayActiveDriversOnUserMap() {
    setState(() {
      markers.clear();
      circles.clear();

      Set<Marker> driversMarkerSet = Set<Marker>();
      for (ActiveNearByAvailableDrivers eachDriver
          in GeofireAssistant.activeNearByAvailableDriversList) {
        LatLng eachDriverActivePosition =
            LatLng(eachDriver.locationLatitude!, eachDriver.locationLongitude!);
        Marker marker = Marker(
          markerId: MarkerId(eachDriver.driverId!),
          position: eachDriverActivePosition,
          icon: activeNearbyIcon!,
          rotation: 360,
        );
        driversMarkerSet.add(marker);
      }
      setState(() {
        markers = driversMarkerSet;
      });
    });
  }

  createActiveNearByDriverIconMarker() {
    if (activeNearbyIcon == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: Size(0.2, 0.2));
      BitmapDescriptor.fromAssetImage(
        imageConfiguration,
        "images/taxi.png",
      ).then((value) {
        activeNearbyIcon = value;
      });
    }
  }

  resetApp() {
    setState(() {
      openDrawer = true;
      searchLocationContainerHeight = 200;
      suggestedRidesContainerHeight = 0;
      bottomPaddingOfmap = 290.0;
      searchingForDriverContainerHeight = 0;
      polyLinesSet.clear();
      markers.clear();
      circles.clear();
      pLineCoordinate.clear();
      locateUserPosition();
    });
  }

  void requestRideDetailsContainer() {
    setState(() {
      searchingForDriverContainerHeight = 400.0;
      // suggestedRidesContainer = 0;
      // bottomPaddingOfmap = 350.0;
      openDrawer = true;
    });
    //saveRideRequestInformation();
  }

  void showSuggestedRidesContainer() async {
    await getPlaceDirection();
    setState(() {
      searchLocationContainerHeight = 0;
      suggestedRidesContainerHeight = 400.0;
      bottomPaddingOfmap = 400.0;
      openDrawer = false;
    });
  }

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

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(28.237988, 83.995590),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  Widget build(BuildContext context) {
    createActiveNearByDriverIconMarker();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      }, // for unfocussing the current widget//aru tthau ma click gare keyword naayos vanera
      child: Scaffold(
        key: scaffoldkey,
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        drawer: drawer(),
        body: Stack(
          children: [
            GoogleMap(
              padding: EdgeInsets.only(bottom: bottomPaddingOfmap),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              initialCameraPosition: _kGooglePlex,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              polylines: polyLinesSet,
              markers: markers,
              circles: circles,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                newgoogleMapController = controller;
                setState(() {
                  bottomPaddingOfmap = 350;
                });
                locateUserPosition();
                _determinePosition();
              },
              onCameraMove: (CameraPosition? positiion) {
                setState(() {
                  if (pickLocation != positiion!.target) {
                    setState(() {
                      pickLocation = positiion.target;
                    });
                  }
                });
              },
              // onCameraIdle: () {
              //   //getAddressFromLatlng();
              // },
            ),

            Positioned(
              top: 38.0,
              left: 22.0,
              child: GestureDetector(
                onTap: () {
                  if (openDrawer) {
                    scaffoldkey.currentState!.openDrawer();
                  } else {
                    resetApp();
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 6.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      )
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      (openDrawer) ? Icons.menu : Icons.cancel,
                      color: Colors.blue,
                    ),
                    radius: 20.0,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSize(
                curve: Curves.bounceIn,
                duration: new Duration(microseconds: 160),
                child: Container(
                  height: searchLocationContainerHeight,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 16.0,
                        spreadRadius: 0.5,
                        offset: Offset(0.7, 0.7),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 18.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                          "Hi  there",
                          style: TextStyle(
                              fontSize: 20.0, fontFamily: "brand bold"),
                        ),
                        Text(
                          "where to go?",
                          style: TextStyle(
                              fontSize: 20.0, fontFamily: "brand bold"),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        GestureDetector(
                          onTap: () async {
                            var res = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchScreen()));
                            if (res == "abc") {
                              showSuggestedRidesContainer();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black54,
                                  blurRadius: 6.0,
                                  spreadRadius: 0.5,
                                  offset: Offset(0.7, 0.7),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.search,
                                    color: Colors.blueAccent,
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Text("Where to go?"),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 24.0,
                        ),
                        // GestureDetector(
                        //     onTap: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (context) => SearchScreen()));
                        //     },
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         color: Colors.white,
                        //         borderRadius: BorderRadius.circular(5.0),
                        //         boxShadow: [
                        //           BoxShadow(
                        //             color: Colors.black54,
                        //             blurRadius: 6.0,
                        //             spreadRadius: 0.5,
                        //             offset: Offset(0.7, 0.7),
                        //           ),
                        //         ],
                        //       ),
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(12.0),
                        //         child: Row(
                        //           children: [
                        //             Icon(
                        //               Icons.search,
                        //               color: Colors.blueAccent,
                        //             ),
                        //             SizedBox(
                        //               width: 10.0,
                        //             ),
                        //             Text("Destination"),
                        //           ],
                        //         ),
                        //       ),
                        //     )),

                        // Row(
                        // children: [
                        //   Icon(
                        //     Icons.home,
                        //     color: Colors.grey,
                        //   ),
                        //   SizedBox(
                        //     width: 12.0,
                        //   ),
                        //   Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        // children: [
                        //   Provider.of<AppData>(context).pickUpLocation !=
                        //           null
                        //       ? Provider.of<AppData>(context)
                        //           .pickUpLocation
                        //           .placeName
                        //       : "Add Home",
                        //   SizedBox(
                        //     height: 4.0,
                        //   ),
                        //   Text(
                        //     "your living home address",
                        //     style: TextStyle(color: Colors.grey),
                        //   ),
                        // ],
                        //)
                        // ],
                        // ),
                        Divider(),
                        // Row(
                        //   children: [
                        //     Icon(
                        //       Icons.work,
                        //       color: Colors.grey,
                        //     ),
                        //     SizedBox(
                        //       width: 12.0,
                        //     ),
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         //Text("Add work"),
                        //         SizedBox(
                        //           height: 4.0,
                        //         ),
                        //         // Text(
                        //         //   "your office address",
                        //         //   style: TextStyle(color: Colors.grey),
                        //         // ),
                        //       ],
                        //     )
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Center(
                child: AnimatedSize(
                  curve: Curves.bounceIn,
                  duration: new Duration(microseconds: 160),
                  child: Container(
                    height: suggestedRidesContainerHeight,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 0.5,
                            blurRadius: 16.0,
                            color: Colors.black,
                            offset: Offset(0.7, 0.7),
                          )
                        ]),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 17.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                Provider.of<AppData>(context).pickUpLocation !=
                                        null
                                    ? (Provider.of<AppData>(context)
                                        .pickUpLocation!
                                        .placeName!)
                                    : "Not Getting Address",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Icon(
                                  Icons.star,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                Provider.of<AppData>(context).dropOffLocation !=
                                        null
                                    ? (Provider.of<AppData>(context)
                                        .dropOffLocation!
                                        .placeName!)
                                    : "Not Getting Address",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.tealAccent[100],
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "images/taxi.png",
                                    height: 70.0,
                                    width: 80.0,
                                  ),
                                  SizedBox(
                                    width: 16.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Car",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontFamily: "Brand semibold"),
                                      ),
                                      Text(
                                        "10 Km",
                                        style: TextStyle(
                                            fontSize: 16.0, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  Expanded(child: Container()),
                                  Text(
                                    (tripdirectionDetails != null
                                        ? '\Rs. ${(AssistanMethods.calculateFareAmountFromOriginToDestination(tripdirectionDetails!).toString())})'
                                        : ""),
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.money,
                                  size: 18.0,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 16.0,
                                ),
                                Text("Cash"),
                                SizedBox(width: 6.0),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                  size: 16.0,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  if (selectedVehicleType != null) {
                                    saveRideRequestInformation(
                                        selectedVehicleType);

                                    setState(() {
                                      // suggestedRidesContainer=0;
                                      searchingForDriverContainerHeight = 10;
                                    }); //(selectedVehicletype)
                                  } else {
                                    Fluttertoast.showToast(
                                        msg:
                                            "select vechicle from suggested rI");
                                  }
                                  //requestRideDetailsContainer();
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(17.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Request",
                                        style: TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                      Icon(
                                        FontAwesomeIcons.taxi,
                                        color: Colors.white,
                                        size: 27.0,
                                      ),
                                    ],
                                  ),
                                )),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 0.5,
                          blurRadius: 16.0,
                          color: Colors.white,
                          offset: Offset(0.7, 0.7),
                        )
                      ]),
                  height: searchingForDriverContainerHeight,
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(children: [
                      SizedBox(
                        height: 12.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: AnimatedTextKit(
                          animatedTexts: [
                            ColorizeAnimatedText(
                              'Requesting a Ride',
                              textStyle: colorizeTextStyle,
                              colors: colorizeColors,
                              textAlign: TextAlign.center,
                            ),
                            ColorizeAnimatedText(
                              'Please  wait...',
                              textStyle: colorizeTextStyle,
                              colors: colorizeColors,
                              textAlign: TextAlign.center,
                            ),
                            ColorizeAnimatedText(
                              'Finding a Driver',
                              textStyle: colorizeTextStyle,
                              colors: colorizeColors,
                              textAlign: TextAlign.center,
                            ),
                          ],
                          isRepeatingAnimation: true,
                          onTap: () {
                            print("Tap Event");
                          },
                        ),
                      ),
                      SizedBox(
                        height: 22.0,
                      ),
                      GestureDetector(
                        onTap: () {
                          cancelRideRequest();
                          resetApp();
                        },
                        child: Container(
                          height: 60.0,
                          width: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26.0),
                            color: Colors.white,
                            border: Border.all(width: 2.0, color: Colors.grey),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 26.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: double.infinity,
                        child: Text(
                          "Cancel Ride",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ),
            // ui for display
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 0.5,
                        blurRadius: 16.0,
                        color: Colors.white,
                        offset: Offset(0.7, 0.7),
                      )
                    ]),
                height: assignedDriverForContainer,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(children: [
                    // SizedBox(
                    //   height: 12.0,
                    // ),
                    Text(
                      driverRideStatus,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.green,
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      spreadRadius: 0.5,
                                      blurRadius: 16.0,
                                      color: Colors.lightBlue,
                                      offset: Offset(0.7, 0.7),
                                    )
                                  ]),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  driverName,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                    ),
                                    Text(
                                      driverRatings,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Image.asset(
                              "images/car.png",
                              scale: 3,
                            ),
                            Text(driverCarDetails),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        _makephonecall("tel:${driverPhone}");
                      },
                      icon: Icon(Icons.phone),
                      label: Text("Call driver"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        cancelRideRequest();
                        resetApp();
                      },
                      child: Container(
                        height: 60.0,
                        width: 60.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26.0),
                          color: Colors.white,
                          border: Border.all(width: 2.0, color: Colors.grey),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 26.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Cancel Ride",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12.0),
                      ),
                    ),
                  ]),
                ),
              ),
            ),
            //ui for display driver information

            //to lake call
            FloatingActionButton.extended(
              onPressed: _goToTheLake,
              label: const Text('To the college!'),
              icon: const Icon(Icons.directions_boat),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  //passing initial and final position for direction
  Future<void> getPlaceDirection() async {
    var initalPos = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;

    //retriving latang position of pickup and destionation
    var pickUpLatLng = LatLng(initalPos!.latitude!,
        initalPos.longitude!); // ! it must not be null soo
    var dropOffLocation = LatLng(
        finalPos!.latitude!,
        finalPos
            .longitude!); //late ley garda initial and finalpos ma not null tyhapelo

    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "Please wait ...",
            ));

    //passing the latlng position to find the route
    var details =
        await AssistanMethods.obtainOriginToDestinationDirectionDetails(
            pickUpLatLng, dropOffLocation);
    setState(() {
      tripdirectionDetails = details;
    });
    Navigator.pop(context);
    // output will be in encoded form it need to be decode
    print("this is encoded Points;;");
    print(details?.encodedPoints);

    //decoding the data and drawing a polyline between two points
    PolylinePoints polylinePoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResult =
        polylinePoints.decodePolyline(details?.encodedPoints ?? "");
    pLineCoordinate.clear();
    if (decodePolyLinePointsResult.isNotEmpty) {
      decodePolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinate
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polyLinesSet.clear();
    setState(() {
      Polyline polyline = Polyline(
        color: Color.fromARGB(255, 96, 148, 226),
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinate,
        width: 4,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polyLinesSet.add(polyline);
    });

    //code in order to fit the destinationation and pickup address routes
    LatLngBounds latLngBounds;
    if (pickUpLatLng.latitude > dropOffLocation.latitude &&
        pickUpLatLng.longitude > dropOffLocation.longitude) {
      latLngBounds =
          LatLngBounds(southwest: dropOffLocation, northeast: pickUpLatLng);
    } else if (pickUpLatLng.latitude > dropOffLocation.latitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(dropOffLocation.latitude, pickUpLatLng.longitude),
          northeast: LatLng(pickUpLatLng.latitude, dropOffLocation.longitude));
    } else if (pickUpLatLng.longitude > dropOffLocation.longitude) {
      latLngBounds = LatLngBounds(
          southwest: LatLng(pickUpLatLng.latitude, dropOffLocation.longitude),
          northeast: LatLng(dropOffLocation.latitude, pickUpLatLng.longitude));
    } else {
      latLngBounds =
          LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLocation);
    }
    // reinitalizing  the map  with suitable pickup and destination
    newgoogleMapController
        ?.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));
    //marker and circles
    Marker pickUpLocMarker = Marker(
        markerId: MarkerId("pickUpId"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow:
            InfoWindow(title: initalPos.placeName, snippet: "PickUp Location"),
        position: pickUpLatLng); //pickup

    Marker dropOffLocMarker = Marker(
        markerId: MarkerId("dropOffId"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow:
            InfoWindow(title: finalPos.placeName, snippet: "PickUp Location"),
        position: dropOffLocation); //dropoff
    setState(() {
      markers.add(pickUpLocMarker);
      markers.add(dropOffLocMarker);
    });

    Circle pickUpLocCircle = Circle(
        circleId: CircleId("pickUpId"),
        fillColor: Colors.yellowAccent,
        center: pickUpLatLng,
        radius: 30,
        strokeWidth: 4,
        strokeColor: Colors.yellowAccent);

    Circle dropOffLocCircle = Circle(
        circleId: CircleId("dropOffId"),
        fillColor: Colors.blueAccent,
        center: dropOffLocation,
        radius: 30,
        strokeWidth: 4,
        strokeColor: Colors.yellowAccent);
    setState(() {
      circles.add(pickUpLocCircle);
      circles.add(dropOffLocCircle);
    });
  }
}
