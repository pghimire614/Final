
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:shila/Assistants/requestAssistant.dart';
// import 'package:shila/allscreen/map.dart';

// import 'constants.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});
//   static const String idScreen = "SearchScreen";

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   TextEditingController pickUpTextEditingController = TextEditingController();
//   TextEditingController dropOffTextEditingController = TextEditingController();
//   String googleApikey = google_api_key;
//   GoogleMapController? mapController; //contrller for Google map
//   CameraPosition? cameraPosition;
//   LatLng startLocation = LatLng(27.6602292, 85.308027); 
//   //String location = "Search Location"; 

//   @override
//   Widget build(BuildContext context) {
//     // String placeAddress =
//     //     Provider.of<AppData>(context).pickUpLocation.name ?? "";
//     // pickUpTextEditingController.text = placeAddress;
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//       ),
//       body: Column(
//         children: [
//         GoogleMap( //Map widget from google_maps_flutter package
//                   zoomGesturesEnabled: true, //enable Zoom in, out on map
//                   initialCameraPosition: CameraPosition( //innital position in map
//                     target: startLocation, //initial position
//                     zoom: 14.0, //initial zoom level
//                   ),
//                   mapType: MapType.normal, //map type
//                   onMapCreated: (controller) { //method called when map is created
//                     setState(() {
//                       mapController = controller; 
//                     });
//                   },
//              ),
//           Positioned(
//             child: Container(
//               height: 215.0,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(3.0),
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black,
//                     blurRadius: 6.0,
//                     spreadRadius: 0.5,
//                     offset: Offset(0.7, 0.7),
//                   ),
//                 ],
//               ),
//               child: Padding(
//                 padding: EdgeInsets.only(
//                     left: 25.0, right: 25.0, top: 25.0, bottom: 20.0),
//                 child: Column(
//                   children: [
//                     SizedBox(
//                       height: 5.0,
//                     ),
//                     Stack(
//                       children: [
//                         GestureDetector(
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                             child: Icon(Icons.arrow_back)),
//                         Center(
//                           child: Text("Set Drop off",
//                               style: TextStyle(
//                                   fontSize: 18.0, fontFamily: "Brand Bold")),
//                         )
//                       ],
//                     ),
//                     SizedBox(
//                       height: 16.0,
//                     ),
//                     Row(
//                       children: [
                
