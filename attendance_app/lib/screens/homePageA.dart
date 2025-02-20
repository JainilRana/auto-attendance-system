import 'package:attendance_app/screens/addData.dart';
import 'package:attendance_app/screens/addID.dart';
import 'package:attendance_app/screens/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePageA extends StatefulWidget {
  const HomePageA({super.key});

  @override
  State<HomePageA> createState() => _HomePageAState();
}

class _HomePageAState extends State<HomePageA> {
  var subPage = 'faculty_id';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignIn(),
                    ),
                  );
                });
              } catch (e) {
                print(e);
              }
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
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
                        print(subPage);
                      });
                    },
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    label: const Text('Add Faculty ID'),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        subPage = 'student_data';
                      });
                    },
                    icon: const Icon(Icons.add_circle_outline_rounded),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(20),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    label: const Text('Add Student Data'),
                  ),
                ],
              ),
              subPage == 'faculty_id'
                  ? const Expanded(
                      child: AddID(),
                    )
                  : const Expanded(
                      child: AddData(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
