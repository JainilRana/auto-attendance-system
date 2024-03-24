import 'package:attendance_app/main.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddID extends StatefulWidget {
  const AddID({super.key});

  @override
  State<AddID> createState() => _AddIDState();
}

class _AddIDState extends State<AddID> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        const Text(
          "Add Faculty ID",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        Card(
          margin: const EdgeInsets.all(25),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: TextButton.icon(
              onPressed: () async {
                FilePickerResult? pickedFile =
                    await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['xlsx'],
                  allowMultiple: false,
                );
                if (pickedFile != null) {
                  var bytes = pickedFile.files.single.bytes;
                  var excel = Excel.decodeBytes(bytes!);
                  for (var table in excel.tables.keys) {
                    for (int i = 0;
                        i < excel.tables[table]!.rows.length - 1;
                        i++) {
                      print('${excel.tables[table]!.selectRangeValues(
                        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1),
                        end: CellIndex.indexByColumnRow(
                            columnIndex: 0,
                            rowIndex: excel.tables[table]!.rows.length - 1),
                      )[i]![0]}');
                      db
                          .collection('faculty_id')
                          .doc(
                            (excel.tables[table]!.selectRangeValues(
                              CellIndex.indexByColumnRow(
                                  columnIndex: 0, rowIndex: 1),
                              end: CellIndex.indexByColumnRow(
                                  columnIndex: 0,
                                  rowIndex:
                                      excel.tables[table]!.rows.length - 1),
                            )[i]![0])
                                .toString().toLowerCase(),
                          )
                          .set({}).then((value) => print("IDs Added"));
                    }
                  }
                  Fluttertoast.showToast(
                    msg: "Data added successfully!!",
                    backgroundColor: Colors.green,
                    fontSize: 20,
                    textColor: Colors.white,
                    gravity: ToastGravity.BOTTOM,
                    webBgColor: "	linear-gradient(to right, #4CAF50, #4CAF50)",
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
                    webBgColor: "	linear-gradient(to right, #F44336, #F44336)",
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
                  )),
              icon: const Icon(Icons.upload_file_rounded),
              label: const Text('Upload Excel File'),
            ),
          ),
        ),
        const Text(
          "**Upload Excel(.xlsx) file with only one column containing all ID's & '${'faculty_id'}' as title**",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
