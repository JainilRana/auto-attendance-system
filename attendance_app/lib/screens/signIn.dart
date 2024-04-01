import 'package:attendance_app/main.dart';
import 'package:attendance_app/screens/homePageA.dart';
import 'package:attendance_app/screens/homePageF.dart';
import 'package:attendance_app/screens/homePageS.dart';
import 'package:attendance_app/screens/signUp.dart';
import 'package:attendance_app/utils/notification.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController siEmailController = TextEditingController();
    TextEditingController siPaswdController = TextEditingController();
    NotificationService notificationService = NotificationService();
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
                    textStyle: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Email field
              TextFormField(
                autofocus: true,
                controller: siEmailController,
                cursorRadius: const Radius.circular(15),
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15),
                  prefixIcon: const Icon(
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
              const SizedBox(height: 20),

              // Password field
              TextFormField(
                autofocus: true,
                controller: siPaswdController,
                cursorRadius: const Radius.circular(15),
                maxLines: 1,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15),
                  prefixIcon: const Icon(
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
              const SizedBox(height: 40),
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
                              returnScreen = HomePageS();
                            }
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return returnScreen;
                                },
                              ),
                            );
                            if (mailType == 'student') {
                              String deviceToken =
                                  await notificationService.getDeviceToken();
                              db
                                  .collection('student_id')
                                  .doc(getCurrentUser().email.toString())
                                  .set({
                                'token': deviceToken,
                              });
                            }
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
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                      ),
                      child: const Text('Sign In'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUp(),
                          ),
                        );
                      },
                      child: const Text('Sign Up'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
