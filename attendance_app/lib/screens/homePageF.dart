import 'package:attendance_app/main.dart';
import 'package:attendance_app/screens/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/titleDropDown.dart';

class HomePageF extends StatefulWidget {
  @override
  _HomePageFState createState() => _HomePageFState();
}

class _HomePageFState extends State<HomePageF> {
  var user;

  @override
  void initState() {
    user = getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Hello!!\n${user!.displayName ?? "User"}",
                        style: GoogleFonts.rubik(
                          textStyle: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w500,
                            // overflow: TextOverflow.fade,
                          ),
                        ),
                        overflow: TextOverflow.fade,
                      ),
                    ),
                    PopupMenuButton(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      offset: Offset(0, 60),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            enabled: false,
                            child: Text(
                              'Name : ${user!.displayName}',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            enabled: false,
                            child: Text(
                              'Email : ${user!.email}',
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            child: TextButton(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.logout,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Logout',
                                  ),
                                ],
                              ),
                              onPressed: () async {
                                try {
                                  Navigator.pop(context);
                                  await FirebaseAuth.instance
                                      .signOut()
                                      .then((value) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignIn(),
                                      ),
                                    );
                                  });
                                } catch (e) {
                                  print(e);
                                }
                              },
                            ),
                          ),
                        ];
                      },
                      icon: Icon(
                        Icons.account_circle_outlined,
                      ),
                      iconSize: 45,
                    )
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TitleDropDown('Select Department'),
                      SizedBox(
                        height: 20,
                      ),
                      TitleDropDown('Select Year'),
                      SizedBox(
                        height: 20,
                      ),
                      TitleDropDown('Select Division'),
                      SizedBox(
                        height: 20,
                      ),
                      TitleDropDown('Select Batch'),
                      SizedBox(
                        height: 20,
                      ),
                      TitleDropDown('Select Location'),
                      SizedBox(
                        height: 20,
                      ),
                      TitleDropDown('Select Subject'),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.all(15),
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                'Start Attendance',
                                style: GoogleFonts.rubik(
                                  textStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
