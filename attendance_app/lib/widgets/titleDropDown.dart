import 'package:attendance_app/screens/addData.dart';
import 'package:attendance_app/screens/homePageF.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleDropDown extends StatefulWidget {
  String title;
  List<String> li;
  TitleDropDown(
    this.title, {
    this.li = const ['Null'],
  });
  @override
  _TitleDropDownState createState() => _TitleDropDownState();
}

class _TitleDropDownState extends State<TitleDropDown> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.title,
          style: GoogleFonts.rubik(
            textStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        DropdownButton<String>(
          value: widget.title.split(' ').last == 'Department'
              ? dept
              : widget.title.split(' ').last == 'Year'
                  ? year
                  : widget.title.split(' ').last == 'Division'
                      ? div
                      : widget.title.split(' ').last == 'Batch'
                          ? batch
                          : widget.title.split(' ').last == 'Location'
                              ? loc
                              : widget.title.split(' ').last == 'Department:'
                                  ? deptF
                                  : widget.title.split(' ').last == 'Year:'
                                      ? yearF
                                      : widget.title.split(' ').last ==
                                              'Division:'
                                          ? divF
                                          : widget.title.split(' ').last ==
                                                  'Batch:'
                                              ? batchF
                                              : widget.title.split(' ').last ==
                                                      'Location:'
                                                  ? locF
                                                  : null,
          icon: Icon(Icons.arrow_drop_down_rounded),
          iconSize: 30,
          style: TextStyle(
            color: Colors.blueAccent[700],
            fontSize: 16,
          ),
          onChanged: (String? newValue) {
            setState(() {
              widget.title.split(' ').last == 'Department'
                  ? dept = newValue
                  : widget.title.split(' ').last == 'Year'
                      ? year = newValue
                      : widget.title.split(' ').last == 'Division'
                          ? div = newValue
                          : widget.title.split(' ').last == 'Batch'
                              ? batch = newValue
                              : widget.title.split(' ').last == 'Location'
                                  ? loc = newValue
                                  : widget.title.split(' ').last ==
                                          'Department:'
                                      ? deptF = newValue
                                      : widget.title.split(' ').last == 'Year:'
                                          ? yearF = newValue
                                          : widget.title.split(' ').last ==
                                                  'Division:'
                                              ? divF = newValue
                                              : widget.title.split(' ').last ==
                                                      'Batch:'
                                                  ? batchF = newValue
                                                  : widget.title
                                                              .split(' ')
                                                              .last ==
                                                          'Location:'
                                                      ? locF = newValue
                                                      : null;
            });
          },
          focusColor: Colors.transparent,
          underline: Container(
            height: 1.5,
            color: Colors.grey[800],
          ),
          hint: Text('--Select--'),
          borderRadius: BorderRadius.circular(20),
          elevation: 1,
          menuMaxHeight: 200,
          items: (widget.title.split(' ').last == 'Department'
                  ? deptS
                  : widget.title.split(' ').last == 'Year'
                      ? yearS
                      : widget.title.split(' ').last == 'Division'
                          ? divS
                          : widget.title.split(' ').last == 'Batch'
                              ? batcheS
                              : widget.title.split(' ').last == 'Location'
                                  ? locS
                                  : widget.li)
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
