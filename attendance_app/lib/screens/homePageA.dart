import 'package:attendance_app/screens/addData.dart';
import 'package:attendance_app/screens/addID.dart';
import 'package:flutter/material.dart';

class HomePageA extends StatefulWidget {
  const HomePageA({super.key});

  @override
  State<HomePageA> createState() => _HomePageAState();
}

class _HomePageAState extends State<HomePageA> {
  var subPage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        subPage = 'faculty_id';
                      });
                    },
                    icon: Icon(Icons.add_circle_outline_rounded),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    label: Text('Add Faculty ID'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        subPage = 'student_id';
                      });
                    },
                    icon: Icon(Icons.add_circle_outline_rounded),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    label: Text('Add Student ID'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        subPage = 'student_data';
                      });
                    },
                    icon: Icon(Icons.add_circle_outline_rounded),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(20),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    label: Text('Add Student Data'),
                  ),
                ],
              ),
              subPage == 'faculty_id'
                  ? Expanded(child: AddID(idKey: subPage))
                  : subPage == 'student_id'
                      ? Expanded(child: AddID(idKey: subPage))
                      : Expanded(child: AddData(dataKey: subPage)),
            ],
          ),
        ),
      ),
    );
  }
}
