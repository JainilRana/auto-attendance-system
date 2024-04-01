import 'dart:async';

import 'package:attendance_app/screens/homePageF.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditSubjects extends StatefulWidget {
  const EditSubjects({super.key});

  @override
  State<EditSubjects> createState() => _EditSubjectsState();
}

class _EditSubjectsState extends State<EditSubjects> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<List<String>> subjectListFuture;
  late double contHeight;
  late double contWidth;
  TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    subjectListFuture = _prefs.then((SharedPreferences prefs) {
      return prefs.getStringList('subjects') ?? [];
    });
    contHeight = subDropdownList.length != 0 ? 40 : 0;
    contWidth = subDropdownList.length != 0 ? double.maxFinite : 0;
    Timer(Duration(seconds: 5), () {
      setState(() {
        contHeight = 0;
        contWidth = 0;
      });
    });
  }

  updateSubList(List<String> newList) async {
    final SharedPreferences prefs = await _prefs;
    setState(() {
      subjectListFuture =
          prefs.setStringList('subjects', newList).then((bool success) {
        return newList;
      });
      subDropdownList = newList;
    });
  }

  addSubToList(String newSub) async {
    final SharedPreferences prefs = await _prefs;
    var subList = ((prefs.getStringList('subjects') ?? []));
    subList.add(newSub);
    subDropdownList = subList;

    setState(() {
      subjectListFuture =
          prefs.setStringList('subjects', subList).then((bool success) {
        return subList;
      });
    });
  }

  addOrUpdateSub(String title, var onPress, String operation) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          buttonPadding: EdgeInsets.all(15),
          contentPadding: EdgeInsets.all(25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            title,
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
            TextButton(
              onPressed: onPress,
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(operation),
            ),
          ],
        );
      },
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
                      "Subjects",
                      style: GoogleFonts.rubik(
                        textStyle: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          // overflow: TextOverflow.fade,
                        ),
                      ),
                      overflow: TextOverflow.fade,
                    ),
                    TextButton(
                      onPressed: () {
                        addOrUpdateSub(
                          'Add Subject',
                          () async {
                            addSubToList(inputController.text);
                            inputController.clear();
                            Navigator.of(context).pop();
                          },
                          'Add',
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Icon(
                        Icons.add,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),

                AnimatedContainer(
                  duration: Duration(seconds: 1),
                  height: contHeight,
                  width: contWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            'Update',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Image.asset(
                            'assets/RightUpdate.gif',
                            height: 35,
                            width: 35,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/LeftDelete.gif',
                            height: 35,
                            width: 35,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.redAccent,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: FutureBuilder(
                    future: subjectListFuture,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const CircularProgressIndicator();
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (!snapshot.hasData ||
                              snapshot.data!.length == 0) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/NoSub.gif',
                                  height: 200,
                                  width: 200,
                                  fit: BoxFit.contain,
                                ),
                                Text(
                                  'No Subjects Added Yet!\nAdd Subjects to get started.',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 0),
                              child: GlowingOverscrollIndicator(
                                axisDirection: AxisDirection.down,
                                color: Colors.black,
                                child: ListView.builder(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    return Dismissible(
                                      dismissThresholds: {
                                        DismissDirection.startToEnd: 0.9,
                                        DismissDirection.endToStart: 0.9,
                                      },
                                      key: Key(snapshot.data![index]),
                                      confirmDismiss: (direction) async {
                                        if (direction ==
                                            DismissDirection.endToStart) {
                                          return showDialog(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text('Are you sure?'),
                                              content: Text(
                                                  'Do you want to remove this subject?'),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx)
                                                        .pop(false);
                                                  },
                                                  child: Text('No'),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(ctx).pop(true);
                                                  },
                                                  child: Text('Yes'),
                                                ),
                                              ],
                                            ),
                                          );
                                        } else {
                                          inputController.text =
                                              snapshot.data![index].toString();
                                          addOrUpdateSub('Update Subject',
                                              () async {
                                            snapshot.data![index] =
                                                inputController.text.toString();
                                            updateSubList(snapshot.data!);
                                            inputController.clear();
                                            Navigator.of(context).pop();
                                          }, 'Update');
                                          return false;
                                        }
                                      },
                                      background: Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 5,
                                        ),
                                        alignment: Alignment.centerLeft,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.blueAccent,
                                        ),
                                        child: Icon(
                                          size: 30,
                                          Icons.mode_edit_outline_rounded,
                                          color: Colors.white,
                                        ),
                                      ),
                                      secondaryBackground: Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical: 10,
                                          horizontal: 5,
                                        ),
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.redAccent,
                                        ),
                                        child: Icon(
                                          size: 30,
                                          Icons.delete_forever,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onDismissed: (direction) {
                                        if (direction ==
                                            DismissDirection.endToStart) {
                                          setState(() {
                                            snapshot.data!
                                                .remove(snapshot.data![index]);
                                            updateSubList(snapshot.data!);
                                          });
                                        }
                                      },
                                      child: Card(
                                        elevation: 0,
                                        borderOnForeground: false,
                                        color: Colors.grey[300],
                                        margin:
                                            EdgeInsets.symmetric(vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: ListTile(
                                          title: Text(
                                            snapshot.data![index],
                                            style: GoogleFonts.rubik(
                                              textStyle: TextStyle(
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                            horizontal: 15,
                                            vertical: 5,
                                          ),
                                          dense: true,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }
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
