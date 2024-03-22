import 'package:attendance_app/main.dart';
import 'package:attendance_app/screens/homePageA.dart';
import 'package:attendance_app/screens/homePageF.dart';
import 'package:attendance_app/screens/signUp.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController siEmailController = TextEditingController();
    TextEditingController siPaswdController = TextEditingController();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sign In to your\naccount',
                  style: GoogleFonts.rubik(
                    textStyle: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),

              // Email field
              TextFormField(
                autofocus: true,
                controller: siEmailController,
                cursorRadius: Radius.circular(15),
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                  ),
                  fillColor: Colors.grey[100],
                  filled: true,
                ),
              ),
              SizedBox(height: 20),

              // Password field
              TextFormField(
                autofocus: true,
                controller: siPaswdController,
                cursorRadius: Radius.circular(15),
                maxLines: 1,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  prefixIcon: Icon(
                    Icons.password_rounded,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: 'Password',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                  ),
                  fillColor: Colors.grey[100],
                  filled: true,
                ),
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        mailType = await checkIdType(
                          siEmailController.text.toString(),
                        );
                        if (mailType == 'None' &&
                            siEmailController.text != adminId) {
                          Fluttertoast.showToast(
                            msg: 'Please use institute email id.',
                            backgroundColor: Colors.red,
                            fontSize: 20,
                            textColor: Colors.white,
                            gravity: ToastGravity.BOTTOM,
                            webBgColor:
                                "	linear-gradient(to right, #F44336, #F44336)",
                            timeInSecForIosWeb: 2,
                            webPosition: "center",
                            webShowClose: true,
                          );
                          return;
                        }
                        try {
                          final credential = await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: siEmailController.text.toString(),
                            password: siPaswdController.text.toString(),
                          )
                              .then((value) async {
                            var returnScreen;
                            if (getCurrentUser().email == adminId) {
                              returnScreen = HomePageA();
                            } else if (mailType == 'faculty') {
                              await fetchStudentData();
                              returnScreen = HomePageF();
                            } else {
                              returnScreen = HomePageF();
                            }
                            // else {
                            //   student homepage return
                            // }
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return returnScreen;
                              }),
                            );
                          });
                        } on FirebaseAuthException catch (e) {
                          Fluttertoast.showToast(
                            msg: e.message.toString(),
                            backgroundColor: Colors.red,
                            fontSize: 20,
                            textColor: Colors.white,
                            gravity: ToastGravity.BOTTOM,
                            webBgColor:
                                "	linear-gradient(to right, #F44336, #F44336)",
                            timeInSecForIosWeb: 2,
                            webPosition: "center",
                            webShowClose: true,
                          );
                        }
                      },
                      child: Text('Sign In'),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account? "),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
                          ),
                        );
                      },
                      child: Text('Sign Up'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
