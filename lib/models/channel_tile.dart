import 'package:flutter/material.dart';

import 'channel.dart';

class ChannelTile extends StatelessWidget {
  final Channel channel;

  ChannelTile({required this.channel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Color.fromRGBO(26, 26, 26, 1),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 25.0,
            backgroundImage: NetworkImage(channel.imageUrl),
          ),
          SizedBox(width: 15.0),
          Expanded(
            child: Text(
              channel.name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
          ),
          Container(
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(10)),
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                onPressed: () {
                  // Implement adding the channel to your app
                },
              ))
        ],
      ),
    );
  }
}
