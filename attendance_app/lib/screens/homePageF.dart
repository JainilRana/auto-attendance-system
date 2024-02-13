import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/titleDropDown.dart';

class HomePageF extends StatefulWidget {
  @override
  _HomePageFState createState() => _HomePageFState();
}

class _HomePageFState extends State<HomePageF> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hello!!\nHarshal",
                      style: GoogleFonts.rubik(
                          textStyle: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                      )),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.account_circle_outlined,
                      ),
                      iconSize: 45,
                    )
                  ],
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TitleDropDown('Select Class:',
                          ['21-batch', '22-batch', '23-batch', '24-batch']),
                      SizedBox(
                        height: 20,
                      ),
                      TitleDropDown('Select Batch:',
                          ['A1', 'B1', 'C1', 'D1', 'A2', 'B2', 'C2', 'D2']),
                      SizedBox(
                        height: 20,
                      ),
                      TitleDropDown('Select Lab no.:',
                          ['631', '632', '633', '634', '638']),
                      SizedBox(
                        height: 20,
                      ),
                      TitleDropDown(
                          'Select Duration:', ['1 hour', '2 hour', '3 hour']),
                      SizedBox(
                        height: 50,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {},
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.all(15),
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                              ),
                              child: Text(
                                'Start Attendance',
                                style: GoogleFonts.rubik(
                                  textStyle: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
