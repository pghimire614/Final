import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shila/allscreen/rider/map.dart';
import 'package:shila/allscreen/rider/mapbike.dart';
import '../../Assistants/assistantMethods.dart';
import '../../button/drawer.dart';
import '../constants.dart';

String Locationaddress = '';

class rider extends StatefulWidget {
  const rider({super.key});
  static const String idScreen = "rider";

  @override
  State<rider> createState() => _riderState();
}

class _riderState extends State<rider> with TickerProviderStateMixin {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  late GoogleMapController newgoogleMapController;

  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();


  late Position currentPosition;
  var geoLocator = Geolocator();
  double bottomPaddingOfmap = 0;
  String userName="";//thapeko
  String userEmail="";  //thapeko
  bool openDrawer =true; //thapeko
  bool activeNearbyDriverKeysLoaded=false;// this is locally created
  BitmapDescriptor? activeNearbyIcon; // is a classto representt  an icon or image that can be displayed on a Marker on a GoogleMap widget

 
//user currnlocation
  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLatPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);
    newgoogleMapController.animateCamera(
        CameraUpdate.newCameraPosition(cameraPosition)); //location

    //for display display
    String address =
        await AssistanMethods.searchCoordinateAddress(position, context);
    print("This is your address" + address);
    userName =userCurrentInfo!.name!;
    userName =userCurrentInfo!.name!;

  }

// for asking permission
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
  } //permiission close

//position for initialposittion
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

//position for lake
  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(28.255112, 83.976358),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              newgoogleMapController = controller;
              setState(() {
                bottomPaddingOfmap = 350;
              });
              locatePosition();
              _determinePosition();
            },
          ),

          Positioned(
            top: 45.0,
            left: 22.0,
            child: GestureDetector(
              onTap: () {
                scaffoldkey.currentState!.openDrawer();
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
                    Icons.menu,
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
              child: Container(
                height: 300.0,
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
                        style:
                            TextStyle(fontSize: 20.0, fontFamily: "brand bold"),
                      ),
                      Text(
                        "Choose Vechicle",
                        style:
                            TextStyle(fontSize: 20.0, fontFamily: "brand bold"),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => mapbike() ));
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
                                  child: SizedBox(
                                    width: 130,
                                    height: 90,
                                    child: Image.asset(
                                      'images/bike.png',
                                      height: 50,
                                      width: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 30.0,
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => map()));
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
                                    child: SizedBox(
                                      width: 130,
                                      height: 90,
                                      child: Image.asset(
                                        'images/car.jpeg',
                                        height: 50,
                                        width: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                      // Container(
                      //   child: TextButton(
                      //     onPressed: () {
                      //       Navigator.pushNamedAndRemoveUntil(
                      //           context, finddriver.idScreen, (route) => false);
                      //     },
                      //     child: Text("find  Driver"),
                      //   ),
                      // ),
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
              )),

          FloatingActionButton.extended(
            onPressed: _goToTheLake,
            label: const Text('To the college!'),
            icon: const Icon(Icons.directions_boat),
          ),
        ],
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
