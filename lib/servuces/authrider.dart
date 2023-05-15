// import 'dart:convert';
// import 'package:final1/provider/riderprovider.dart';
// import 'package:final1/provider/user_provider.dart';
// import 'package:final1/ui/auth/loginscreen.dart';
// import 'package:final1/ui/mainscreen.dart';
// import 'package:final1/utils/constant.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../Models/rider.dart';
// import '../ui/auth/loginRider.dart';
// import '../ui/auth/mainLogin.dart';
// import '../utils/utilities.dart';

// class AuthServicesR {
//   void signUpRider({
//     required BuildContext context,
//     required String email,
//     required String password,
//     required String name,
//     required String phone,
//   }) async {
//     try {
//       Rider user = Rider(
//         id: "",
//         name: name,
//         email: email,
//         token: "",
//         password: password,
//         phone: phone,
//       );
//       http.Response res = await http.post(
//         Uri.parse('${Constants.uri}/api/signupR'),
//         body: user.toJson(),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8'
//         },
//       );

//       httpErrorHandle(
//           response: res,
//           context: context,
//           onSuccess: () {
//             showSNackBar(
//               context,
//               "Account created! Login with the same credential!",
//             );
//           });
//     } catch (e) {
//       showSNackBar(context, e.toString());
//     }
//   }

//   void signInRider({
//     required BuildContext context,
//     required String email,
//     required String password,
//   }) async {
//     try {
//       var userProvider = Provider.of<UserProviderR>(context, listen: false);
//       final navigator = Navigator.of(context);
//       //final User user=User(id: '', name: '', email: email, token: '', password: password, phone: '')
//       http.Response res = await http.post(
//         Uri.parse('${Constants.uri}/api/signinR'),
//         body: jsonEncode({
//           'email': email,
//           'password': password,
//         }),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8'
//         },
//       );
//       httpErrorHandle(
//         response: res,
//         context: context,
//         onSuccess: () async {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           userProvider.setUserR(res.body);
//           await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
//           navigator.pushAndRemoveUntil(
//               MaterialPageRoute(builder: ((context) => const MainScreen())),
//               (route) => false);
//         },
//       );
//     } catch (e) {
//       showSNackBar(
//         context,
//         e.toString(),
//       );
//     }
//   }

//   void getUserDataR(BuildContext context) async {
//     try {
//       var userProvider = Provider.of<UserProviderR>(context, listen: false);
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString('x-auth-token');
//       if (token == null) {
//         prefs.setString('x-auth-token', '');
//       }
//       var tokenRes = await http.post(
//         Uri.parse('${Constants.uri}/tokenIsValidR'),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8',
//           'x-auth-token': token!,
//         },
//       );
//       var response = jsonDecode(tokenRes.body);
//       if (response == true) {
//         http.Response userRes = await http.get(
//           Uri.parse('${Constants.uri}/R'),
//           headers: <String, String>{
//             'Content-Type': 'application/json; charset=UTF-8',
//             'x-auth-token': token,
//           },
//         );
//         userProvider.setUserR(userRes.body);
//       }
//     } catch (e) {
//       showSNackBar(context, e.toString());
//     }
//   }

//   void signOutR(BuildContext context) async {
//     final navigator = Navigator.of(context);
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString('x-auth-token', '');
//     navigator.pushAndRemoveUntil(
//         MaterialPageRoute(
//           builder: (context) => const LoginRScreen(),
//         ),
//         (route) => false);
//   }

//   void forgetPassword({
//     required BuildContext context,
//     required String email,
//   }) async {
//     try {
//       var userProvider = Provider.of<UserProvider>(context, listen: false);
//       final navigator = Navigator.of(context);
//       //final User user=User(id: '', name: '', email: email, token: '', password: password, phone: '')
//       http.Response res = await http.post(
//         Uri.parse('${Constants.uri}/api/reset-password'),
//         body: jsonEncode({
//           'email': email,
//         }),
//         headers: <String, String>{
//           'Content-Type': 'application/json; charset=UTF-8'
//         },
//       );
//       httpErrorHandle(
//         response: res,
//         context: context,
//         onSuccess: () async {
//           SharedPreferences prefs = await SharedPreferences.getInstance();
//           userProvider.setUser(res.body);
//           await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
//           navigator.pushAndRemoveUntil(
//               MaterialPageRoute(
//                   builder: ((context) => const LoginMainScreen())),
//               (route) => false);
//         },
//       );
//     } catch (e) {
//       showSNackBar(
//         context,
//         e.toString(),
//       );
//     }
//   }
// }
