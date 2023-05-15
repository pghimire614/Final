//import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shila/allscreen/rider/loginscreen.dart';
import 'package:shila/main.dart';


class signup extends StatefulWidget {
  const signup({super.key});
   static const String idScreen = "signup";

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
 
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
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmpasswordTextEditingController= TextEditingController();
  TextEditingController addressTextEditingController = TextEditingController();
 
  @override
  
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();/// aru  thau ma click garda keyword naayos vanera
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
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
                    child:  TextFormField(
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
    
      Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: 
                       TextFormField(
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
                          hintText: " POkhara,Nepal",
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
                    child:   TextFormField(
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
                          fontSize: 20,
                        ),
                            hintText: " enter your mobile number",
                            prefixIcon: Icon(Icons.phone_android_outlined)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'phone no is missing ';
                          }
                          return null;
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
                    child: 
                         TextFormField(
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter email';
                          }
                          return null;
                        },
                         style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    
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
                  ),
    
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: 
                       TextFormField(
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
                              showPassword? Icons.visibility : Icons.visibility_off,
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
                  child: 
                     TextFormField(
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
                              showPassword? Icons.visibility : Icons.visibility_off,
                              color: Colors.black,
                            ),
                          ),
                          prefixIcon: Icon(Icons.lock_open_outlined)),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter correct  password';
                        } 
                        if(value!= passwordTextEditingController){
                          return 'Password doesnot match';
                        }
                        
                          return null;
                        },
                    
                        style: TextStyle(fontSize: 20, color: Colors.black),
                    ),),
    
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
                      child: Text("Signup")),
                  TextButton(
                      onPressed: () {
                           Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => loginscreen() ));
                      },
                      child: Text("Already have a account? Login now"))
                ],
              ),
            ),
          )),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void registerNewUser(BuildContext context) async {
    final User? firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      dispalytoast("Error:" + errMsg.toString(), context);
    })).user;


    if (firebaseUser != null) {
      Map userDataMap = {
        "id":firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
        "address":addressTextEditingController.text.trim(),
      };
      

    
      usersRef.child(firebaseUser.uid).set(userDataMap);
      dispalytoast("congratulation your account has been created", context);

      Navigator.push(context, MaterialPageRoute(builder: ((context) => loginscreen())));
      //Navigator.pushNamedAndRemoveUntil(context, loginscreen.idScreen, (route) => false);
    }
  }
}

dispalytoast(String message, context) {
  Fluttertoast.showToast(msg: message);
}
