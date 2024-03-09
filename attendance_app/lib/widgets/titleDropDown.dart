import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TitleDropDown extends StatefulWidget {
  String? title;
  List<String>? li;
  TitleDropDown(
    this.title,
    this.li,
  );
  @override
  _TitleDropDownState createState() => _TitleDropDownState();
}

class _TitleDropDownState extends State<TitleDropDown> {
  String? currentSelected;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          widget.title!,
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
          value: currentSelected,
          icon: Icon(Icons.arrow_drop_down_rounded),
          iconSize: 30,
          style: TextStyle(
            color: Colors.blueAccent[700],
            fontSize: 16,
          ),
          onChanged: (String? newValue) {
            setState(() {
              currentSelected = newValue!;
            });
          },
          underline: Container(
            height: 1.5,
            color: Colors.grey[800],
          ),
          hint: Text('--Select--'),
          borderRadius: BorderRadius.circular(20),
          elevation: 1,
          menuMaxHeight: 200,
          items: widget.li!.map<DropdownMenuItem<String>>((String value) {
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
