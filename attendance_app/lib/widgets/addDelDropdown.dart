import 'package:attendance_app/widgets/titleDropDown.dart';
import 'package:flutter/material.dart';

class AddDelDD extends StatefulWidget {
  String title;
  List<String> li;

  AddDelDD(this.title, this.li);

  @override
  State<AddDelDD> createState() => _AddDelDDState();
}

class _AddDelDDState extends State<AddDelDD> {
  TextEditingController inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: () {
            inputPopUp(widget.title.split(' ').last, 'Remove');
          },
          splashRadius: 20,
          iconSize: 30,
          color: Colors.blue,
          icon: Icon(Icons.remove_circle_outline_rounded),
        ),
        SizedBox(width: 10),
        TitleDropDown(widget.title, widget.li),
        SizedBox(width: 10),
        IconButton.filled(
          onPressed: () {
            inputPopUp(widget.title.split(' ').last, 'Add');
          },
          splashRadius: 20,
          iconSize: 30,
          color: Colors.blue,
          style: IconButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          icon: Icon(Icons.add_circle_outline_rounded),
        ),
      ],
    );
  }

  inputPopUp(String title, String operation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          buttonPadding: EdgeInsets.all(20),
          contentPadding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            '${operation} ${title}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextFormField(
            controller: inputController,
            decoration: InputDecoration(
              hintText: 'Enter ${title}',
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.blue[100],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text(operation),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
