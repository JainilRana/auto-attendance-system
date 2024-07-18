import 'package:attendance_app/main.dart';
import 'package:attendance_app/screens/homePageA.dart';
import 'package:attendance_app/screens/homePageF.dart';
import 'package:attendance_app/screens/homePageS.dart';
import 'package:attendance_app/screens/signIn.dart';
import 'package:attendance_app/utils/notification.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

String mailType = 'None';
checkIdType(String mailId) async {
  mailType = 'None';
  if (mailType == 'None') {
    await db.collection('admin_id').get().then((value) {
      for (var element in value.docs) {
        if (element.id.toLowerCase() == mailId.toLowerCase()) {
          mailType = 'admin';
        }
      }
    });
  }
  if (mailType == 'None') {
    await db.collection('faculty_id').get().then((value) {
      for (var element in value.docs) {
        if (element.id.toLowerCase() == mailId.toLowerCase()) {
          mailType = 'faculty';
        }
      }
    });
  }
  if (mailType == 'None') {
    await db.collection('student_id').get().then((value) {
      for (var element in value.docs) {
        if (element.id.toLowerCase() == mailId.toLowerCase()) {
          mailType = 'student';
        }
      }
    });
  }
  return mailType;
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    TextEditingController suNameController = TextEditingController();
    TextEditingController suEmailController = TextEditingController();
    TextEditingController suPaswdController = TextEditingController();
    NotificationService notificationService = NotificationService();
    ValueNotifier processing = ValueNotifier(false);
    ValueNotifier obscureTxt = ValueNotifier(true);
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
                  'Sign Up to your\naccount',
                  style: GoogleFonts.rubik(
                    textStyle: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Name field
              TextFormField(
                autofocus: true,
                controller: suNameController,
                cursorRadius: const Radius.circular(15),
                maxLines: 1,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(15),
                  prefixIcon: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: 'Name',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                  ),
                  fillColor: Colors.grey[100],
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),

              // Email field
              TextFormField(
                autofocus: true,
                controller: suEmailController,
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
              ValueListenableBuilder(
                valueListenable: obscureTxt,
                builder: (context, value, child) {
                  return TextFormField(
                    autofocus: true,
                    controller: suPaswdController,
                    cursorRadius: const Radius.circular(15),
                    maxLines: 1,
                    obscureText: value,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(15),
                      prefixIcon: const Icon(
                        Icons.password_rounded,
                        color: Colors.black,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          obscureTxt.value = !obscureTxt.value;
                        },
                        color: Colors.grey,
                        icon: value
                            ? Icon(
                                Icons.visibility_rounded,
                              )
                            : Icon(
                                Icons.visibility_off_rounded,
                              ),
                        splashRadius: 0.1,
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
                  );
                },
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        processing.value = true;
                        bool flag = false;
                        if (suNameController.text.isEmpty ||
                            suEmailController.text.isEmpty ||
                            suPaswdController.text.isEmpty) {
                          Fluttertoast.showToast(
                            msg: suNameController.text.isEmpty
                                ? 'Please enter your name.'
                                : suEmailController.text.isEmpty
                                    ? 'Please enter email.'
                                    : 'Please enter password.',
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
                          processing.value = false;
                          return;
                        }
                        if (flag == false) {
                          mailType = await checkIdType(
                              suEmailController.text.toString());
                          print(mailType);
                          if (mailType == 'faculty' ||
                              mailType == 'student' ||
                              mailType == 'admin') {
                            flag = true;
                          }
                        }
                        if (flag == false) {
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
                          processing.value = false;
                          return;
                        }
                        try {
                          final credential = await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                            email: suEmailController.text.toString(),
                            password: suPaswdController.text.toString(),
                          )
                              .then((value) async {
                            if (getCurrentUser() != null) {
                              getCurrentUser()
                                  .updateDisplayName(
                                      suNameController.text.toString())
                                  .then((value) {
                                processing.value = false;
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) {
                                    if (mailType == 'admin') {
                                      return const HomePageA();
                                    } else if (mailType == 'faculty') {
                                      return const HomePageF();
                                    } else {
                                      return const HomePageS();
                                    }
                                  }),
                                );
                              });
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
                              if (mailType == 'faculty') {
                                db
                                    .collection('faculty_id')
                                    .doc(suEmailController.text
                                        .toString()
                                        .toLowerCase())
                                    .set({
                                  'uid': getCurrentUser().uid,
                                });
                              }
                              print(suNameController.text.toString());
                            }
                          });
                        } on FirebaseAuthException catch (e) {
                          processing.value = false;
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
                        } catch (e) {
                          processing.value = false;
                          print(e);
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
                      child: ValueListenableBuilder(
                        valueListenable: processing,
                        builder: (context, value, child) {
                          if (value == true) {
                            return SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeCap: StrokeCap.round,
                                strokeWidth: 2,
                              ),
                            );
                          } else {
                            return const Text('Sign Up');
                          }
                        },
                      ),
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
                  const Text("Already have an account? "),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignIn(),
                          ),
                        );
                      },
                      child: const Text('Sign In'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
