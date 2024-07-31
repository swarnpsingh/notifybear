import 'package:flutter/material.dart';

import '../shared/my_colors.dart';
import '../shared/my_styles.dart';

class BearShop extends StatelessWidget {
  const BearShop({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.getBackgroundGradient(),
        ),
        child: Center(
          child: GradientText('Bear shop coming soon!!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              gradient: MyColors.getTextGradient()),
        ),
      ),
    );
  }
}
