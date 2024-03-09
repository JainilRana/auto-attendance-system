import 'package:attendance_app/widgets/addDelDropdown.dart';
import 'package:attendance_app/widgets/titleDropDown.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';

var dept, year, div, batch; // List of no. & names in that batch in excel format

class AddData extends StatefulWidget {
  var dataKey;

  AddData({this.dataKey});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(25),
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AddDelDD('Select Department', []),
            AddDelDD('Select Year', []),
            AddDelDD('Select Division', []),
            AddDelDD('Select Batch', []),
            TextButton.icon(
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
                    for (int i = 0; i < excel.tables[table]!.rows.length; i++) {
                      print(
                          '${excel.tables[table]!.selectRangeValues(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0), end: CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: excel.tables[table]!.rows.length - 1))[i]![0]}');
                      print(
                          '${excel.tables[table]!.selectRangeValues(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0), end: CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: excel.tables[table]!.rows.length - 1))[i]![0]}');
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
                ),
              ),
              icon: Icon(Icons.upload_file_rounded),
              label: Text('Upload Excel File'),
            ),
          ],
        ),
      ),
    );
  }
}
