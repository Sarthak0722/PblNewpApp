import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:newp/homescreen.dart';
import 'package:newp/signup_page.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _auth = FirebaseAuth.instance;
  String? email;
  String? password;
  bool _obscurePassword = true; // Variable to toggle password visibility
  bool _isLoading = false; // Variable to track loading state

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
            backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                    SizedBox(height: ht * 0.003),
                    Text(
                      "Login",
                      style: TextStyle(
                        fontFamily: "school",
                        fontSize: wd * 0.3,
                        color: Color.fromARGB(207, 132, 0, 255),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: wd * 0.03),
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
                    SizedBox(height: wd * 0.04),
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
                          // Start loading
                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            final newUser =
                                await _auth.signInWithEmailAndPassword(
                              email: email!,
                              password: password!,
                            );
                            if (newUser != null) {
                              // Stop loading
                              setState(() {
                                _isLoading = false;
                              });

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                              );
                            }
                          } catch (e) {
                            // Handle errors here
                            print("Error signing in: $e");
                            // You can show a snackbar or dialog to inform the user about the error
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

                            // Stop loading
                            setState(() {
                              _isLoading = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors
                              .white, // Set the background color of the button to white
                          elevation: wd *
                              0.3, // Remove the default elevation of the button
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator()
                            : Text(
                                "Login",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 105, 0, 252),
                                    fontFamily: 'school',
                                    fontSize:
                                        40), // Set the text color to purple
                              ), // Show loading indicator when loading
                      ),
                    ),
                    SizedBox(height: wd * 0.03),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: Text("Create New User"),
                    ),
                  ],
                ),
              ),
            )));
  }
}
