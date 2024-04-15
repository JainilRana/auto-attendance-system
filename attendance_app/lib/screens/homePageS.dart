import 'package:attendance_app/main.dart';
import 'package:attendance_app/screens/signIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

var formatter = DateFormat('dd-MM-yyyy');
var timeFormatter = DateFormat('hh:mm a');

class HomePageS extends StatefulWidget {
  const HomePageS({super.key});
  @override
  State<HomePageS> createState() => _HomePageSState();
}

class _HomePageSState extends State<HomePageS> {
  var user;
  Future<QuerySnapshot<Map<String, dynamic>>>? attendanceList;

  @override
  void initState() {
    super.initState();
    user = getCurrentUser();
    fetchAttendance();
    listenToFirestoreChanges();
  }

  fetchAttendance() {
    attendanceList = db
        .collection('notifications')
        .doc(user.email.toString())
        .collection(
          formatter.format(
            DateTime.now(),
          ),
        )
        .orderBy('sortingTime')
        .get();
  }

  Future<void> listenToFirestoreChanges() async {
    CollectionReference reference = db
        .collection('notifications')
        .doc(
          user.email.toString(),
        )
        .collection(
          formatter.format(
            DateTime.now(),
          ),
        );
    reference.snapshots().listen((snapshot) {
      snapshot.docChanges.forEach((change) {
        setState(() {
          fetchAttendance();
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Welcome\n${user!.displayName ?? "User"}",
                        style: GoogleFonts.rubik(
                          textStyle: const TextStyle(
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
                      offset: const Offset(0, 60),
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            enabled: false,
                            child: Text(
                              'Name : ${user!.displayName}',
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            enabled: false,
                            child: Text(
                              'Email : ${user!.email}',
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            child: TextButton(
                              child: const Row(
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
                                  await db
                                      .collection('student_id')
                                      .doc(user.email.toString())
                                      .set({});
                                  await FirebaseAuth.instance
                                      .signOut()
                                      .then((value) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const SignIn(),
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
                      icon: const Icon(
                        Icons.account_circle_outlined,
                      ),
                      iconSize: 45,
                    )
                  ],
                ),
                Expanded(
                  child: FutureBuilder(
                    future: attendanceList,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return Center(
                            child: const CircularProgressIndicator(),
                          );
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.docs.length == 0) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/NotFound.gif',
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.contain,
                                ),
                                Text(
                                  'Today,\nNo attendance has been taken yet!',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 15,
                                ),
                                Text(
                                  'Today\'s Attendance',
                                  style: GoogleFonts.rubik(
                                    textStyle: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                Card(
                                  margin: EdgeInsets.fromLTRB(
                                    10,
                                    15,
                                    10,
                                    0,
                                  ),
                                  elevation: 0,
                                  color: Colors.grey[200],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                          snapshot.data!.docs[index]
                                                  .data()['message'] +
                                              ' - ' +
                                              snapshot.data!.docs[index]
                                                  .data()['title'],
                                          style: GoogleFonts.rubik(
                                            textStyle: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.w100,
                                            ),
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 15,
                                          vertical: 0,
                                        ),
                                        dense: true,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          }
                      }
                    },
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
