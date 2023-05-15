import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:shila/allscreen/constants.dart';
import 'package:shila/models/address.dart';

import '../../Assistants/assistantMethods.dart';
import '../../DataHandeler/appData.dart';
class PrecisePickupScreen extends StatefulWidget {
  const PrecisePickupScreen({super.key});

  @override
  State<PrecisePickupScreen> createState() => _PrecisePickupScreenState();
}

class _PrecisePickupScreenState extends State<PrecisePickupScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
 loc.Location location=loc.Location();
  GlobalKey<ScaffoldState> scaffoldkey = new GlobalKey<ScaffoldState>();
  GoogleMapController? newgoogleMapController;
  LatLng? pickLocation; 
  String? _address;
  double bottomPaddingOfmap = 0;
  Position? currentPosition;
  
     getAddressFromLatlng() async {
      try {
        GeoData data=await Geocoder2.getDataFromCoordinates(latitude: pickLocation!.latitude, longitude:pickLocation!.longitude, googleMapApiKey: google_api_key);
      setState(() {
        
        Address pickUpAddress =Address();
        pickUpAddress.latitude=pickLocation!.latitude;
        pickUpAddress.longitude=pickLocation!.longitude;
        pickUpAddress.placeName=data.address;
        
       Provider.of<AppData>(context, listen: false).updatepickUpLocationAddress(pickUpAddress);
      _address=data.address;
      });}catch(e){
        print(e);
      }
      }
  

    void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    LatLng latLatPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =new CameraPosition(target: latLatPosition, zoom: 14);
    newgoogleMapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    String address = await AssistanMethods.searchCoordinateAddress(position,context);
  
  }
  
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
              padding: EdgeInsets.only(top: 100, bottom: bottomPaddingOfmap),
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
                  bottomPaddingOfmap = 30;
                });
                locatePosition();
                _determinePosition();
              },
              onCameraMove: (CameraPosition? positiion){
                setState(() {
                  if(pickLocation != positiion!.target){
                    setState(() {
                      pickLocation =positiion.target;
                    });
                  }
                });
              },
              onCameraIdle: () {
                getAddressFromLatlng();
              },

            ),
            Align(
              alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.only(top:60, bottom: bottomPaddingOfmap),
              child: Image.asset("images/pickicon.png",height: 45,width: 45,),),),

             Positioned(
                                top: 70,
                                right: 20,
                                left: 20,
                                child: Container(
                                height: 60.0,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 6.0,
                                        spreadRadius: 0.5,
                                        offset: Offset(0.7, 0.7),
                                        ),
                                    ],
                                  ),

                                child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(  Provider.of<AppData>(context).pickUpLocation != null
                                  ? (Provider.of<AppData>(context).pickUpLocation!.placeName!).substring(0,22) +"......." 
                                  :"Not Geeting Addree",
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                                                               ),
                                ),
                               
                               ),
                               ),

          
                               Positioned(
                                //top: 400,
                                bottom: 0,
                                 left: 0,
                                // height: 100,
                                right:0,
                              
                            child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shadowColor: Colors.blueAccent,
                                      textStyle: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)
                                    ),
                                    child: Text("Set Current Location"),),
                                ))
            
        ],
      ),
    );
  }
}