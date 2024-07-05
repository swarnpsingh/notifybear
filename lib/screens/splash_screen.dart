import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notifybear/screens/auth_screens/entry_screen.dart';

import '../shared/my_colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.1; // Start with slight visibility
  bool _visible = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _preloadImage();
    _startFadeAnimation();
  }

  // Preload the image to avoid delay
  void _preloadImage() {
    Future.delayed(Duration.zero, () {
      precacheImage(AssetImage('assets/splash_image.png'), context);
    });
  }

  void _startFadeAnimation() {
    // Start the initial fade in after preloading
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });

    // _timer = Timer.periodic(Duration(seconds: 3), (timer) {
    //   if (mounted) {
    //     setState(() {
    //       _visible = !_visible;
    //       _opacity = _visible ? 1.0 : 0.0;
    //     });
    //   }
    // });

    // Navigate to HomeScreen after some delay
    Timer(Duration(seconds: 6), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => EntryScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when disposing the widget
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.getBackgroundGradient(),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: _opacity,
            duration: Duration(seconds: 2), // Reduce animation duration
            child: Image.asset('assets/splash_image.png'),
          ),
        ),
      ),
    );
  }
}
