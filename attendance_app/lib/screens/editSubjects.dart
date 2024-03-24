import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditSubjects extends StatefulWidget {
  const EditSubjects({super.key});

  @override
  State<EditSubjects> createState() => _EditSubjectsState();
}

class _EditSubjectsState extends State<EditSubjects> {
  // SharedPreferences? prefs;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late Future<List<String>> subjectListFuture;
  TextEditingController inputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    subjectListFuture = _prefs.then((SharedPreferences prefs) {
      return prefs.getStringList('subjects') ?? [];
    });
  }

  // getSubList() async {
  //   final SharedPreferences prefs = await _prefs;
  //   final List<dynamic> subList = ((prefs.getStringList('subjects') ?? []));

  //   setState(() {
  //     _counter = prefs.setInt('counter', counter).then((bool success) {
  //       return counter;
  //     });
  //   });
  // }

  updateSubList(String newSub) async {
    final SharedPreferences prefs = await _prefs;
    var subList = ((prefs.getStringList('subjects') ?? []));
    subList.add(newSub);

    setState(() {
      subjectListFuture =
          prefs.setStringList('subjects', subList).then((bool success) {
        return subList;
      });
    });
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
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              buttonPadding: const EdgeInsets.all(15),
                              contentPadding: const EdgeInsets.all(25),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              title: const Text(
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
                                    decoration: const InputDecoration(
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
                                    updateSubList(inputController.text);
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
                                  child: const Text("Add"),
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
                                  child: const Text('Cancel'),
                                ),
                              ],
                            );
                          },
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 20,
                        ),
                        const Text(
                          'Update',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(
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
                        const SizedBox(
                          width: 15,
                        ),
                        const Text(
                          'Delete',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ],
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
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 5,
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        snapshot.data![index],
                                        style: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.all(15),
                                    ),
                                  );
                                },
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