//                         Expanded(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.grey[400],
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.all(3.0),
//                               child: TextField(
//                                 cursorColor:Color.fromARGB(255, 236, 232, 221),
//                                 controller: pickUpTextEditingController,
//                                 decoration: InputDecoration(
//                                   hintText: "PickUp Location",
//                                   fillColor: Colors.grey[400],
//                                   filled: true,
//                                   border: InputBorder.none,
//                                   isDense: true,
//                                   contentPadding: EdgeInsets.only(
//                                       left: 11.0, top: 8.0, bottom: 8.0),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 10.0,
//                     ),
//                     Row(
//                       children: [
//                         Image.asset(
//                           "images/desticon.png",
//                           height: 16.0,
//                           width: 16.0,
//                         ),
//                         SizedBox(
//                           width: 18.0,
//                         ),
//                         Expanded(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.grey[400],
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.all(3.0),
//                               child: TextField(
//                                 onChanged: (val) {
//                                   findPlace(val);
//                                 },
//                                 controller: dropOffTextEditingController,
//                                 decoration: InputDecoration(
//                                   hintText: "Where to go?",
//                                   fillColor: Colors.grey[400],
//                                   filled: true,
//                                   border: InputBorder.none,
//                                   isDense: true,
//                                   contentPadding: EdgeInsets.only(
//                                       left: 11.0, top: 8.0, bottom: 8.0),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (context) => map()));
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   void findPlace(String placeName) async {
//     if (placeName.length > 1) {
//       String autoCompleteUrl =
//           "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$google_api_key";
//       var res = await RequestAssistant.getRequest(autoCompleteUrl);
//       if (res == "failed") {}
//       print(res);
//     }
//   }
// }


// //2nd code

// import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_maps_webservice/places.dart';
// import 'package:shila/allscreen/constants.dart';


// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});
//   static const String idScreen = "SearchScreen";

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {

//   String googleApikey = google_api_key;
//   GoogleMapController? mapController; //contrller for Google map
//   CameraPosition? cameraPosition;
//   LatLng startLocation = LatLng(27.6602292, 85.308027); 
//   String location = "Search Location"; 
//  TextEditingController pickUpTextEditingController = TextEditingController();
//   TextEditingController dropOffTextEditingController = TextEditingController();



//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//           appBar: AppBar( 
//             title: Text("Search Pick Up Location"),
//              backgroundColor: Colors.deepPurpleAccent,
//              leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () => Navigator.of(context).pop(),
             
//           ),),
//           body: Stack(
//             children:[

//               GoogleMap( //Map widget from google_maps_flutter package
//                   zoomGesturesEnabled: true, //enable Zoom in, out on map
//                   initialCameraPosition: CameraPosition( //innital position in map
//                     target: startLocation, //initial position
//                     zoom: 14.0, //initial zoom level
//                   ),
//                   mapType: MapType.normal, //map type
//                   onMapCreated: (controller) { //method called when map is created
//                     setState(() {
//                       mapController = controller; 
//                     });
//                   },
//              ),
//               Positioned(
//                 child: Row(
//                       children: [
//                         Image.asset(
//                           "images/pickicon.png",
//                           height: 16.0,
//                           width: 16.0,
//                         ),
//                         SizedBox(
//                           width: 18.0,
//                         ),
//                         Expanded(
//                           child: Container(
//                             decoration: BoxDecoration(
//                               color: Colors.grey[400],
//                               borderRadius: BorderRadius.circular(5.0),
//                             ),
//                             child: Padding(
//                               padding: EdgeInsets.all(3.0),
//                               child: TextField(
//                                 controller: pickUpTextEditingController,
//                                 decoration: InputDecoration(
//                                   hintText: "PickUp Location",
//                                   fillColor: Colors.grey[400],
//                                   filled: true,
//                                   border: InputBorder.none,
//                                   isDense: true,
//                                   contentPadding: EdgeInsets.only(
//                                       left: 11.0, top: 8.0, bottom: 8.0),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//               ),
//                   SizedBox(
//                     height: 10.0,
//                   ),
        

           

//              //search autoconplete input
//              Positioned(  //search input bar
//                top:20,
//                child: InkWell(
//                  onTap: () async {
//                   var place = await PlacesAutocomplete.show(
//                           context: context,
//                           apiKey: googleApikey,
//                           mode: Mode.overlay,
//                           types: [],
//                           strictbounds: false,
//                           components: [Component(Component.country, 'np')],
//                                       //google_map_webservice package
//                           onError: (err){
//                              print(err);
//                           }
//                       );

//                    if(place != null){
//                         setState(() {
//                           location = place.description.toString();
//                         });

//                        //form google_maps_webservice package
//                        final plist = GoogleMapsPlaces(apiKey:googleApikey,
//                               apiHeaders: await GoogleApiHeaders().getHeaders(),
//                                         //from google_api_headers package
//                         );
//                         String placeid = place.placeId ?? "0";
//                         final detail = await plist.getDetailsByPlaceId(placeid);
//                         final geometry = detail.result.geometry!;
//                         final lat = geometry.location.lat;
//                         final lang = geometry.location.lng;
//                         var newlatlang = LatLng(lat, lang);
                        

//                         //move map camera to selected place with animation
//                         mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
//                    }
//                  },
//                  child:Padding(
//                    padding: EdgeInsets.all(15),
//                     child: Card(
//                        child: Container(
//                          padding: EdgeInsets.all(0),
//                          width: MediaQuery.of(context).size.width - 40,
//                          child: ListTile(
//                             title:Text(location, style: TextStyle(fontSize: 18),),
//                             trailing: Icon(Icons.search),
//                             dense: true,
//                          )
//                        ),
//                     ),
//                  )
//                )
//              )


//             ]
//           )
//        );
//   }
// }





  // //Future<void> showUserNameDialogAlert(BuildContext context, String name) {
  //   return 
  //   showDialog(
  //     context: context,
  //     builder: (context){
  //       return AlertDialog(
  //         title: Text("Update"),
  //         content: SingleChildScrollView(
  //           child: Column(
  //             children: [

  //             ],
  //           ),
  //         ),
  //       )
   //  },