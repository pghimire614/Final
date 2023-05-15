// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// class users{
//   String? id;
//   String? email;
//   String? name;
//   String? phone;
//   users({required this.id, required this.email, required this.name,required this.phone});
//   users.fromSnapshot(DataSnapshot dataSnapshot){
//     // id = dataSnapshot.key;
//     // email = dataSnapshot.value["email"]??"";
//     // name = dataSnapshot.value["name"];
//     // phone = dataSnapshot.value["phone"];
// //   }
//   }  
//}

// we create this model in order to fetch the data which we  will store locally..


import 'package:firebase_database/firebase_database.dart';

class Users {
  String? id;
  String? email;
  String? name;
  String? phone;
  String? address;
  Users({this.id, this.email, this.name, this.phone, this.address}); 
    Users.fromSnapshot(DataSnapshot snap) {
      id= snap.key;
      name=(snap.value as dynamic)["name"];
      email=(snap.value as dynamic)["email"];
      address=(snap.value as dynamic)["address"];
      phone=(snap.value as dynamic)["phone"];

  
  
  
  // Users.fromSnapshot(DataSnapshot dataSnapshot) {


  //   id = dataSnapshot.key;
  //   email = (dataSnapshot.child("email").value.toString()); //email for local storage from database 
  //   name =  (dataSnapshot.child("name").value.toString()); //
  //   phone =  (dataSnapshot.child("phone").value.toString());
  //   address=(dataSnapshot.child("address").value.toString());
  }
}