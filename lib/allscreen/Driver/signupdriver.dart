// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'loginscreen.dart';

// class SignupDScreen extends StatefulWidget {
//   const SignupDScreen({super.key});

//   @override
//   State<SignupDScreen> createState() => _SignupDScreenState();
// }

// class _SignupDScreenState extends State<SignupDScreen> {
//   final _FormKey = GlobalKey<FormState>();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final fnameController = TextEditingController();

//   final phoneController = TextEditingController();
//   final licenseCollector = TextEditingController();
//   final vehicleController = TextEditingController();

//   final AuthServices authServices = AuthServices();
//   //final imageController = hi ;
//   bool loading = false;
//   File? image;

//   void _pickFile() async {
//     final result = await FilePicker.platform.pickFiles(allowMultiple: true);
//     if (result == null) return;
//     // ScaffoldMessenger.of(context)
//     //   .showSnackBar(SnackBar(content: Text("nofile choosen")));
//     final file = result.files.first;

//     final path = result.files.single.path;
//     final filename = result.files.single.name;
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     emailController.dispose();
//     passwordController.dispose();
//   }

//   void signup() {
//     setState(() {
//       loading = true;
//     });
//     authServices.signUpUser(
//       context: context,
//       email: emailController.text,
//       password: passwordController.text,
//       name: fnameController.text,
//       phone: phoneController.text,
//       licenseNo: licenseCollector.text,
//       vehicleNo: vehicleController.text,
//     );
//     Timer(
//       Duration(milliseconds: 3500),
//       () => Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => LoginDScreen()),
//       ),
//     );
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(18),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               SizedBox(
//                 height: 42,
//               ),
//               Text("Fill in registration from to get stared"),
//               SizedBox(
//                 height: 12,
//               ),
//               Form(
//                 key: _FormKey,
//                 child: Column(
//                   children: [
//                     TextFormField(
//                       keyboardType: TextInputType.name,
//                       controller: fnameController,
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(26),
//                           ),
//                           hintText: "Enter your name",
//                           prefixIcon: Icon(Icons.people)),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'your name is missing';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     TextFormField(
//                       keyboardType: TextInputType.number,
//                       controller: phoneController,
//                       inputFormatters: [
//                         FilteringTextInputFormatter.deny(RegExp(r'/^[0-9 -+]/'))
//                       ],
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(26),
//                           ),
//                           hintText: " enter your mobile number",
//                           prefixIcon: Icon(Icons.phone_android_outlined)),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'phone no is missing ';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     TextFormField(
//                       keyboardType: TextInputType.emailAddress,
//                       controller: emailController,
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(26),
//                           ),
//                           hintText: " enter email john@gmail.com",
//                           prefixIcon: Icon(Icons.alternate_email)),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Enter email';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     TextFormField(
//                       keyboardType: TextInputType.text,
//                       controller: passwordController,
//                       obscureText: true,
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(26),
//                           ),
//                           hintText: " Enter Password",
//                           prefixIcon: Icon(Icons.lock_open_outlined)),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'Enter correct  password';
//                         } else {
//                           return null;
//                         }
//                       },
//                     ),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     TextFormField(
//                       keyboardType: TextInputType.text,
//                       controller: licenseCollector,
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(26),
//                           ),
//                           hintText: " enter your license number",
//                           prefixIcon: Icon(Icons.document_scanner_rounded)),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'license no is  is missing';
//                         }
//                         return null;
//                       },
//                     ),
//                     SizedBox(
//                       height: 12,
//                     ),
//                     TextFormField(
//                       keyboardType: TextInputType.text,
//                       controller: vehicleController,
//                       decoration: InputDecoration(
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(26),
//                           ),
//                           hintText: " enter vehicle number",
//                           prefixIcon: Icon(Icons.numbers_rounded)),
//                       validator: (value) {
//                         if (value!.isEmpty) {
//                           return 'vehicle no missing';
//                         }
//                         return null;
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               MaterialButton(
//                 minWidth: 30,
//                 hoverColor: Color.fromARGB(255, 216, 19, 5),
//                 onPressed: () {
//                   _pickFile();
//                 },
//                 child: Text(
//                   'Upload License Here ',
//                   style: TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//                 color: Colors.orange,
//               ),
//               Rounded(
//                 title: 'Sign Up',
//                 loading: loading,
//                 onTap: () {
//                   if (_FormKey.currentState!.validate()) {
//                     signup();
//                   }
//                 },
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "Already have  an account ?",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   TextButton(
//                       onPressed: () {
//                         {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => LoginMainScreen()));
//                         }
//                       },
//                       child: Text(
//                         "Login",
//                       ))
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
