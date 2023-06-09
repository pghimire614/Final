import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'constants.dart';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({Key? key}) : super(key: key);
  @override
  State<OrderTrackingPage> createState() => OrderTrackingPageState();
  static const String idScreen = "OrderTrackingPaage";
}

class OrderTrackingPageState extends State<OrderTrackingPage> {
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(28.263611, 83.972389);
  static const LatLng destination = LatLng(28.2246, 83.98);

   List<LatLng> polylineCoordinates = [];
  LocationData? currentLocation;
  void getCurrentLocation() async {
    Location location = Location();
    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    );}
  // GoogleMapController googleMapController = await _controller.future;
  //   location.onLocationChanged.listen(
  //     (newLoc) {
  //       currentLocation = newLoc;
  //       googleMapController.animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //             zoom: 13.5,
  //             target: LatLng(
  //               newLoc.latitude!,
  //               newLoc.longitude!,
  //             ),
  //           ),
  //         ),
  //       );
  //       setState(() {});
  //     },
  //   );
  // }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key, // Your Google Map Key
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
      PointLatLng(destination.latitude, destination.longitude),
    );
    if (result.points.isNotEmpty) {
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(point.latitude, point.longitude),
        ),
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    getCurrentLocation();
    getPolyPoints();

    super.initState();
    // getPolyPoints();

    //super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: 
        currentLocation == null
            ? const Center(child: Text("Loading"))
            :
             GoogleMap(
                initialCameraPosition: CameraPosition(
                  target:
                  LatLng(
                      currentLocation!.latitude!, currentLocation!.longitude!),
                  zoom: 13.5,
                ),
                markers: {
                   Marker(
                     markerId: const MarkerId("currentLocation"),
                     position: LatLng(currentLocation!.latitude!,
                        currentLocation!.longitude!),
                   ),
                  const Marker(
                    markerId: MarkerId("source"),
                    position: sourceLocation,
                  ),
                  const Marker(
                    markerId: MarkerId("destination"),
                    position: destination,
                  ),
                },
                onMapCreated: (mapController) {
                  _controller.complete(mapController);
                },
                mapType: MapType.normal,
                polylines: {
                  Polyline(
                    polylineId: const PolylineId("route"),
                    points: polylineCoordinates,
                    color: Color.fromARGB(255, 92, 121, 5),
                    width: 6,
                  ),
               },
              ));
  }
}
