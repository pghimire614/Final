// import 'package:flutter/material.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
// import 'package:provider/provider.dart';
// import 'package:shila/Assistants/requestAssistant.dart';
// import 'package:shila/DataHandeler/appData.dart';
// import 'package:shila/allscreen/loginscreen.dart';
// import 'address.dart';


// class PredictionTile extends StatelessWidget {
//   const PredictionTile({super.key});

//   final PlacePredictions placePredictions;
//   PredictionTile({required Key key, this.placePredictions}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(0 .0),
//       child: TextButton(     
        
//         onPressed: () {
//           getPLaceAddressDetails(placePredictions.place_id, context);
//         },
//         child: Container(
//           child: Column(children: [
//             SizedBox(
//               width: 10.0,
//             ),
//             Row(
//               children: [
//                 Icon(Icons.add_location),
//                 SizedBox(width: 14.0),
//                 Expanded(child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 8.0,),
//                     Text(placePredictions.main_text,  overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16.0),),
//                     SizedBox(height: 2.0,),
//                     Text(placePredictions.secondary_text,overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 12.0,color: Colors.black),),
//                     SizedBox( height: 8.0,),
//                   ],
//                 )),
//               ],
//             ),
//           ]),
//         ),
//       ),
//     );
//   }
//   void getPLaceAddressDetails(String placeId, context) async{
//     showDialog(context: context, builder: (BuildContext (context) => loginscreen()));
//     //ProgressDialog(message:"Setting DropOff, Please wait....")));
    
    
//     String placeDetailsUrl ="https://maps.googleapis.com/maps /api/place/details/json?place_id=$placeId&key=AIzaSyCX6RyqYcKYWQeymV2wYddifcX0kB6C3x8";
//     var  res = await RequestAssistant.getRequest(placeDetailsUrl);
//     Navigator.pop(context);
//     if (res  == "failed") 
//     {
//       return ;
//     }
//     // if(res ["status"] == "Ok"){
//     //  Address address = Address();
//     //  address.placeName =res["result"]["name"];
//     //  address.placeId =placeId;
//     //  address.latitude =res["result"]["geometry"]["location"]["lat"];
//     // address.longitude =res["result"]["geometry"]["location"]["lng"];
//     // Provider.of<AppData>(context,listen : false).updatedropOffLocationAddress(address);
//     // print("this is drop off location");
//     // print(address.placeName);


//     }

//   }
// }




           
                             
                             //if case code
              //                  child:  InkWell(
              //    onTap: () async {
              //     var place = await PlacesAutocomplete.show(
              //             context: context,
              //             apiKey: google_api_key,
              //             mode: Mode.overlay,
              //             types: [],
              //             strictbounds: false,
              //             components: [Component(Component.country, 'np')],
              //                         //google_map_webservice package
              //             onError: (err){
              //                print(err);
              //             }
              //         );

              //      if(place != null){
              //           setState(() {
              //             location = place.description.toString();
              //           });

              //          //form google_maps_webservice package
              //          final plist = GoogleMapsPlaces(apiKey:google_api_key,
              //                 apiHeaders: await GoogleApiHeaders().getHeaders(),
              //                           //from google_api_headers package
              //           );
              //           String placeid = place.placeId ?? "0";
              //           final detail = await plist.getDetailsByPlaceId(placeid);
              //           final geometry = detail.result.geometry!;
              //           final lat = geometry.location.lat;
              //           final lang = geometry.location.lng;
              //           var newlatlang = LatLng(lat, lang);
                        

              //           //move map camera to selected place with animation
              //           mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
              //      }
              //    },
                
              //       child: Card(
              //          child: TextButton(
              //           onPressed: () {
                          
              //            // getPLaceAddressDetails(details.placeid, context);
              //           },
              //            child: Container(
              //              padding: EdgeInsets.all(0),
              //              width: MediaQuery.of(context).size.width - 10,
              //              child: ListTile(
              //                 title:Text(location, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 15),),
              //                 leading: Icon(Icons.local_taxi, color: Colors.black),
              //                 dense: true,
              //              )
              //            ),
              //          ),
              //       ),
                 
              //  )