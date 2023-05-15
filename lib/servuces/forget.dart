// import 'dart:convert';
// import 'package:final1/ui/auth/mainLogin.dart';
// import 'package:http/http.dart' as http;

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../provider/riderprovider.dart';
// import '../provider/user_provider.dart';
// import '../utils/constant.dart';
// import '../utils/utilities.dart';

// void forgetPassword({
//   required BuildContext context,
//   required String email,
// }) async {
//   try {
//     var userProvider = Provider.of<UserProvider>(context, listen: false);
//     final navigator = Navigator.of(context);
//     //final User user=User(id: '', name: '', email: email, token: '', password: password, phone: '')
//     http.Response res = await http.post(
//       Uri.parse('${Constants.uri}/api/forget-password'),
//       body: jsonEncode({
//         'email': email,
//       }),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8'
//       },
//     );
//     httpErrorHandle(
//       response: res,
//       context: context,
//       onSuccess: () async {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         userProvider.setUser(res.body);
//         await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
//         navigator.pushAndRemoveUntil(
//             MaterialPageRoute(builder: ((context) => const LoginMainScreen())),
//             (route) => false);
//       },
//     );
//   } catch (e) {
//     showSNackBar(
//       context,
//       e.toString(),
//     );
//   }
// }
