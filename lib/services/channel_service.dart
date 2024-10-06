import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firestore/platforms_data.dart';
import '../models/channel.dart';

class ChannelService {
  Future<List<Channel>> fetchSelectedChannels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null) {
        throw 'User ID is null';
      }

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final channelData = userDoc['selectedChannels'] as List<dynamic>?;

        if (channelData == null) {
          throw 'Channel data is null';
        }

        final List<Channel> loadedChannels =
            channelData.map((data) => Channel.fromMap(data)).toList();

        return loadedChannels;
      } else {
        throw 'User document does not exist';
      }
    } catch (e) {
      print('Error fetching selected channels: $e');
      throw e;
    }
  }

  Future<List<String>> loadSelectedPlatforms() async {
    try {
      final platformsData = PlatformsData();
      final platforms = await platformsData.fetchSelectedPlatforms();
      return platforms;
    } catch (e) {
      print('Error fetching selected platforms: $e');
      throw e;
    }
  }

  Future<void> toggleChannelSelection(
      Channel channel, BuildContext context) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null) return;

      final DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      final DocumentSnapshot userSnapshot = await userDoc.get();

      if (userSnapshot.exists) {
        final data = userSnapshot.data() as Map<String, dynamic>;
        final List<dynamic> selectedChannelsData =
            data['selectedChannels'] ?? [];

        final isSelected =
            selectedChannelsData.any((ch) => ch['id'] == channel.id);

        if (isSelected) {
          await userDoc.update({
            'selectedChannels': FieldValue.arrayRemove([channel.toMap()]),
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${channel.name} removed from selection')),
          );
        } else {
          await userDoc.update({
            'selectedChannels': FieldValue.arrayUnion([channel.toMap()]),
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${channel.name} added to selection')),
          );
        }
      }
    } catch (e) {
      print('Error toggling channel selection: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error toggling channel selection: $e')),
      );
    }
  }
}
