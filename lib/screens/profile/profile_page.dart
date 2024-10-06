import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notifybear/screens/coming_soon.dart';
import 'package:notifybear/widgets/custom_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../shared/my_colors.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _image;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _name = 'your name';
  String _email = 'your email';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? 'your name';
      _email = prefs.getString('email') ?? 'your email';
      String? imagePath = prefs.getString('imagePath');
      if (imagePath != null) {
        _image = File(imagePath);
      }
    });
  }

  Future<void> _saveProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_image != null) {
      prefs.setString('imagePath', _image!.path);
    }
  }

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        _saveProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/profile_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 30),
            Row(
              children: [
                Builder(builder: (context) {
                  return IconButton(
                    icon: Icon(Icons.menu, color: Colors.white),
                    iconSize: 35,
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                }),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.shopping_cart, color: Colors.white),
                  iconSize: 35,
                  onPressed: () {
                    // Implement cart button functionality
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: getImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : AssetImage('assets/profile.png') as ImageProvider,
              ),
            ),
            SizedBox(height: 10),
            Text(
              _name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _email,
              style: TextStyle(color: Colors.white70),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                ).then((_) {
                  // Refresh the profile data after returning from the EditProfilePage
                  _loadProfile();
                });
              },
              icon: Icon(Icons.edit, color: Colors.white),
              label:
                  Text('Edit Profile', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: MyColors.getBackgroundGradient(),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildInfoCard('Creators Followed', '47'),
                            _buildInfoCard('Bear Points', '128'),
                          ],
                        ),
                        SizedBox(height: 20),
                        _buildMenuItem('Manage Creators', Icons.people),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ComingSoon()));
                            },
                            child: _buildMenuItem(
                                'Your Activity', Icons.chat_bubble)),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ComingSoon()));
                            },
                            child: _buildMenuItem(
                                'Rewards and Badges', Icons.star)),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ComingSoon()));
                            },
                            child: _buildMenuItem(
                                'Refer a friend', Icons.person_add)),
                        SizedBox(height: 10),
                        Divider(color: Colors.white24),
                        SizedBox(height: 10),
                        _buildMenuItem(
                            'Customization and Preferences', Icons.settings),
                        _buildMenuItem('Privacy Policy', Icons.shield),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Container(
      height: 130,
      width: 150,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Color.fromRGBO(26, 26, 26, 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      color: Color.fromRGBO(26, 26, 26, 1),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: TextStyle(color: Colors.white)),
        trailing: Icon(Icons.chevron_right, color: Colors.white),
      ),
    );
  }
}
