import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shila/DataHandeler/appData.dart';
import 'package:shila/allscreen/rider/precisepickupposition.dart';
import '../../Assistants/requestAssistant.dart';
import '../../button/progress.dart';
import '../../models/address.dart';
import '../../models/placePredictions.dart';
import '../constants.dart';


class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
 
  GoogleMapController? mapController; //contrller for Google map
  //CameraPosition? cameraPosition;
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  static const _initialPosition= LatLng(28.07, 83.98);
  //static LatLng lastposition= _initialPosition;
  final Set<Marker> _markers ={};
  List<PlacePredictions>  placePredictionList=[];  

 //final Set<Polyline> _polyLines = {};
 String location = "Search Location"; 
@override
void initState() {
    super.initState();
    //_getUserLocation();
   
  }

  @override
  Widget build(BuildContext context) {
     String placeAddress=Provider.of<AppData>(context).pickUpLocation!.placeName ?? "";
    pickUpTextEditingController.text=placeAddress;
  
    return
    //   _initialPosition == null? Container(alignment: Alignment.center,
    // child: Center(child: CircularProgressIndicator(),
    // ),
    // ):
    Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:             //pickup location .. destination
           Stack(
            
            children:[
               GoogleMap(  //Map widget from google_maps_flutter package
                  zoomGesturesEnabled: true, //enable Zoom in, out on map
                  initialCameraPosition: CameraPosition( //innital position in map
                    target: _initialPosition, //initial position
                    zoom: 14.0, //initial zoom level
                  ),
                  mapType: MapType.none, //map type
                  onMapCreated: (controller) { //method called when map is created
                    setState(() {
                      mapController = controller; 
                    });
                  },
             ),
                           Positioned(
                                top: 20,
                                right: 15,
                                left: 15,
                                child: Container(
                                height: 50.0,
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
                                  padding: EdgeInsets.all(3.0),
                                  child: TextField(
                                    cursorColor:Colors.black,
                                    controller: pickUpTextEditingController,
                                    decoration: InputDecoration(
                                      icon: Container(margin: EdgeInsets.only(left: 20,top: 5),width: 10, height:10 ,child: Icon(Icons.location_on, color: Colors.black,),),
                                      hintText: "PickUp Location",
                                      fillColor: Colors.white,
                                      filled: true,
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.only(
                                          left: 15.0, top: 8.0, bottom: 8.0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                           //drop off location
                    Positioned(
                                  top: 73,
                                  right: 15,
                                  left: 15,
                                  child: Container(
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
                                              padding: EdgeInsets.all(3.0),
                                              child:TextField(
                                                   onChanged: (val) {
                                                     findPlace(val);
                                                     },
                                                 cursorColor:Colors.black,
                                                 controller: dropOffTextEditingController,
                                                 decoration: InputDecoration(
                                                icon: Container(margin: EdgeInsets.only(left: 20,top: 5),width: 10, height:10 ,child: Icon(Icons.local_taxi, color: Colors.black),),
                                                hintText: "Destination",
                                                fillColor: Colors.white,
                                                filled: true,
                                                border: InputBorder.none,
                                                isDense: true,
                                                contentPadding: EdgeInsets.only(
                                                left: 15.0, top: 8.0, bottom: 8.0),
                                                 ),
                                               ),
                                           ),
                                   ),
                             ),
                             Positioned(
                                bottom: 0,
                                right: 15,
                                left: 15,
                                child: Container(
                                height: 50.0,
                                width:50,
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
                                  padding: EdgeInsets.all(3.0),
                                  child: ElevatedButton(
                                    onPressed: (){
                                     Navigator.push(context,MaterialPageRoute(builder: (context) => PrecisePickupScreen()));
                                    },
                                    child: Text("change Pickup",style: TextStyle(color:Colors.black)),
                                    style: ElevatedButton.styleFrom(shadowColor: Colors.blueAccent,textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 15)),

                                  ),
                                ),
                              ),),    
                    Positioned(
                    top: 100,
                                  right: 15,
                                  left: 15,
                    child: Column(children: [
                      SizedBox(height: 10,),
                //place prediction list
                   (placePredictionList.length >0)
                  ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0,horizontal: 16.0),
                  child: ListView.separated(
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context, index){
                      return PredictionTile(placePredictions: placePredictionList[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) => Divider(), 
                    itemCount: placePredictionList.length,
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    ),
                  )
                  :Container(),

                   ],))
                  
                 
                  ],
                 ),
             
             );

  }
 

// code  for autoplace 
    void findPlace(String placeName) async {
    if (placeName.length > 1) {
      String autoCompleteUrl =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$google_api_key&components=country:NP";//components for country specific..here place name is input from user
      var res = await RequestAssistant.getRequest(autoCompleteUrl);
      if (res == "failed") {
        return;
        
      }
      if(res ["status"] == "OK"){
       var predictions = res["predictions"];
       var placeList =(predictions as List).map((e) => PlacePredictions.fromjson(e)).toList();
      setState(() {
        placePredictionList=placeList;
      });
      }
    
      
     
   }
    }
    }


//list for showing destion 
class PredictionTile extends StatelessWidget
{
  final PlacePredictions placePredictions;

  PredictionTile({ Key? key, required this.placePredictions}) : super(key: key);
  @override
  Widget build(BuildContext context)
  {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: TextButton(
        onPressed: () { 
          getPlaceAddressDetails(placePredictions.place_id??"", context); ///else case will never execute if execute this is wrong
          print("hello");
         },
        child: Container(
          child: Column(
            children: [
              SizedBox(width: 10.0,),
              Row(
                children: [
                  Icon(Icons.add_location,color: Colors.redAccent,),
                  SizedBox(width: 14.0,),
                 
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        
                        SizedBox(height: 10.0,),
                        Text(placePredictions.main_text??"",overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0),), //show suggestion
                        SizedBox(height: 3.0,),
                        Text(placePredictions.secondary_text??"",overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 12.0,color: Colors.grey),),
                        SizedBox(height: 10.0,),
                      ],
                    ),
                  ),
                  
                ],
              ),
              SizedBox(width: 10.0,),
            ],
          ),
        ),
      ),
    );
  }



 //code for geting json data from string
void getPlaceAddressDetails(String placeId, context) async{
    showDialog(context: context,
        builder: (BuildContext context) => ProgressDialog(message: "Setting DropOff, Please wait ...",)
   );
    String placeDetailsUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$google_api_key";
    var res = await RequestAssistant.getRequest(placeDetailsUrl);
    //print("go with the flow");
     Navigator.pop(context);
    if(res == "failed"){
      //print("again error");
      return;
    }
    if(res["status"] == "OK")
    {
      Address address = Address();
      address.placeName = res["result"]["name"];
      address.placeId = placeId;
      address.latitude = res["result"]["geometry"]["location"]["lat"];
      address.longitude = res["result"]["geometry"]["location"]["lng"];
      Provider.of<AppData>(context, listen: false).updatedropOffLocationAddress(address);
      print("This is Drop Off Location ::");
      print(address.placeName);
      
      Navigator.pop(context,"abc");
      
   
     
    }

  }

}

