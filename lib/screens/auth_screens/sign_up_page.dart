import 'package:flutter/material.dart';
import 'package:notifybear/screens/auth_screens/login_page.dart';

import '../../shared/my_colors.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.getBackgroundGradient(),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo and title
                Expanded(
                  child: Image.asset(
                    'assets/notifybear.com.png', // Add your logo image path here
                    height: 10,
                    width: 400,
                    //fit: BoxFit.contain,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  'SIGNUP',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),

                SizedBox(height: 30),
                // Login Form
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: MyColors.primaryColor,
                      width: 2,
                    ),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Username',
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.black.withOpacity(0.1),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: MyColors.primaryColor,
                      width: 2,
                    ),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Email ID',
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.black.withOpacity(0.1),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: MyColors.primaryColor,
                      width: 2,
                    ),
                  ),
                  child: TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.black.withOpacity(0.1),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 20.0),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 8),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Button color
                      padding: EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'SIGNUP',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                // Social Media Login Options
                Text(
                  'Signup Using',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                            'assets/google_icon.png'), // Add your Google icon image path
                        iconSize: 50,
                      ),
                    ),
                    SizedBox(width: 15),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                            'assets/facebook_icon.png'), // Add your Facebook icon image path
                        iconSize: 40,
                      ),
                    ),
                    SizedBox(width: 15),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                            'assets/apple_icon.png'), // Add your Apple icon image path
                        iconSize: 40,
                      ),
                    ),
                    SizedBox(width: 15),
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                            'assets/twitter_icon.png'), // Add your Twitter icon image path
                        iconSize: 40,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Sign Up Option
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Have an account already? ",
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Colors.blue.shade200,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
