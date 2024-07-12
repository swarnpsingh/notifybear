import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../models/channel.dart';

class YouTubeApiService {
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
}
