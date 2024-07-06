import 'package:flutter/material.dart';
import 'package:notifybear/screens/auth_screens/entry_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    setState(() {
      _isAuthenticated = token != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return Scaffold();
    } else {
      return EntryScreen();
    }
  }
}
