import 'package:flutter/material.dart';

Widget latestVideoTile(String thumbnail, String title, Image platformIcon,
    String profilePic, Text subtitle) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
    decoration: BoxDecoration(
      color: Color.fromRGBO(26, 26, 26, 1),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18.0),
                  child: Image.network(
                    thumbnail,
                    width: 400,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 0,
              child: Container(
                  height: 50,
                  width: 50,
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(12)),
                  ),
                  child: platformIcon),
            ),
          ],
        ),
        SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        SizedBox(height: 4),
        Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(profilePic),
            ),
            SizedBox(width: 10),
            Expanded(child: subtitle),
            Icon(Icons.more_vert, color: Colors.grey),
          ],
        ),
      ],
    ),
  );
}
