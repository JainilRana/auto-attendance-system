import 'dart:convert';

import 'package:attendance_app/main.dart';
import 'package:attendance_app/screens/editSubjects.dart';
import 'package:attendance_app/screens/signIn.dart';
import 'package:attendance_app/screens/studentList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

var apiDATA = [];
var studentData = {};
var locations = [];
String? deptF, yearF, divF, batchF, locF, subF;
List<String> subDropdownList = [];

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

fetchStudentData() async {
  var data = await db.collection('student_data').get().whenComplete(
        () => print('Data Fetched'),
      );
  for (var element in data.docs) {
    studentData.addAll(
      {element.id: element.data()},
    );
  }
  var loc = await db.collection('dropdowns').doc('Location').get().whenComplete(
        () => print('Locations Fetched'),
      );
  locations = loc.data()!['li'];
  SharedPreferences prefs = await _prefs;
  subDropdownList = prefs.getStringList('subjects') ?? [];
}

class HomePageF extends StatefulWidget {
  const HomePageF({super.key});

  @override
  _HomePageFState createState() => _HomePageFState();
}

class _HomePageFState extends State<HomePageF> {
  var user;
  String buttonDetails = 'start';

  @override
  void initState() {
    super.initState();
    user = getCurrentUser();
  }

  TitleDDF(String title, List<String> li) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.rubik(
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        DropdownButton<String>(
          value: title.split(' ').last == 'Department:'
              ? deptF
              : title.split(' ').last == 'Year:'
                  ? yearF
                  : title.split(' ').last == 'Division:'
                      ? divF
                      : title.split(' ').last == 'Batch:'
                          ? batchF
                          : title.split(' ').last == 'Location:'
                              ? locF
                              : title.split(' ').last == 'Subject:'
                                  ? subF
                                  : null,
          icon: Icon(Icons.arrow_drop_down_rounded),
          iconSize: 30,
          style: TextStyle(
            color: Colors.blueAccent[700],
            fontSize: 16,
          ),
          onChanged: (String? newValue) {
            setState(() {
              title.split(' ').last == 'Department:'
                  ? () {
                      deptF = newValue;
                      yearF = null;
                      divF = null;
                      batchF = null;
                    }()
                  : title.split(' ').last == 'Year:'
                      ? () {
                          yearF = newValue;
                          divF = null;
                          batchF = null;
                        }()
                      : title.split(' ').last == 'Division:'
                          ? () {
                              divF = newValue;
                              batchF = null;
                            }()
                          : title.split(' ').last == 'Batch:'
                              ? batchF = newValue
                              : title.split(' ').last == 'Location:'
                                  ? locF = newValue
                                  : title.split(' ').last == 'Subject:'
                                      ? subF = newValue
                                      : null;
            });
          },
          focusColor: Colors.transparent,
          underline: Container(
            height: 1.5,
            color: Colors.grey[800],
          ),
          hint: const Text('--Select--'),
          borderRadius: BorderRadius.circular(20),
          elevation: 1,
          menuMaxHeight: 200,
          items: (li).map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  sendAndFetchData(String boolean) async {
    try {
      final response = await http.post(
        Uri.parse(
            'https://rarely-advanced-ape.ngrok-free.app/api/v1/labcamera/active?lab_Number=$locF&setStatus=$boolean'),
        body: json.encode(
          {
            "teacherId": user.email.toString(),
            "Department": deptF.toString(),
            "Year": yearF.toString(),
            "Div": divF.toString(),
            "Batch": batchF.toString(),
            "Subject": subF.toString(),
          },
        ),
        headers: {
          'Content-Type': 'application/json',
          'api_key': user.uid.toString(),
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        var data;
        data = json.decode(response.body);
        if (boolean == 'true') {
          setState(() {
            buttonDetails = 'stop';
          });
        } else {
          apiDATA = data['data'][1];
          print(apiDATA.toString());
          if (apiDATA != null && apiDATA.length > 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentList(),
              ),
            );
          }
          setState(() {
            buttonDetails = 'start';
          });
        }
      } else {
        Fluttertoast.showToast(
          msg: "Something went wrong!!",
          backgroundColor: Colors.red,
          fontSize: 20,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
        );
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(
        msg: "Something went wrong!!",
        backgroundColor: Colors.red,
        fontSize: 20,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
    }
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
                      TitleDDF(
                        'Select Department:',
                        List<String>.from(
                          studentData.keys.toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TitleDDF(
                        'Select Year:',
                        deptF != null && studentData[deptF] != null
                            ? studentData[deptF].keys.toList()
                            : [],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TitleDDF(
                        'Select Division:',
                        deptF != null &&
                                yearF != null &&
                                studentData[deptF] != null &&
                                studentData[deptF][yearF] != null
                            ? studentData[deptF][yearF].keys.toList()
                            : [],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TitleDDF(
                        'Select Batch:',
                        (deptF != null &&
                                yearF != null &&
                                divF != null &&
                                studentData[deptF] != null &&
                                studentData[deptF][yearF] != null &&
                                studentData[deptF][yearF][divF] != null)
                            ? studentData[deptF][yearF][divF].keys.toList()
                            : [],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TitleDDF(
                        'Select Location:',
                        List<String>.from(locations.toList()),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TitleDDF('Select Subject:', subDropdownList),
                      SizedBox(
                        height: 10,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton.icon(
                          label: const Text('Edit Subjects'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const EditSubjects(),
                              ),
                            ).whenComplete(() {
                              setState(() {});
                            });
                          },
                          icon: const Icon(Icons.edit_rounded),
                          style: IconButton.styleFrom(
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      TextButton(
                        onPressed: buttonDetails == 'start'
                            ? () async {
                                await sendAndFetchData('true');
                              }
                            : () async {
                                await sendAndFetchData('false');
                              },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: Size(double.infinity, 60),
                          padding: const EdgeInsets.all(15),
                          backgroundColor: buttonDetails == 'start'
                              ? Colors.black
                              : Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          buttonDetails == 'start'
                              ? 'Start Attendance'
                              : 'Stop Attendance',
                          style: GoogleFonts.rubik(
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
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
