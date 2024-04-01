import 'package:attendance_app/main.dart';
import 'package:attendance_app/screens/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageS extends StatefulWidget {
  const HomePageS({super.key});

  @override
  State<HomePageS> createState() => _HomePageSState();
}

class _HomePageSState extends State<HomePageS> {
  var user;

  @override
  void initState() {
    super.initState();
    user = getCurrentUser();
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Card(
                      //   child: ListView.builder(
                      //     itemBuilder: (context, index) {
                      //       return ListTile(
                      //         title: Text(
                      //           'Subject ${index + 1}',
                      //           style: const TextStyle(
                      //             fontSize: 20,
                      //           ),
                      //         ),
                      //         subtitle: Text(
                      //           'Attendance : 100%',
                      //           style: const TextStyle(
                      //             fontSize: 15,
                      //           ),
                      //         ),
                      //         trailing: const Icon(
                      //           Icons.arrow_forward_ios,
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // )
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
