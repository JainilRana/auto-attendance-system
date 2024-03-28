import 'package:attendance_app/screens/homePageF.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StudentList extends StatefulWidget {
  const StudentList({super.key});

  @override
  State<StudentList> createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  // late Future<List<String>> subjectListFuture;
  // late double contHeight;
  // late double contWidth;
  TextEditingController searchController = TextEditingController();

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
                      "Student List",
                      style: GoogleFonts.rubik(
                        textStyle: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          // overflow: TextOverflow.fade,
                        ),
                      ),
                      overflow: TextOverflow.fade,
                    ),
                    // TextButton(
                    //   onPressed: () {
                    //   },
                    //   style: TextButton.styleFrom(
                    //     backgroundColor: Colors.black,
                    //     foregroundColor: Colors.white,
                    //     shape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(15),
                    //     ),
                    //   ),
                    //   child: const Icon(
                    //     Icons.add,
                    //     size: 30,
                    //   ),
                    // ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SearchBar(
                  controller: searchController,
                  hintText: 'ID',
                  textStyle: MaterialStatePropertyAll(
                    GoogleFonts.rubik(
                      textStyle: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  onChanged: (value) {},
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
                  padding: MaterialStatePropertyAll(
                    EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                  ),
                  side: MaterialStatePropertyAll(
                    BorderSide(
                      color: Colors.black,
                      width: 0.8,
                    ),
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(27),
                    ),
                  ),
                  leading: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: FutureBuilder(
                    future: Future.delayed(Duration.zero),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return const CircularProgressIndicator();
                        case ConnectionState.active:
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          // else if (!snapshot.hasData ||
                          //     snapshot.data!.length == 0) {
                          //   return Column(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Image.asset(
                          //         'assets/NoSub.gif',
                          //         height: 200,
                          //         width: 200,
                          //         fit: BoxFit.contain,
                          //       ),
                          //       Text(
                          //         'Problem in fetching student list.',
                          //         style: TextStyle(
                          //           fontSize: 15,
                          //           fontWeight: FontWeight.w500,
                          //         ),
                          //         textAlign: TextAlign.center,
                          //       ),
                          //     ],
                          //   );
                          // }
                          else {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 0),
                              child: GlowingOverscrollIndicator(
                                axisDirection: AxisDirection.down,
                                color: Colors.black,
                                child: ListView(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      // itemCount: snapshot.data!.length,
                                      itemCount: 10,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          elevation: 0,
                                          borderOnForeground: false,
                                          color: Colors.grey[300],
                                          margin:
                                              EdgeInsets.symmetric(vertical: 8),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: CheckboxListTile(
                                            onChanged: (value) {
                                              print('Changed');
                                            },
                                            title: Text(
                                              '21CS026',
                                              // snapshot.data![index],
                                              style: GoogleFonts.rubik(
                                                textStyle: TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                            subtitle: Text(
                                              'Harshal Makwana',
                                              style: GoogleFonts.rubik(
                                                textStyle: TextStyle(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                            value: false,
                                            dense: true,
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => HomePageF(),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        minimumSize: Size(double.infinity, 60),
                                        padding: const EdgeInsets.all(15),
                                        backgroundColor: Colors.black,
                                        foregroundColor: Colors.white,
                                      ),
                                      child: Text(
                                        'Notify Students & Download Attendance',
                                        style: GoogleFonts.rubik(
                                          textStyle: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
