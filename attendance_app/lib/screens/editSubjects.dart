import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditSubjects extends StatefulWidget {
  @override
  State<EditSubjects> createState() => _EditSubjectsState();
}

class _EditSubjectsState extends State<EditSubjects> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences? prefs;
  List<String> subjectList = [];
  TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // fetchList() async {
  //   prefs = await _prefs;
  //   subjectList =
  //       (prefs != null ? prefs!.getStringList('subjects') : ['Null']) ??
  //           ['Null2'];
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black,
          iconTheme: IconThemeData(
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
                      "Subjects",
                      style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          // overflow: TextOverflow.fade,
                        ),
                      ),
                      overflow: TextOverflow.fade,
                    ),
                    TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              buttonPadding: EdgeInsets.all(15),
                              contentPadding: EdgeInsets.all(25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: Text(
                                "Add Subject",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: StatefulBuilder(
                                builder: (context, setS) {
                                  return TextFormField(
                                    cursorColor: Colors.black,
                                    controller: inputController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter subject name',
                                      border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    subjectList.add(inputController.text);
                                    // prefs!
                                    //     .setStringList('subjects', subjectList);
                                    inputController.clear();
                                    Navigator.of(context).pop();
                                    setState(() {});
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.grey[200],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text("Add"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor: Colors.grey[200],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: Text('Cancel'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Icon(
                        Icons.add,
                        size: 30,
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: FutureBuilder(
                    future: Future.delayed(Duration(seconds: 1)), // fetchList(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: ListView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            itemCount: subjectList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 5,
                                margin: EdgeInsets.symmetric(vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: ListTile(
                                  title: Text(
                                    subjectList[index],
                                    style: GoogleFonts.rubik(
                                      textStyle: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.all(15),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
