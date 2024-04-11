/*import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  bool _obscurePassword = true; // Variable to toggle password visibility

  @override
  Widget build(BuildContext context) {
    final ht = MediaQuery.of(context).size.height;
    final wd = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping outside of the text fields
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(ht * 0.03),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: ht * 0.05,
                  ),
                  Image.asset(
                    "assets/images/pic.png",
                    height: ht * 0.2,
                  ),
                  SizedBox(height: ht * 0.04),
                  Text(
                    "Register",
                    style: TextStyle(
                      fontFamily: "school",
                      fontSize: wd * 0.09,
                      color: Color.fromARGB(207, 132, 0, 255),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: wd * 0.07),
                  Material(
                    elevation: wd * 0.02,
                    child: TextField(
                      onChanged: (value) {
                        email = value;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter Email",
                        border: OutlineInputBorder(),
                        labelText: "Email",
                      ),
                    ),
                  ),
                  SizedBox(height: wd * 0.08),
                  Material(
                    elevation: wd * 0.02,
                    child: TextField(
                      onChanged: (value) {
                        password = value;
                      },
                      obscureText:
                          _obscurePassword, // Toggle password visibility
                      decoration: InputDecoration(
                        hintText: "Enter Password",
                        border: OutlineInputBorder(),
                        labelText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword
                              ? Icons.visibility_off
                              : Icons
                                  .visibility), // Toggle icon based on password visibility
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: wd*0.08),
                   Container(
                      width: double
                          .infinity, // Make the button take the full width
                      height: 50, // Set the desired height of the button
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                            40), // Adjust the border radius as needed
                        border: Border.all(
                            color: Color.fromARGB(255, 134, 3,
                                248)), // Set the border color to purple
                      ),
                      child: ElevatedButton(
                    onPressed: () async {
                      // Check if email and password are not empty
                      if (email == null ||
                          email!.isEmpty ||
                          password == null ||
                          password!.isEmpty) {
                        // Show a snackbar or dialog to inform the user about the empty fields
                         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'OOPS!',
                                message: 'Enter correct login credentials',
                                contentType: ContentType.failure,
                              ),
                            ));
                        return; // Exit the function early
                      }

                      // Validate email format
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(email!)) {
                        // Show a snackbar or dialog to inform the user about the invalid email format
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Please enter a valid email address.'),
                          ),
                        );
                        return; // Exit the function early
                      }

                      // Proceed with user registration
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                          email: email!,
                          password: password!,
                        );
                        // Handle successful registration, e.g., navigate to another screen
                      } catch (e) {
                        // Handle any registration errors, e.g., display error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Registration failed. Please try again later.'),
                          ),
                        );
                      }
                    },
                    child:
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Already Have An Account"),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SignUpPage(),
  ));
}*/

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  bool _obscurePassword = true; // Variable to toggle password visibility

  @override
  Widget build(BuildContext context) {
    final ht = MediaQuery.of(context).size.height;
    final wd = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping outside of the text fields
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(ht * 0.03),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: ht * 0.05,
                ),
                Image.asset(
                  "assets/images/pic.png",
                  height: ht * 0.2,
                ),
                SizedBox(height: ht * 0.04),
                Text(
                  "Register",
                  style: TextStyle(
                    fontFamily: "school",
                    fontSize: wd * 0.09,
                    color: Color.fromARGB(207, 132, 0, 255),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: wd * 0.07),
                Material(
                  elevation: wd * 0.02,
                  child: TextField(
                    onChanged: (value) {
                      email = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter Email",
                      border: OutlineInputBorder(),
                      labelText: "Email",
                    ),
                  ),
                ),
                SizedBox(height: wd * 0.08),
                Material(
                  elevation: wd * 0.02,
                  child: TextField(
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: _obscurePassword, // Toggle password visibility
                    decoration: InputDecoration(
                      hintText: "Enter Password",
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_off
                            : Icons
                                .visibility), // Toggle icon based on password visibility
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: wd * 0.08),
                Container(
                  width: double.infinity, // Make the button take the full width
                  height: 50, // Set the desired height of the button
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        40), // Adjust the border radius as needed
                    border: Border.all(
                        color: Color.fromARGB(255, 134, 3,
                            248)), // Set the border color to purple
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      // Check if email and password are not empty
                      if (email == null ||
                          email!.isEmpty ||
                          password == null ||
                          password!.isEmpty) {
                        // Show a snackbar or dialog to inform the user about the empty fields
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'OOPS!',
                            message: 'Enter all fields',
                            contentType: ContentType.failure,
                          ),
                        ));
                        return; // Exit the function early
                      }

                      // Validate email format
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(email!)) {
                        // Show a snackbar or dialog to inform the user about the invalid email format
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'OOPS!',
                            message: 'Enter a valid email-id',
                            contentType: ContentType.failure,
                          ),
                        ));
                        return; // Exit the function early
                      }

                      // Proceed with user registration
                      try {
                        final newUser =
                            await _auth.createUserWithEmailAndPassword(
                          email: email!,
                          password: password!,
                        );
                        // Handle successful registration, e.g., navigate to another screen
                      } catch (e) {
                        // Handle any registration errors, e.g., display error message
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Registration failed',
                            message: 'Please try again',
                            contentType: ContentType.failure,
                          ),
                        ));
                      }
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(
                        color: Color.fromARGB(255, 105, 0, 252),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: wd * 0.03),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Already Have An Account"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SignUpPage(),
  ));
}
