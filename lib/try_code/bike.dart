import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shila/Assistants/geofire_assisstant.dart';
import 'package:shila/DataHandeler/appData.dart';
import 'package:shila/allscreen/constants.dart';
import 'package:shila/allscreen/rider/active_nearby_available_drivers.dart';

import 'package:shila/allscreen/rider/searchScreen.dart';
import 'package:shila/allscreen/rider/searchbike.dart';
import 'package:shila/button/drawer.dart';
import 'package:shila/models/directiondetails.dart';
import '../../Assistants/assistantMethods.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../button/progress.dart';

String Locationaddress = '';

class mapbike extends StatefulWidget {
  const mapbike({super.key});

  static const String idScreen = "map";
  @override
  State<mapbike> createState() => _mapState();
}

class _mapState extends State<mapbike> with TickerProviderStateMixin {
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

  Position? currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfmap = 0;
  double rideDetailsContainer = 0;
  double searchContainerHeight = 200;
  double requestRideContainer = 0;
  GoogleMapController? newgoogleMapController;
  List<LatLng> pLineCoordinate = [];
  Set<Polyline> polyLinesSet = {};
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  DirectionDetails? tripdirectionDetails;
  String userName = ""; //thapeko
  String userEmail = ""; //thapeko
  bool openDrawer = true; //thapeko
  bool activeNearbyDriverKeysLoaded = false; // this is locally created
  BitmapDescriptor?
      activeNearbyIcon; // is a classto representt  an icon or image that can be displayed on a Marker on a GoogleMap widget
  String dfiverRideStatus = "driver Is coming";
  StreamSubscription<DatabaseEvent>? tripRideRequestInfoStreamSubscription;

  DatabaseReference? rideRequestRef;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AssistanMethods.getCurrentOnLineUserInfo(); //for geetiing user information
  }

  void saveRideRequest() {
    rideRequestRef =
        FirebaseDatabase.instance.ref().child("All Ride Requests").push();
    var pickup = Provider.of<AppData>(context, listen: false).pickUpLocation;
    var dropoff = Provider.of<AppData>(context, listen: false).dropOffLocation;

    Map pickUplocMap = {
      "latitude": pickup!.latitude.toString(),
      "longitude": pickup.longitude.toString(),
    };
    Map dropOfflocMap = {
      "latitude": dropoff!.latitude.toString(),
      "longitude":
          dropoff.longitude.toString(), //not nullable effect late ley thapeko
    };

    Map rideinfoMap = {
      "driver_id": "waiting",
      "payment_method": "cash",
      "pickup": pickUplocMap,
      "dropoff": dropOfflocMap,
      "created_at": DateTime.now().toString(),
      "rider_name": userCurrentInfo!.name,
      "rider_phone": userCurrentInfo!.phone,
      "pickup_address": pickup.placeName,
      "dropoff_address": dropoff.placeName,
    };
    rideRequestRef!.set(rideinfoMap);

    // thapeko
    tripRideRequestInfoStreamSubscription =
        rideRequestRef!.onValue.listen((eventSnap) async {
      if (eventSnap.snapshot.value == null) {
        return;
      }
    });
  }

  void cancelRideRequest() {
    rideRequestRef?.remove();
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
  }

  //thapeko ho
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
        "images/bike.png",
      ).then((value) {
        activeNearbyIcon = value;
      });
    }
  }

  resetApp() {
    setState(() {
      openDrawer = true;
      searchContainerHeight = 300;
      rideDetailsContainer = 0;
      bottomPaddingOfmap = 290.0;
      requestRideContainer = 0;
      polyLinesSet.clear();
      markers.clear();
      circles.clear();
      pLineCoordinate.clear();
      locateUserPosition();
    });
  }

  void requestRideDetailsContainer() {
    setState(() {
      requestRideContainer = 250.0;
      rideDetailsContainer = 0;
      bottomPaddingOfmap = 290.0;
      openDrawer = true;
    });
    saveRideRequest();
  }

  void displayRideDetailsContainer() async {
    await getPlaceDirection();
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainer = 300.0;
      bottomPaddingOfmap = 290.0;
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
                  height: searchContainerHeight,
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
                                    builder: (context) => SearchScreenbike()));
                            if (res == "abc") {
                              displayRideDetailsContainer();
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
                    height: rideDetailsContainer,
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
                          Container(
                            width: double.infinity,
                            color: Colors.tealAccent[100],
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    "images/bike.png",
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
                                        "Bike",
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
                                        ? '\Rs. ${(AssistanMethods.calculateFaresBike(tripdirectionDetails!).toString())})'
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
                                  requestRideDetailsContainer();
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
                  height: requestRideContainer,
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
