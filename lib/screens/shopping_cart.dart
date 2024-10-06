import 'package:flutter/material.dart';

import '../shared/my_colors.dart';
import '../shared/my_styles.dart';

class ShoppingCart extends StatelessWidget {
  const ShoppingCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.getBackgroundGradient(),
        ),
        child: Center(
          child: GradientText('Your shopping cart coming soon!!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              gradient: MyColors.getTextGradient()),
        ),
      ),
    );
    ;
  }
}
