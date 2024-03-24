import 'package:attendance_app/main.dart';
import 'package:attendance_app/widgets/addDelDropdown.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:fluttertoast/fluttertoast.dart';

Set<String> deptS = {},
    yearS = {},
    divS = {},
    batcheS = {},
    locS = {};
String? dept, year, div, batch, loc;

fetchDropdowns() async {
  await db.collection('dropdowns').doc('Department').get().then((value) {
    deptS = value.data() != null ? Set<String>.from(value.data()!['li']) : {};
  });
  await db.collection('dropdowns').doc('Year').get().then((value) {
    yearS = value.data() != null ? Set<String>.from(value.data()!['li']) : {};
  });
  await db.collection('dropdowns').doc('Division').get().then((value) {
    divS = value.data() != null ? Set<String>.from(value.data()!['li']) : {};
  });
  await db.collection('dropdowns').doc('Batch').get().then((value) {
    batcheS = value.data() != null ? Set<String>.from(value.data()!['li']) : {};
  });
  await db.collection('dropdowns').doc('Location').get().then((value) {
    locS = value.data() != null ? Set<String>.from(value.data()!['li']) : {};
  });
}

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchDropdowns(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Card(
            margin: const EdgeInsets.all(25),
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    "Add Student Data",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AddDelDD('Select Department'),
                  AddDelDD('Select Year'),
                  AddDelDD('Select Division'),
                  AddDelDD('Select Batch'),
                  AddDelDD('Select Location'),
                  TextButton.icon(
                    onPressed: () async {
                      FilePickerResult? pickedFile =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['xlsx'],
                        allowMultiple: false,
                      );
                      if (pickedFile != null) {
                        dynamic data = {};
                        var bytes = pickedFile.files.single.bytes;
                        var excel = Excel.decodeBytes(bytes!);
                        for (var table in excel.tables.keys) {
                          for (int i = 0;
                              i < excel.tables[table]!.rows.length - 1;
                              i++) {
                            data.addAll({
                              excel.tables[table]!
                                  .selectRangeValues(
                                    CellIndex.indexByColumnRow(
                                        columnIndex: 0, rowIndex: 1),
                                    end: CellIndex.indexByColumnRow(
                                      columnIndex: 0,
                                      rowIndex:
                                          excel.tables[table]!.rows.length - 1,
                                    ),
                                  )[i]![0]
                                  .toString(): excel.tables[table]!
                                  .selectRangeValues(
                                    CellIndex.indexByColumnRow(
                                        columnIndex: 1, rowIndex: 1),
                                    end: CellIndex.indexByColumnRow(
                                        columnIndex: 1,
                                        rowIndex:
                                            excel.tables[table]!.rows.length -
                                                1),
                                  )[i]![0]
                                  .toString()
                            });
                            db
                                .collection('student_id')
                                .doc(
                                  '${excel.tables[table]!
                                          .selectRangeValues(
                                            CellIndex.indexByColumnRow(
                                                columnIndex: 0, rowIndex: 1),
                                            end: CellIndex.indexByColumnRow(
                                              columnIndex: 0,
                                              rowIndex: excel.tables[table]!
                                                      .rows.length -
                                                  1,
                                            ),
                                          )[i]![0]
                                          .toString().toLowerCase()}@charusat.edu.in',
                                )
                                .set({});
                          }
                          db.collection('student_data').doc(dept).get().then(
                            (value) {
                              if (value.data() != null) {
                                var studentData =
                                    value.data()!.map((key, value) {
                                  return MapEntry(key, value);
                                });
                                if (studentData.containsKey(year)) {
                                  if (studentData[year].containsKey(div)) {
                                    if (studentData[year][div]
                                        .containsKey(batch)) {
                                      studentData[year]![div]![batch] = data;
                                    } else {
                                      studentData[year]![div]
                                          .addAll(<String, dynamic>{
                                        batch!: data,
                                      });
                                    }
                                  } else {
                                    studentData[year!].addAll(<String, dynamic>{
                                      div!: {
                                        batch: data,
                                      },
                                    });
                                  }
                                } else {
                                  studentData.addAll(<String, dynamic>{
                                    year!: {
                                      div: {
                                        batch: data,
                                      },
                                    },
                                  });
                                }
                                db.collection('student_data').doc(dept).set(
                                      studentData,
                                    );
                              } else {
                                db.collection('student_data').doc(dept).set(
                                  {
                                    year!: {
                                      div: {
                                        batch: data,
                                      },
                                    },
                                  },
                                );
                              }
                            },
                          );
                        }
                        Fluttertoast.showToast(
                          msg: "Data added successfully!!",
                          backgroundColor: Colors.green,
                          fontSize: 20,
                          textColor: Colors.white,
                          gravity: ToastGravity.BOTTOM,
                          webBgColor:
                              "	linear-gradient(to right, #4CAF50, #4CAF50)",
                          timeInSecForIosWeb: 2,
                          webPosition: "center",
                          webShowClose: true,
                        );
                      } else {
                        Fluttertoast.showToast(
                          msg: "No file selected!!",
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
                      padding: const EdgeInsets.all(20),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    icon: const Icon(Icons.upload_file_rounded),
                    label: const Text('Upload Excel File'),
                  ),
                  const Text(
                    "**Upload Excel(.xlsx) file with only two columns, containing all IDs & Names of students (of the selected batch only) with 'ID' & 'Name' as title **",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
