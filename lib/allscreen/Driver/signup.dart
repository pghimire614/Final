//import 'package:firebase_auth/firebase_auth.dart';

import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shila/allscreen/Driver/tabs/main.dart';
import 'package:shila/allscreen/rider/loginscreen.dart';
import 'package:shila/main.dart';
import 'Vechicle_info.dart';
import 'loginscreen.dart';

class signupdriver extends StatefulWidget {
  const signupdriver({super.key});

  static const String idScreen = "signupdriver";
  @override
  State<signupdriver> createState() => _signupdriverState();
}

class _signupdriverState extends State<signupdriver> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController addressTextEditingController = TextEditingController();
  TextEditingController licenseCollector = TextEditingController();
  TextEditingController confirmpasswordTextEditingController =
      TextEditingController();
  TextEditingController VehicleModel = TextEditingController();
  TextEditingController vehicleColor = TextEditingController();
  TextEditingController VehicleNumber = TextEditingController();

  List<String> vehicleType = ["Car", "Bike"];
  String? selectedVehicletype;
  bool showPassword = false;
  bool loading = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailTextEditingController.dispose();
    passwordTextEditingController.dispose();
  }

  void visible() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;
    // ScaffoldMessenger.of(context)
    //   .showSnackBar(SnackBar(content: Text("nofile choosen")));
    final file = result.files.first;

    final path = result.files.single.path;
    final filename = result.files.single.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Center(
                    child: Image.asset(
                  "images/logo.png",
                )),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    inputFormatters: [LengthLimitingTextInputFormatter(50)],
                    keyboardType: TextInputType.name,
                    controller: nameTextEditingController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        labelText: "Name",
                        labelStyle: TextStyle(
                          fontFamily: "Brand Black",
                          fontSize: 20,
                        ),
                        hintText: "Enter your name",
                        prefixIcon: Icon(Icons.people)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'your name is missing';
                      }
                      return null;
                    },
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),

                //mero code
                //   TextField(
                //     controller: nameTextEditingController,
                //     keyboardType: TextInputType.text,
                //     decoration: InputDecoration(
                //       border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(50)),
                //       labelText: "Name",
                //       labelStyle: TextStyle(
                //         fontFamily: "Brand Black",
                //         fontSize: 20,
                //       ),
                //       hintText: "shila panthi",
                //       hintStyle: TextStyle(
                //         color: Colors.green,
                //         fontSize: 20,
                //       ),
                //     ),
                //     style: TextStyle(fontSize: 20, color: Colors.black),
                //   ),
                // ),

                //   TextField(
                //     controller: emailTextEditingController,
                //     keyboardType: TextInputType.emailAddress,
                //     decoration: InputDecoration(
                //       border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(50)),
                //       labelText: "Email",
                //       labelStyle: TextStyle(
                //         fontFamily: "Brand Black",
                //         fontSize: 20,
                //       ),
                //       hintText: "shila panthi@gmail.com",
                //       hintStyle: TextStyle(
                //         color: Colors.green,
                //         fontSize: 20,
                //       ),
                //     ),
                //     style: TextStyle(fontSize: 20, color: Colors.black),
                //   ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    inputFormatters: [LengthLimitingTextInputFormatter(100)],
                    keyboardType: TextInputType.emailAddress,
                    controller: addressTextEditingController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        labelText: "Address",
                        labelStyle: TextStyle(
                          fontFamily: "Brand Black",
                          fontSize: 20,
                        ),
                        hintText: " Pokhara,Nepal",
                        prefixIcon: Icon(Icons.home)),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter your address';
                      }
                      return null;
                    },
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IntlPhoneField(
                    showCountryFlag: true,
                    dropdownIcon: Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey,
                    ),
                    keyboardType: TextInputType.number,
                    controller: phoneTextEditingController,
                    inputFormatters: [
                      FilteringTextInputFormatter.deny(RegExp(r'/^[0-9 -+]/'))
                    ],
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        labelText: "Phone",
                        labelStyle: TextStyle(
                          fontFamily: "Brand Black",
                          fontSize: 15,
                        ),
                        hintText: " Enter your mobile number",
                        prefixIcon: Icon(Icons.phone_android_outlined)),
                    initialCountryCode: 'NP',
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    inputFormatters: [LengthLimitingTextInputFormatter(100)],
                    keyboardType: TextInputType.emailAddress,
                    controller: emailTextEditingController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontFamily: "Brand Black",
                          fontSize: 20,
                        ),
                        hintText: " enter email john@gmail.com",
                        prefixIcon: Icon(Icons.alternate_email)),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter email';
                      }
                      if (EmailValidator.validate(value) == true) {
                        return null;
                      }
                    },
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),

                //   TextField(
                //     controller: phoneTextEditingController,
                //     keyboardType: TextInputType.phone,
                //     decoration: InputDecoration(
                //       border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(50)),
                //       labelText: "phone",
                //       labelStyle: TextStyle(
                //         fontFamily: "Brand Black",
                //         fontSize: 20,
                //       ),
                //       hintText: "9800737213",
                //       hintStyle: TextStyle(
                //         color: Colors.green,
                //         fontSize: 20,
                //       ),
                //     ),
                //     style: TextStyle(fontSize: 20, color: Colors.black),
                //   ),
                // ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    inputFormatters: [LengthLimitingTextInputFormatter(100)],
                    keyboardType: TextInputType.text,
                    controller: passwordTextEditingController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontFamily: "Brand Black",
                          fontSize: 20,
                        ),
                        hintText: " Enter Password",
                        suffixIcon: GestureDetector(
                          onTap: (() {
                            visible();
                          }),
                          child: Icon(
                            showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                        ),
                        prefixIcon: Icon(Icons.lock_open_outlined)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter correct  password';
                      } else {
                        return null;
                      }
                    },
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),

                  // TextField(
                  //   controller: passwordTextEditingController,
                  //   obscureText: true,
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(50)),
                  //     labelText: "Password",
                  //     labelStyle: TextStyle(
                  //       fontFamily: "Brand Black",
                  //       fontSize: 20,
                  //     ),
                  //     hintStyle: TextStyle(
                  //       color: Colors.green,
                  //       fontSize: 20,
                  //     ),
                  //   ),
                  //   style: TextStyle(fontSize: 20, color: Colors.black),
                  // ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    inputFormatters: [LengthLimitingTextInputFormatter(100)],
                    keyboardType: TextInputType.text,
                    controller: confirmpasswordTextEditingController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        labelText: " Confirm Password",
                        labelStyle: TextStyle(
                          fontFamily: "Brand Black",
                          fontSize: 20,
                        ),
                        hintText: " Re-enter Password",
                        suffixIcon: GestureDetector(
                          onTap: (() {
                            visible();
                          }),
                          child: Icon(
                            showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                        ),
                        prefixIcon: Icon(Icons.lock_open_outlined)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter correct  password';
                      }
                      if (value != passwordTextEditingController) {
                        return 'Password doesnot match';
                      }

                      return null;
                    },
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: licenseCollector,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        hintText: " enter your license number",
                        prefixIcon: Icon(Icons.document_scanner_rounded)),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'license no is  is missing';
                      }
                      return null;
                    },
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
                MaterialButton(
                  minWidth: 30,
                  hoverColor: Color.fromARGB(255, 216, 19, 5),
                  onPressed: () {
                    _pickFile();
                  },
                  child: Text(
                    'Upload License Here ',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  color: Colors.orange,
                ),

//               Padding(
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
//                     SizedBox(
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

                ElevatedButton(
                  onPressed: () {
                    if (nameTextEditingController.text.length < 4) {
                      dispalytoast("your name is not correctr", context);
                    } else if (phoneTextEditingController.text.isEmpty) {
                      dispalytoast("phone number is mandetory", context);
                    } else if (!emailTextEditingController.text
                        .contains("@gmail.com")) {
                      dispalytoast("email is not valid", context);
                    } else if (phoneTextEditingController.text.length < 8) {
                      dispalytoast(
                          "phone number should contain at least 8 ", context);
                    } else {
                      registerNewUser(context);
                    }
                  },
                  child: Text("Register"),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => loginscreenDriver()));
                    },
                    child: Text("Already have a account? Login now"))
              ],
            ),
          ),
        ));
  }

//firebase  authentication  and sand saving the info to the database
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance; // firebase instance
  void registerNewUser(BuildContext context) async {
    final User? firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                //user creation
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      dispalytoast("Error:" + errMsg.toString(), context);
    }))
        .user;

    if (firebaseUser != null) {
      // checking whether user is created or not
      Map userDataMap = {
        //mapping data to the firebase driver
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
        "address": addressTextEditingController.text.trim(),
        "license": licenseCollector.text.trim(),
        // "vehicle_model": VehicleModel.text.trim(),
        // "vehicle_color":vehicleColor.text.trim(),
        // "vehicle_number":VehicleNumber.text.trim(),
      };

      usersRefR.child(firebaseUser.uid).set(userDataMap);
      dispalytoast("Congratulation your account has been created", context);

      Navigator.push(context,
          MaterialPageRoute(builder: ((context) => VehicleInfoScreen())));
      //Navigator.pushNamedAndRemoveUntil(context, loginscreen.idScreen, (route) => false);
    }
  }
}

dispalytoast(String message, context) {
  Fluttertoast.showToast(msg: message);
}
