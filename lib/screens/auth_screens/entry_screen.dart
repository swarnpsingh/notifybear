import 'package:flutter/material.dart';
import 'package:notifybear/shared/my_colors.dart';
import 'package:notifybear/widgets/outline_button.dart';

import '../../shared/my_styles.dart';

class EntryScreen extends StatefulWidget {
  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.getBackgroundGradient(),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icon-mascot.png',
                  height: 200,
                ),
                SizedBox(height: 10),
                GradientText('notifybear',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                    gradient: MyColors.getTextGradient()),
                SizedBox(height: 10),
                Text(
                  'Stay on top of your favorite creators\' updates.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                  ),
                ),
                SizedBox(height: 50),
                OutlineButton(text: 'LOGIN', onPressed: () {}),
                SizedBox(height: 25),
                OutlineButton(text: 'SIGN UP', onPressed: () {})
              ],
            ),
          ),
        ),
      ),
    );
  }
}
