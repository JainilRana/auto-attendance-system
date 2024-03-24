import 'package:attendance_app/main.dart';
import 'package:attendance_app/screens/addData.dart';
import 'package:attendance_app/widgets/titleDropDown.dart';
import 'package:flutter/material.dart';

class AddDelDD extends StatefulWidget {
  String title;
  AddDelDD(this.title, {super.key});
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
          icon: const Icon(Icons.remove_circle_outline_rounded),
        ),
        const SizedBox(width: 10),
        TitleDropDown(widget.title),
        const SizedBox(width: 10),
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
          icon: const Icon(Icons.add_circle_outline_rounded),
        ),
      ],
    );
  }

  inputPopUp(String title, String operation) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          buttonPadding: const EdgeInsets.all(20),
          contentPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            '$operation $title',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextFormField(
            controller: inputController,
            decoration: InputDecoration(
              hintText: 'Enter $title',
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.blue[100],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (operation == 'Add') {
                  setState(() {
                    title == 'Department'
                        ? deptS.add(inputController.text)
                        : title == 'Year'
                            ? yearS.add(inputController.text)
                            : title == 'Division'
                                ? divS.add(inputController.text)
                                : title == 'Batch'
                                    ? batcheS.add(inputController.text)
                                    : title == 'Location'
                                        ? locS.add(inputController.text)
                                        : null;
                    db.collection("dropdowns").doc(title).set({
                      'li': title == 'Department'
                          ? deptS.toList()
                          : title == 'Year'
                              ? yearS.toList()
                              : title == 'Division'
                                  ? divS.toList()
                                  : title == 'Batch'
                                      ? batcheS.toList()
                                      : title == 'Location'
                                          ? locS.toList()
                                          : [],
                    });
                  });
                } else {
                  setState(() {
                    title == 'Department'
                        ? deptS.remove(inputController.text)
                        : title == 'Year'
                            ? yearS.remove(inputController.text)
                            : title == 'Division'
                                ? divS.remove(inputController.text)
                                : title == 'Batch'
                                    ? batcheS.remove(inputController.text)
                                    : title == 'Location'
                                        ? locS.remove(inputController.text)
                                        : null;
                    db.collection("dropdowns").doc(title).set({
                      'li': title == 'Department'
                          ? deptS.toList()
                          : title == 'Year'
                              ? yearS.toList()
                              : title == 'Division'
                                  ? divS.toList()
                                  : title == 'Batch'
                                      ? batcheS.toList()
                                      : title == 'Location'
                                          ? locS.toList()
                                          : [],
                    });
                  });
                }
                inputController.clear();
                Navigator.of(context).pop();
                await fetchDropdowns();
              },
              child: Text(operation),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }
}
