import 'package:attendance_app/main.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';

class AddID extends StatefulWidget {
  var idKey;
  AddID({this.idKey});
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
        Text(
          widget.idKey == "faculty_id" ? "Add Faculty ID" : "Add Student ID",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        Card(
          margin: EdgeInsets.all(25),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.all(30),
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
                          .collection(widget.idKey == "faculty_id"
                              ? "faculty_id"
                              : "student_id")
                          .doc(
                            (excel.tables[table]!.selectRangeValues(
                              CellIndex.indexByColumnRow(
                                  columnIndex: 0, rowIndex: 1),
                              end: CellIndex.indexByColumnRow(
                                  columnIndex: 0,
                                  rowIndex:
                                      excel.tables[table]!.rows.length - 1),
                            )[i]![0])
                                .toString(),
                          )
                          .set({}).then((value) => print("IDs Added"));
                    }
                  }
                } else {
                  print('No file selected');
                }
              },
              style: TextButton.styleFrom(
                  padding: EdgeInsets.all(20),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  )),
              icon: Icon(Icons.upload_file_rounded),
              label: Text('Upload Excel File'),
            ),
          ),
        ),
        Text(
          "**Upload Excel(.xlsx) file with only one column containing all ID's & ${widget.idKey} as title**",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
