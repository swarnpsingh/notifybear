import 'package:flutter/material.dart';
import 'package:notifybear/models/twitch_followed_channel.dart';

class TwitchChannelTile extends StatelessWidget {
  final TwitchFollowedChannel? twitchFollowedChannel;
  final VoidCallback onAdd;
  final String platform;

  TwitchChannelTile(
      {this.twitchFollowedChannel,
      required this.onAdd,
      required this.platform});

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
            backgroundImage: NetworkImage(twitchFollowedChannel!.imageUrl),
          ),
          SizedBox(width: 15.0),
          Expanded(
            child: Text(
              twitchFollowedChannel!.name,
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
                  onPressed: onAdd))
        ],
      ),
    );
  }
}
