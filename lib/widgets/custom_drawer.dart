import 'package:flutter/material.dart';

import '../shared/my_colors.dart';
import '../shared/my_styles.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int _selectedDrawerIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        padding: EdgeInsets.all(5),
        children: <Widget>[
          SizedBox(
            height: 75,
          ),
          ListTile(
            title: Text('Home',
                style: TextStyle(
                    color: _selectedDrawerIndex == 0
                        ? Colors.blue
                        : Colors.white)),
            onTap: () {
              setState(() {
                _selectedDrawerIndex = 0;
              });
              // Handle the navigation
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(
              'Your Creators',
              style: TextStyle(
                  color:
                      _selectedDrawerIndex == 1 ? Colors.blue : Colors.white),
            ),
            onTap: () {
              setState(() {
                _selectedDrawerIndex = 1;
              });
              // Handle the navigation
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Scaffold()));
            },
          ),
          ListTile(
            title: Text('Add/Remove a Creator',
                style: TextStyle(
                    color: _selectedDrawerIndex == 2
                        ? Colors.blue
                        : Colors.white)),
            onTap: () {
              setState(() {
                _selectedDrawerIndex = 2;
              });
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Scaffold()));
              // Handle the navigation
            },
          ),
          ListTile(
            title: Text('Bear Shop',
                style: TextStyle(
                    color: _selectedDrawerIndex == 3
                        ? Colors.blue
                        : Colors.white)),
            onTap: () {
              setState(() {
                _selectedDrawerIndex = 3;
              });
              // Handle the navigation
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Scaffold()));
            },
          ),
          ListTile(
            title: Text('Settings',
                style: TextStyle(
                    color: _selectedDrawerIndex == 4
                        ? Colors.blue
                        : Colors.white)),
            onTap: () {
              setState(() {
                _selectedDrawerIndex = 4;
              });
              // Handle the navigation
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Scaffold()));
            },
          ),
          SizedBox(
            height: 230,
          ),
          ListTile(
            leading: Image.asset('assets/Crown.png'),
            title: GradientText(
              'Bear Premium',
              style: TextStyle(fontWeight: FontWeight.bold),
              gradient: MyColors.getTextGradient(),
            ),
            onTap: () {
              // Handle the navigation
              Navigator.pop(context);
            },
          ),
          SwitchListTile(
            title: Text(
              'Dark mode On',
              style: TextStyle(color: Colors.white),
            ),
            value: true,
            onChanged: (bool value) {
              // Handle dark mode switch
            },
            activeColor: Colors.black,
            inactiveThumbColor: Colors.grey,
            activeTrackColor: Colors.white,
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.white),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Handle logout
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.switch_account, color: Colors.white),
            title: Text(
              'Switch Account',
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              // Handle account switching
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
