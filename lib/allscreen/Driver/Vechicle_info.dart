import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shila/allscreen/constants.dart';

import '../../main.dart';

import 'loginscreen.dart';
class VehicleInfoScreen extends StatefulWidget {
  const VehicleInfoScreen({super.key});

  @override
  State<VehicleInfoScreen> createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  TextEditingController VehicleModel = TextEditingController();
  TextEditingController vehicleColor = TextEditingController();
  TextEditingController VehicleNumber = TextEditingController();

List<String> vehicleType=["Car","Bike"];
String? selectedVehicletype;

// final abcd=GlobalKey<FormState>();
final _formKey=GlobalKey<FormState>();


abcd() async {
if(_formKey.currentState!.validate()){
Map driverVehicleInfoMap={
  "vehicle_model":VehicleModel.text.trim(),
  "vehicle_color":vehicleColor.text.trim(),
  "vehicle_number":VehicleNumber.text.trim(),};

final user = FirebaseAuth.instance.currentUser!;
DatabaseReference reference= FirebaseDatabase.instance.ref().child("driver").child(user.uid)
.child("vehicle_details");
reference.set(driverVehicleInfoMap);
Fluttertoast.showToast(msg: "Car Details has been saved, Congratultion!!...");
Navigator.push(context, MaterialPageRoute(builder: (context)=> loginscreenDriver()));

}
}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Focus.of(context).unfocus();
      },
    child: Scaffold(
      body: ListView(
        padding: EdgeInsets.all(0),
        children: [
          Column(
            children: [
              Center(
                    child: Image.asset(
                  "images/logo.png",
                )),
                SizedBox(
                  height: 20,
                ),
              Text("Add Vehicle Details",style: TextStyle(color:Colors.blue,fontSize: 25,  fontWeight: FontWeight.bold),),
     
      SizedBox(
                  height: 20,
                ),
      Padding(padding: EdgeInsets.all(15),
      child: Column(children: [
         Form(
         key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                      inputFormatters: [LengthLimitingTextInputFormatter(100)],
                      keyboardType: TextInputType.text,
                     // controller: VehicleModel,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                            labelText: "Vehicle Model",
                            labelStyle: TextStyle(
                            fontFamily: "Brand Black",
                            fontSize: 20,
                             ),
                          hintText: " maruti",
                          prefixIcon: Icon(Icons.file_copy)),
                          autovalidateMode: AutovalidateMode.onUserInteraction, 
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your Vehicle Model';
                        }
                        return null;
                        
                      },
                       onChanged: (text)=>setState(() {
                        VehicleModel.text=text;
                      }),
                       style: TextStyle(fontSize: 20, color: Colors.black),
                    ),

                    SizedBox(height: 20,),

                     TextFormField(
                      inputFormatters: [LengthLimitingTextInputFormatter(100)],
                      keyboardType: TextInputType.text,
                     // controller: vehicleColor,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                            labelText: "Vehicle color",
                            labelStyle: TextStyle(
                            fontFamily: "Brand Black",
                            fontSize: 20,
                             ),
                          hintText: " Red",
                          prefixIcon: Icon(Icons.color_lens)),
                          autovalidateMode: AutovalidateMode.onUserInteraction, 
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your Vehicle Color';
                        }
                        return null;
                        
                      },
                       onChanged: (text)=>setState(() {
                        vehicleColor.text=text;
                      }),
                      
                       style: TextStyle(fontSize: 20, color: Colors.black),
                    ),

                    SizedBox(height: 20,),

                     TextFormField(
                      inputFormatters: [LengthLimitingTextInputFormatter(100)],
                      keyboardType: TextInputType.text,
                      //controller: VehicleNumber,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                            labelText: "Vehicle Number",
                            labelStyle: TextStyle(
                            fontFamily: "Brand Black",
                            fontSize: 20,
                             ),
                          hintText: " BA 2 PA 2030",
                          prefixIcon: Icon(Icons.numbers)),
                          autovalidateMode: AutovalidateMode.onUserInteraction, 
                          
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter your Vehicle Number';
                        }
                        return null;
                        
                      },
                      onChanged: (text)=>setState(() {
                        VehicleNumber.text=text;
                      }),
                       style: TextStyle(fontSize: 20, color: Colors.black),
                    ),

                     SizedBox(height: 20,),

                       DropdownButtonFormField(
                        decoration: InputDecoration(
                        hintText: "please choose your vehicle type",
                        prefixIcon: Icon(Icons.car_crash, color: Colors.grey,),
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(40),
                         borderSide: BorderSide(
                             width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                       ),
                    items: vehicleType.map((car) {
                     return DropdownMenuItem(child: Text(car,style: TextStyle(color: Colors.grey),
                      ),
                    value: car,
                      ); }).toList(),
            onChanged: (newValue){
              setState(() {
                selectedVehicletype=newValue.toString();
              });
            } ),
               SizedBox(height: 20,),

              ElevatedButton(
                    onPressed: () {
                        abcd();
                  
                      },
                    child: Text("Confirm")),

                TextButton(
                    onPressed: () {
                          Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>  loginscreenDriver() ));
                    },
                    child: Text("Already have a account? Login now"),),
    

            ],
          )),

      ]),),

