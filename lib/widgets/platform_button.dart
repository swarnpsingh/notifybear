import 'package:flutter/material.dart';

class PlatformButton extends StatelessWidget {
  final String platform;
  final String iconPath;
  final VoidCallback onPressed;
  final bool isSelected;

  PlatformButton({
    required this.platform,
    required this.iconPath,
    required this.onPressed,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Color.fromRGBO(16, 19, 28, 1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            Image.asset(iconPath, width: 24, height: 24),
            SizedBox(width: 8),
            Text(
              platform,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
