import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shila/main.dart';
import '../../otp/otp.dart';
import '../forgetpassword.dart';
import '../mainlogin.dart';
import 'tabs/main.dart';
import 'signup.dart';

class loginscreenDriver extends StatefulWidget {
  const loginscreenDriver({super.key});
  static const String idScreen = "logindriver";

  @override
  State<loginscreenDriver> createState() => _loginscreenDriverState();
}

class _loginscreenDriverState extends State<loginscreenDriver> {
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
            SizedBox(height: 10),
            Center(
                child: Image.asset(
              "images/logo.png",
              height: 80,
            )),
            Text(
              "Login as Driver",
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
                        //  border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(50),
                        //   ),
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 15,
                        ),
                        //helperText: " Enter your email ",
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 10),
                        hintText: " Enter email john@gmail.com",
                        //prefixIcon: Icon(Icons.alternate_email)
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter email';
                        }
                        return null;
                      },
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      keyboardType: TextInputType.text,
                      controller: passwordTextEditingController,
                      obscureText: !showPassword,
                      decoration: InputDecoration(
                        //  border: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(50),
                        //   ),
                        labelText: "Password",
                        helperText: " Enter your Password****",
                        labelStyle: TextStyle(fontSize: 15, color: Colors.pink),
                        hintText: "AbCd1234&*",
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
                                  builder: (context) => signupdriver()));
                        },
                        child: Text("Don't have a account? Register here")),
                  ],
                )),
            SizedBox(
              height: 10,
            ),
          ]),
        ),
      ),
    );
  }

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

    if (firebaseUser != null) {
      usersRefR.child(firebaseUser.uid).once().then((event) {
        final dataSnaap = event.snapshot;
        if (dataSnaap.value != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => mainDriver()));
          dispalytoast("You are logged in now", context);
        } else {
          _firebaseAuth.signOut();
          dispalytoast(
              "No record exists for this user. Please create new account",
              context);
        }
      });
    } else {
      dispalytoast("user is", context);

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
