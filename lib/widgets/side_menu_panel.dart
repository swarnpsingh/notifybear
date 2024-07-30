import 'package:flutter/material.dart';

Widget sideMenuPanel() {
  return Container(
    color: Colors.grey[900],
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('sideMenu',
              style: TextStyle(color: Colors.white, fontSize: 20)),
        ),
        ListTile(
          title: Text('All', style: TextStyle(color: Colors.blue)),
        ),
        ExpansionTile(
          title: Text('Platform', style: TextStyle(color: Colors.white)),
          children: [
            ListTile(
                title: Text('YouTube', style: TextStyle(color: Colors.white))),
            ListTile(
                title: Text('Twitch', style: TextStyle(color: Colors.white))),
            // ListTile(title: Text('X', style: TextStyle(color: Colors.white))),
            ListTile(
                title:
                    Text('Instagram', style: TextStyle(color: Colors.white))),
            // ListTile(title: Text('LinkedIn', style: TextStyle(color: Colors.white))),
            //ListTile(title: Text('Facebook', style: TextStyle(color: Colors.white))),
          ],
        ),
        ExpansionTile(
          title: Text('Content type', style: TextStyle(color: Colors.white)),
          children: [
            ListTile(
                title: Text('Video', style: TextStyle(color: Colors.white))),
            ListTile(
                title: Text('Post', style: TextStyle(color: Colors.white))),
            ListTile(
                title:
                    Text('Livestream', style: TextStyle(color: Colors.white))),
            ListTile(
                title: Text('Tweet', style: TextStyle(color: Colors.white))),
          ],
        ),
      ],
    ),
  );
}
