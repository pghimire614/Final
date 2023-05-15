import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shila/Assistants/assistantMethods.dart';
import 'package:shila/allscreen/Driver/push%20notification/netripScreen.dart';
import 'package:shila/allscreen/Driver/tabs/fare%20amount%20collection.dart';
import 'package:shila/button/progress.dart';
import 'package:shila/button/splash.dart';
import 'package:shila/models/userRideRequest.dart';

import '../constants.dart';

class NewTripScreen extends StatefulWidget {
  UserRideRequestInformation? userRideRequestDetails;
  NewTripScreen({
    this.userRideRequestDetails,
  });

  @override
  State<NewTripScreen> createState() => _NewTripScreenState();
}

class _NewTripScreenState extends State<NewTripScreen> {
  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  static const CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(37.12, 122.45), zoom: 14);
  String? buttonTitle = "Arrived";
  bool darkTheme = false;
  Color? ButtonColor = Colors.green;

  Set<Marker> setOfMarker = Set<Marker>();
  Set<Circle> setOfCircle = Set<Circle>();
  Set<Polyline> setOfPolyline = Set<Polyline>();
  List<LatLng> polyLinePoints = [];
  PolylinePoints polylinePoints = PolylinePoints();

  double mapPadding = 0;
  BitmapDescriptor? iconAnimatedtedMarker;
  var geoLocator = Geolocator();
  Position? onlineDriverCurrentPosition;
  String rideRequestStatus = "accepted";
  String durationFromOriginToDestination = "";
  bool isRequestDirectionDetails = false;
  List<LatLng> polylinePositionCoordinate = [];
  //1 accept
  // originltlg=dpickuplocation
  // destltln=user pick location
  //2 pick up
  //originltln=driver ussercurrentlocation
  //destinaltlg=dropooff location user
  Future<void> drawPolyLineFromOriginToDestination(
      LatLng originLatLng, LatLng destinationLatLng, bool darkTheme) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
              message: "Please wait........",
            ));
    var directionDetailsInfo =
        await AssistanMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);
    Navigator.pop(context);
    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodePolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo!.encodedPoints!);
    polylinePositionCoordinate.clear();

    if (decodePolyLinePointsResultList.isNotEmpty) {
      decodePolyLinePointsResultList.forEach((PointLatLng pointLatLng) {
        polylinePositionCoordinate
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    setOfPolyline.clear();
    setState(() {
      Polyline polyline = Polyline(
          polylineId: PolylineId("pPolylineID"),
          jointType: JointType.round,
          points: polylinePositionCoordinate,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          geodesic: true,
          width: 5,
          color: darkTheme ? Colors.amber.shade400 : Colors.blue);
      setOfPolyline.add(polyline);
    });
    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }
    newGoogleMapController!.animateCamera(
      CameraUpdate.newLatLngBounds(boundsLatLng, 65),
    );

    Marker originMarker = Marker(
      markerId: MarkerId("originID"),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    );
    Marker destinationMarker = Marker(
      markerId: MarkerId("destinationID"),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      setOfMarker.add(originMarker);
      setOfMarker.add(destinationMarker);
    });
    Circle originCircle = Circle(
      circleId: CircleId("originID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: CircleId("destinationID"),
      fillColor: Colors.green,
      radius: 12,
      strokeWidth: 3,
      strokeColor: Colors.white,
      center: destinationLatLng,
    );
    setState(() {
      setOfCircle.add(originCircle);
      setOfCircle.add(destinationCircle);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveAssignmentDriverDetailsToUserRideRequest();
  }

  getDriverLocationUpdateAtRealTime() {
    LatLng oldLatLng = LatLng(0, 0);
    streamSubscriptionDriverLivePosition =
        Geolocator.getPositionStream().listen((Position position) {
      driverCurrentPosition = position;
      onlineDriverCurrentPosition = position;
      LatLng latLngLiveDriverPosition = LatLng(
          onlineDriverCurrentPosition!.latitude,
          onlineDriverCurrentPosition!.longitude);
      Marker animatingMarker = Marker(
        markerId: MarkerId("AnimatedMarker"),
        position: latLngLiveDriverPosition,
        icon: iconAnimatedtedMarker!,
        infoWindow: InfoWindow(title: "This is your Position"),
      );
      setState(() {
        CameraPosition cameraPosition =
            CameraPosition(target: latLngLiveDriverPosition, zoom: 18);
        newGoogleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        setOfMarker.removeWhere(
            (element) => element.markerId.value == "AnimatedMarker");
        setOfMarker.add(animatingMarker);
      });
      oldLatLng = latLngLiveDriverPosition;
      updateDurationTimeAtRealTime();
      // update drievr in real time database
      Map driverLatLngDataMap = {
        "latitude": onlineDriverCurrentPosition!.latitude.toString(),
        "longitude": onlineDriverCurrentPosition!.longitude.toString(),
      };
      FirebaseDatabase.instance
          .ref()
          .child("All Ride requests")
          .child(widget.userRideRequestDetails!.rideRequestId!)
          .child("driverLocation")
          .set(driverLatLngDataMap);
    });
  }

  updateDurationTimeAtRealTime() async {
    if (isRequestDirectionDetails == false) {
      isRequestDirectionDetails = true;
      if (onlineDriverCurrentPosition == null) {
        return;
      }
      var originLatLng = LatLng(onlineDriverCurrentPosition!.latitude,
          onlineDriverCurrentPosition!.longitude);
      var destinationLatLng;
      if (rideRequestStatus == "accepeted") {
        destinationLatLng = widget.userRideRequestDetails?.originLatLng!;
        // user pickup loacation
      } else {
        destinationLatLng = widget.userRideRequestDetails?.destinationLatLng!;
      }
      var directionInformation =
          await AssistanMethods.obtainOriginToDestinationDirectionDetails(
              originLatLng, destinationLatLng);
      if (directionInformation != null) {
        setState(() {
          durationFromOriginToDestination = directionInformation.durationText!;
        });
      }
      isRequestDirectionDetails = false;
    }
  }

  createDriverIconMarker() {
    if (iconAnimatedtedMarker == null) {
      ImageConfiguration imageConfiguration = createLocalImageConfiguration(
        context,
        size: Size(2, 2),
      );
      BitmapDescriptor.fromAssetImage(imageConfiguration, "image/Car.png")
          .then((value) {
        iconAnimatedtedMarker = value;
      });
    }
  }

  saveAssignmentDriverDetailsToUserRideRequest() {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child("All ride Request")
        .child(widget.userRideRequestDetails!.rideRequestId!);
    Map driverLocationDataMap = {
      "latitude": driverCurrentPosition!.latitude.toString(),
      "longitude": driverCurrentPosition!.longitude.toString(),
    };
    if (databaseReference.child("driverId") != "waiting") {
      databaseReference.child("driverLocation").set(driverLocationDataMap);
      databaseReference.child("status").set("accepted");
      databaseReference.child("driverId").set(onlineDriverData.id);
      databaseReference.child("driverName").set(onlineDriverData.name);
      databaseReference.child("driverPhone").set(onlineDriverData.phone);
      databaseReference.child("ratings").set(onlineDriverData.ratings);
      databaseReference.child("vehicle_details").set(
          onlineDriverData.vehicle_Model.toString() +
              " " +
              onlineDriverData.vehicle_number.toString() +
              "( " +
              onlineDriverData.vehicle_color.toString() +
              " ) ");
      saveRideRequestIDToDriverHistory();
    } else {
      Fluttertoast.showToast(
          msg:
              "This ride is already accepted by another driver \n reladaing app");
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => SplashScreen()));
    }
  }

  saveRideRequestIDToDriverHistory() {
    DatabaseReference tripHistoryRef = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(firebaseAuth.currentUser!.uid)
        .child("tripsHistory");
    tripHistoryRef
        .child(widget.userRideRequestDetails!.rideRequestId!)
        .set(true);
  }

  endTripNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => ProgressDialog(
        message: "Please wait.....",
      ),
    );
    // get the tripDirectiondetails =distance traveled
    var currentDriverPositionLatLng = LatLng(
        onlineDriverCurrentPosition!.latitude,
        onlineDriverCurrentPosition!.longitude);
    var tripDirectionDetails =
        await AssistanMethods.obtainOriginToDestinationDirectionDetails(
            currentDriverPositionLatLng,
            widget.userRideRequestDetails!.originLatLng!);
    // fare  amount
    double totalFareAmount =
        AssistanMethods.calculateFareAmountFromOriginToDestination(
            tripDirectionDetails!);
    FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .child(widget.userRideRequestDetails!.rideRequestId!)
        .child("fareAmount")
        .set(totalFareAmount.toString());

    FirebaseDatabase.instance
        .ref()
        .child("All Ride Requests")
        .child(widget.userRideRequestDetails!.rideRequestId!)
        .child("status")
        .set("ended");
    Navigator.pop(context);
    // display fare amount in dialog box
    showDialog(
        context: context,
        builder: (BuildContext context) => FareAmountCollectionDialog(
              totalFareAmount: totalFareAmount,
            ));
    // save totalamounts to driver total earning
    saveFareAmountToDriverEarnings(double totalFareAmount) {
      FirebaseDatabase.instance
          .ref()
          .child("drivers")
          .child(firebaseAuth.currentUser!.uid)
          .child("earnings")
          .once()
          .then((snap) {
        if (snap.snapshot.value != null) {
          double oldEarning = double.parse(snap.snapshot.value.toString());
          double driverTotalEarning = totalFareAmount + oldEarning;
          FirebaseDatabase.instance
              .ref()
              .child("drivers")
              .child(firebaseAuth.currentUser!.uid)
              .child("earning")
              .set(driverTotalEarning.toString());
        } else {
          FirebaseDatabase.instance
              .ref()
              .child("drivers")
              .child(firebaseAuth.currentUser!.uid)
              .child("earnings")
              .set(totalFareAmount.toString());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    createDriverIconMarker();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
              initialCameraPosition: _kGooglePlex,
              padding: EdgeInsets.only(bottom: mapPadding),
              mapType: MapType.normal,
              myLocationEnabled: true,
              circles: setOfCircle,
              polylines: setOfPolyline,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;

                setState(() {
                  mapPadding = 350;
                });
                var driverCurrentLatLng = LatLng(
                    driverCurrentPosition!.latitude,
                    driverCurrentPosition!.longitude);
                var userPickUpLatLng =
                    widget.userRideRequestDetails!.originLatLng!;
                drawPolyLineFromOriginToDestination(
                    driverCurrentLatLng, userPickUpLatLng, darkTheme);
                getDriverLocationUpdateAtRealTime();
              }),
          Positioned(
              child: Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                  color: darkTheme ? Colors.black : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 18,
                      spreadRadius: 0.5,
                      offset: Offset(0.6, 0.6),
                    )
                  ]),
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Text(
                      durationFromOriginToDestination,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: darkTheme ? Colors.amber.shade400 : Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 1,
                      color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.userRideRequestDetails!.userName!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: darkTheme
                                ? Colors.amber.shade400
                                : Colors.black,
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.phone,
                            color: darkTheme
                                ? Colors.amber.shade400
                                : Colors.black,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "image/origin.png",
                          width: 30,
                          height: 30,
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
                              color:
                                  darkTheme ? Colors.amberAccent : Colors.black,
                            ),
                          ),
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "image/destination.png",
                          width: 30,
                          height: 30,
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
                              color:
                                  darkTheme ? Colors.amberAccent : Colors.black,
                            ),
                          ),
                        ))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      thickness: 1,
                      color: darkTheme ? Colors.amber.shade400 : Colors.grey,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton.icon(
                        onPressed: () async {
                          // driver has aaarived at user pickup location
                          if (rideRequestStatus == "accepted") {
                            rideRequestStatus = "arrived";
                            FirebaseDatabase.instance
                                .ref()
                                .child("All Ride Reuests")
                                .child(widget
                                    .userRideRequestDetails!.rideRequestId!)
                                .child("status")
                                .set(rideRequestStatus);
                            setState(() {
                              buttonTitle = "Lets go";
                              ButtonColor = Colors.lightGreen;
                            });
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context) => ProgressDialog(
                                message: "Loading.....",
                              ),
                            );
                            await drawPolyLineFromOriginToDestination(
                                widget.userRideRequestDetails!.originLatLng!,
                                widget
                                    .userRideRequestDetails!.destinationLatLng!,
                                darkTheme);
                            Navigator.pop(context);
                          }
                          // user has picked from current loaction-lets go button
                          else if (rideRequestStatus == "arrived") {
                            rideRequestStatus = "ontrip";
                            FirebaseDatabase.instance
                                .ref()
                                .child("All Ride Requests")
                                .child(widget
                                    .userRideRequestDetails!.rideRequestId!)
                                .child("status")
                                .set(rideRequestStatus);
                            setState(() {
                              buttonTitle = "End Trip";
                              ButtonColor = Colors.red;
                            });
                          }
                          // user has reached the drop off location-end trip button
                          else if (rideRequestStatus == "onTrip") {
                            endTripNow();
                          }
                        },
                        icon: Icon(
                          Icons.directions_bike,
                          color: darkTheme ? Colors.black : Colors.white,
                          size: 20,
                        ),
                        label: Text(
                          buttonTitle!,
                          style: TextStyle(
                              color: darkTheme
                                  ? Colors.amber.shade400
                                  : Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
