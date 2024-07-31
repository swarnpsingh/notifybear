import 'package:flutter/material.dart';

import '../shared/my_colors.dart';
import '../shared/my_styles.dart';

class SavedNotifications extends StatelessWidget {
  const SavedNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.getBackgroundGradient(),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: GradientText('saved notifications feature coming soon!!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                gradient: MyColors.getTextGradient()),
          ),
        ),
      ),
    );
    ;
  }
}
