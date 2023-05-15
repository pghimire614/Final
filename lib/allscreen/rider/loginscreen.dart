import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shila/allscreen/rider/rider.dart';
import 'package:shila/main.dart';
import '../../otp/otp.dart';
import '../forgetpassword.dart';
import '../mainlogin.dart';
import 'signup.dart';

class loginscreen extends StatefulWidget {
  const loginscreen({super.key});
  static const String idScreen = "login";
  @override
  State<loginscreen> createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => LoginMainScreen())),
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            SizedBox(
              height: 10,
            ),
            Center(child: Image.asset("images/logo.png")),
            Text(
              "Login as Rider",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Brand semibold"),
            ),
            SizedBox(
              height: 2,
            ),
            Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    TextFormField(
                      inputFormatters: [LengthLimitingTextInputFormatter(100)],
                      controller: emailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        helperText: " Enter your email ",
                        labelStyle: TextStyle(
                          fontSize: 15,
                        ),
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        //  border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(50),
                        //   ),
                        labelText: "Password",

                        labelStyle: TextStyle(
                            fontSize: 15, color: Color.fromARGB(255, 4, 2, 3)),
                        helperText: " Enter your Password****",
                        hintText: "Ab238748#",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                        //prefixIcon: Icon(Icons.lock_open_outlined),
                        suffixIcon: GestureDetector(
                          onTap: (() {
                            visible();
                          }),
                          child: Icon(
                            showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (!emailTextEditingController.text.contains("@")) {
                            dispalytoast("email is not valid", context);
                          } else if (passwordTextEditingController
                              .text.isEmpty) {
                            dispalytoast("password is mandatory", context);
                          } else {
                            // Navigator.pushNamedAndRemoveUntil(
                            //     context, map.idScreen, (route) => false);
                            print("k xa hajur");
                            loginuser(context);
                          }
                        },
                        style: ButtonStyle(),
                        child: Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        )),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Forget password ?",
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordScreen()));
                            },
                            child: Text(
                              "Click here",
                            ))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => otp()));
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.green,
                            border: Border.all(color: Colors.black)),
                        child: Center(
                          child: Text("login with phone"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => signup()));
                        },
                        child: Text("Don't have a account? Register here")),
                  ],
                )),
          ]),
        ),
      ),
    );
  }

//authenticating the firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void loginuser(BuildContext context) async {
    final User? firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: emailTextEditingController.text,
                password: passwordTextEditingController.text)
            .catchError((errMsg) {
      dispalytoast("Error:" + errMsg.toString(), context);
    }))
        .user;
    //checking if the user is signis or not
    if (firebaseUser != null) {
      usersRef.child(firebaseUser.uid).once().then((event) {
        //comparing input with database data
        final dataSnaap = event.snapshot;
        if (dataSnaap.value != null) {
          //if data is present then login
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => rider()));
          dispalytoast("You are logged in now", context);
        } else {
          _firebaseAuth.signOut(); //display toast
          dispalytoast(
              "No record exists for this user. Please create new account",
              context);
        }
      });
    } else {
      dispalytoast("user is not signed  in ", context);

      // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
      // void loginuser(BuildContext context) async {
      //   (await _firebaseAuth
      //       .signInWithEmailAndPassword(
      //           email: _emailController.text, password: _passwordController.text)
      //       .then((value) {
      //     Navigator.push(context, MaterialPageRoute(builder: (context) => rider()));
      //   })
      //       // ignore: body_might_complete_normally_catch_error
      //       .catchError((errMsg) {
      //     dispalytoast("Error:" + errMsg.toString(), context);
      //   }));
      //     .user;
    }
  }
}
