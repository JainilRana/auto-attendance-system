import 'dart:convert';
import 'dart:io';

import 'package:attendance_app/main.dart';
import 'package:attendance_app/screens/homePageF.dart';
import 'package:attendance_app/screens/homePageS.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  var user;
  List<String> editedStudentList = [];
  TextEditingController searchController = TextEditingController();

  void initState() {
    super.initState();
    user = getCurrentUser();
  }

  notifyStudentAndDownloadExcel() async {
    List<String> absentStudentList = [];
    for (var element in apiDATA.where((element) {
      return element['present'] == false;
    }).toList()) {
      absentStudentList.add(element['id'].toString());
    }
    print(editedStudentList.toString());
    print(absentStudentList.toString());
    try {
      final response = await http.put(
        Uri.parse(
            'https://rarely-advanced-ape.ngrok-free.app/api/v1/classAttend/notifyStudent'),
        body: json.encode(
          {
            "teacherId": user.email.toString(),
            "subject": subF.toString(),
            "updateList": editedStudentList,
            "absentList": absentStudentList,
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
        print(data);
      } else {
        Fluttertoast.showToast(
          msg: "Something went wrong!!",
          backgroundColor: Colors.red,
          fontSize: 20,
          textColor: Colors.white,
          gravity: ToastGravity.BOTTOM,
        );
        return;
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
      return;
    }
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];
      sheetObject.cell(CellIndex.indexByString('A1')).value =
          TextCellValue('Department: $deptF');
      sheetObject.cell(CellIndex.indexByString('A2')).value =
          TextCellValue('Division: $divF');
      sheetObject.cell(CellIndex.indexByString('A3')).value =
          TextCellValue('Batch: $batchF');
      sheetObject.cell(CellIndex.indexByString('A4')).value =
          TextCellValue('Subject: $subF');
      sheetObject.cell(CellIndex.indexByString('A5')).value =
          TextCellValue('Date: ${formatter.format(
                DateTime.now(),
              ).toString()}');
      sheetObject.cell(CellIndex.indexByString('A6')).value =
          TextCellValue('Time: ${timeFormatter.format(
                DateTime.now(),
              ).toString()}');
      sheetObject.cell(CellIndex.indexByString('A8')).value =
          TextCellValue('ID');
      sheetObject.cell(CellIndex.indexByString('B8')).value =
          TextCellValue('Name');
      sheetObject.cell(CellIndex.indexByString('C8')).value =
          TextCellValue('Attendance');
      for (int i = 0; i < apiDATA.length; i++) {
        sheetObject.cell(CellIndex.indexByString('A${i + 9}')).value =
            TextCellValue(apiDATA[i]['id'].toString());
        sheetObject.cell(CellIndex.indexByString('B${i + 9}')).value =
            TextCellValue(apiDATA[i]['name'].toString());
        sheetObject.cell(CellIndex.indexByString('C${i + 9}')).value =
            TextCellValue(apiDATA[i]['present'].toString() == 'true'
                ? 'Present'
                : 'Absent');
      }
      var fileBytes = excel.save();
      var pathOfTheFile =
          "/storage/emulated/0/Download/$deptF-$divF-$batchF-$subF-${formatter.format(
                DateTime.now(),
              ).toString()}-${timeFormatter.format(DateTime.now()).toString().replaceAll(' ', '-').replaceAll(':', '_')}.xlsx";
      File(pathOfTheFile)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes ?? []);
    } catch (e) {
      print(e);
    }
    Fluttertoast.showToast(
      msg: "Excel Downloaded Successfully.",
      backgroundColor: Colors.green,
      fontSize: 20,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePageF(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          iconTheme: const IconThemeData(
            size: 30,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Student List",
                      style: GoogleFonts.rubik(
                        textStyle: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          // overflow: TextOverflow.fade,
                        ),
                      ),
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SearchBar(
                  controller: searchController,
                  hintText: 'ID',
                  textStyle: MaterialStatePropertyAll(
                    GoogleFonts.rubik(
                      textStyle: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                  ),
                  side: MaterialStatePropertyAll(
                    BorderSide(
                      color: Colors.black,
                      width: 0.8,
                    ),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                  ),
                  leading: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    child: GlowingOverscrollIndicator(
                      axisDirection: AxisDirection.down,
                      color: Colors.black,
                      child: ListView(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            itemCount: apiDATA.length,
                            itemBuilder: (context, index) {
                              if (apiDATA[index]['id']
                                  .toString()
                                  .substring(
                                    apiDATA[index]['id'].toString().length - 3,
                                    apiDATA[index]['id'].toString().length,
                                  )
                                  .contains(searchController.text)) {
                                return Card(
                                  elevation: 0,
                                  borderOnForeground: false,
                                  color: Colors.grey[300],
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: CheckboxListTile(
                                    onChanged: (value) {
                                      if (apiDATA[index]['present'] == true &&
                                          !editedStudentList.contains(
                                              apiDATA[index]['id']
                                                  .toString())) {
                                        return;
                                      } else {
                                        setState(() {
                                          apiDATA[index]['present'] = value!;
                                        });
                                        value == true
                                            ? editedStudentList.add(
                                                apiDATA[index]['id'].toString())
                                            : editedStudentList.remove(
                                                apiDATA[index]['id']
                                                    .toString());
                                      }
                                    },
                                    title: Text(
                                      apiDATA[index]['id'].toString(),
                                      style: GoogleFonts.rubik(
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    subtitle: Text(
                                      apiDATA[index]['name'].toString(),
                                      style: GoogleFonts.rubik(
                                        textStyle: TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    value: apiDATA[index]['present'] == true
                                        ? true
                                        : false,
                                    selected: apiDATA[index]['present'] == true
                                        ? true
                                        : false,
                                    selectedTileColor: Colors.green[300],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    activeColor: Colors.black,
                                    checkColor: Colors.white,
                                    dense: true,
                                  ),
                                );
                              } else {
                                return SizedBox.shrink();
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            onPressed: () async {
                              await notifyStudentAndDownloadExcel();
                            },
                            style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(double.infinity, 60),
                              padding: const EdgeInsets.all(15),
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              'Notify Students & Download Attendance',
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
