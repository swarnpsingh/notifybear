import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;

import '../models/channel.dart';

class YouTubeApiService {
  var unescape = HtmlUnescape();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/youtube.readonly',
    ],
  );

  Future<List<Channel>> getSubscribedChannels() async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        throw Exception('Sign in failed');
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      final String? token = auth.accessToken;

      if (token == null) {
        throw Exception('Failed to get access token');
      }

      final response = await http.get(
        Uri.parse(
            'https://www.googleapis.com/youtube/v3/subscriptions?part=snippet&mine=true&maxResults=50'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['items'] as List)
            .map((item) => Channel.fromJson(item['snippet']))
            .toList();
      } else {
        throw Exception('Failed to load channels');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchLatestVideos(
      List<Channel> channels) async {
    try {
      final GoogleSignInAccount? account = await _googleSignIn.signIn();
      if (account == null) {
        throw Exception('Sign in failed');
      }

      final GoogleSignInAuthentication auth = await account.authentication;
      final String? token = auth.accessToken;

      if (token == null) {
        throw Exception('Failed to get access token');
      }

      final List<Map<String, dynamic>> videos = [];

      for (Channel channel in channels) {
        final channelId = channel.id;

        // Fetch channel details to get the profile picture and channel name
        final channelResponse = await http.get(
          Uri.parse(
              'https://www.googleapis.com/youtube/v3/channels?part=snippet&id=$channelId'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        String channelProfilePic = '';
        String channelName = '';
        if (channelResponse.statusCode == 200) {
          final channelData = json.decode(channelResponse.body);
          channelProfilePic = channelData['items'][0]['snippet']['thumbnails']
              ['default']['url'];
          channelName = channelData['items'][0]['snippet']['title'];
        } else {
          print(
              'Failed to fetch channel details for $channelId: ${channelResponse.body}');
        }

        final response = await http.get(
          Uri.parse(
              'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&maxResults=5&order=date&type=video'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final items = data['items'];

          for (var item in items) {
            final videoId = item['id']['videoId'];
            final snippet = item['snippet'];

            // Fetch click count from Firestore
            DocumentSnapshot clickDoc = await FirebaseFirestore.instance
                .collection('videoClicks')
                .doc(videoId)
                .get();

            int clicks = 0;
            if (clickDoc.exists) {
              clicks =
                  (clickDoc.data() as Map<String, dynamic>)['clicks'] as int? ??
                      0;
            }

            // Decode the HTML entities in the title
            final decodedTitle = unescape.convert(snippet['title']);

            videos.add({
              'id': videoId,
              'title': decodedTitle,
              'thumbnailUrl': snippet['thumbnails']['high']['url'],
              'publishedAt': snippet['publishedAt'],
              'clicks': clicks,
              'videoUrl': 'https://www.youtube.com/watch?v=$videoId',
              'platform': 'YouTube',
              'channelProfilePic': channelProfilePic,
              'channelName': channelName, // Add channel name here
            });
          }
        } else {
          print(
              'Failed to fetch videos for channel $channelId: ${response.body}');
        }
      }

      return videos;
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
}
