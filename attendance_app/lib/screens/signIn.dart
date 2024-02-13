import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Login to your\naccount',
                  style: GoogleFonts.rubik(
                    textStyle: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 40),
              
              // Name field
              TextFormField(
                autofocus: true,
                controller: nameController,
                cursorRadius: Radius.circular(15),
                maxLines: 1,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: 'Name',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                  ),
                  fillColor: Colors.grey[100],
                  filled: true,
                ),
              ),
              SizedBox(height: 20),

              // Email field
              TextFormField(
                autofocus: true,
                controller: emailController,
                cursorRadius: Radius.circular(15),
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  hintText: 'Email',
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                  ),
                  fillColor: Colors.grey[100],
                  filled: true,
                ),
              ),
              SizedBox(height: 40),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      child: Text('Send link'),
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