//                  Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: 
//                        TextFormField(
//                       inputFormatters: [LengthLimitingTextInputFormatter(100)],
//                       keyboardType: TextInputType.text,
//                       controller: VehicleModel,
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(100),
//                           ),
//                             labelText: "Vehicle Model",
//                             labelStyle: TextStyle(
//                             fontFamily: "Brand Black",
//                             fontSize: 20,
//                              ),
//                           hintText: " maruti",
//                           prefixIcon: Icon(Icons.file_copy)),
//                           autovalidateMode: AutovalidateMode.onUserInteraction, 
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Enter your Vehicle Model';
//                         }
//                         return null;
                        
//                       },
//                        style: TextStyle(fontSize: 20, color: Colors.black),
//                     ),
//           ),

//   SizedBox(
//                   height: 10,
//                 ),
//                  Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: 
//                        TextFormField(
//                       inputFormatters: [LengthLimitingTextInputFormatter(100)],
//                       keyboardType: TextInputType.text,
//                       controller: vehicleColor,
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(100),
//                           ),
//                             labelText: "Vehicle color",
//                             labelStyle: TextStyle(
//                             fontFamily: "Brand Black",
//                             fontSize: 20,
//                              ),
//                           hintText: " Red",
//                           prefixIcon: Icon(Icons.color_lens)),
//                           autovalidateMode: AutovalidateMode.onUserInteraction, 
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Enter your Vehicle Color';
//                         }
//                         return null;
                        
//                       },
//                        style: TextStyle(fontSize: 20, color: Colors.black),
//                     ),
//           ),

// SizedBox(
//                   height: 10,
//                 ),
//                  Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: 
//                        TextFormField(
//                       inputFormatters: [LengthLimitingTextInputFormatter(100)],
//                       keyboardType: TextInputType.text,
//                       controller: VehicleModel,
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(100),
//                           ),
//                             labelText: "Vehicle Number",
//                             labelStyle: TextStyle(
//                             fontFamily: "Brand Black",
//                             fontSize: 20,
//                              ),
//                           hintText: " BA 2 PA 2030",
//                           prefixIcon: Icon(Icons.numbers)),
//                           autovalidateMode: AutovalidateMode.onUserInteraction, 
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Enter your Vehicle Number';
//                         }
//                         return null;
                        
//                       },
//                        style: TextStyle(fontSize: 20, color: Colors.black),
//                     ),
//           ),
//           SizedBox(height: 10,),


//           DropdownButtonFormField(
//             decoration: InputDecoration(
//               hintText: "please choose your vehicle type",
//               prefixIcon: Icon(Icons.car_crash, color: Colors.grey,),
//               filled: true,
//               fillColor: Colors.grey.shade200,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(40),
//                 borderSide: BorderSide(
//                   width: 0,
//                   style: BorderStyle.none,
//                 ),
//               ),
//             ),
//        items: vehicleType.map((car) {
//                 return DropdownMenuItem(child: Text(car,style: TextStyle(color: Colors.grey),
//               ),
//               value: car,
//               );

//             }).toList(),
//             onChanged: (newValue){
//               setState(() {
//                 selectedVehicletype=newValue.toString();
//               });
//             } ),
//          ElevatedButton(
//                     onPressed: () {
//                         _submit();
                  
//                       },
//                     child: Text("Confirm")),
//                 TextButton(
//                     onPressed: () {
//                           Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) =>  loginscreenDriver() ));
//                     },
//                     child: Text("Already have a account? Login now"),),
          
            ],
          )
        ],
      ),
    ),
    );
  }
}