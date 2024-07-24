import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../models/twitch_followed_channel.dart';

class TwitchApiService {
  final String clientId = 'ameq4n94nzvqyqloo3523t5hbcgcp8';
  final String clientSecret = '8k40wb4myxohefuyh3tc25t085uyp7';
  final String redirectUri =
      'https://github.com/scarredhands/twitch-redirect/blob/main/redirect.html';
  String accessToken = '';
  String userId = '';

  Future<String> getUserId() async {
    if (accessToken.isEmpty) {
      throw Exception('Not authenticated. Call authenticateWithWebView first.');
    }

    final response = await http.get(
      Uri.parse('https://api.twitch.tv/helix/users'),
      headers: {
        'Client-ID': clientId,
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['data'] != null && data['data'].isNotEmpty) {
        return data['data'][0]['id'];
      } else {
        throw Exception('User data not found');
      }
    } else {
      throw Exception('Failed to get user information');
    }
  }

  Future<void> authenticate(BuildContext context) async {
    final String state = Uuid().v4();
    final String scope = 'user:read:follows';

    final String authUrl = 'https://id.twitch.tv/oauth2/authorize'
        '?client_id=$clientId'
        '&redirect_uri=$redirectUri'
        '&response_type=code'
        '&scope=$scope'
        '&state=$state';

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params)
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onNavigationRequest: (NavigationRequest request) async {
                if (request.url.startsWith(redirectUri)) {
                  final Uri uri = Uri.parse(request.url);
                  final String? code = uri.queryParameters['code'];
                  final String? returnedState = uri.queryParameters['state'];

                  // Close the WebView after handling the authentication
                  Navigator.of(context).maybePop();

                  if (code != null && returnedState == state) {
                    await _getAccessToken(code);
                  } else {
                    throw Exception('Invalid state parameter');
                  }
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse(authUrl));

    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('Twitch Authentication')),
        body: WebViewWidget(controller: controller),
      ),
    ));
  }

  Future<void> _getAccessToken(String code) async {
    final response = await http.post(
      Uri.parse('https://id.twitch.tv/oauth2/token'),
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': code,
        'grant_type': 'authorization_code',
        'redirect_uri': redirectUri,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      accessToken = data['access_token'];
      // Store access token securely (example using SharedPreferences)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('twitch_access_token', accessToken);

      userId = await getUserId();
    } else {
      throw Exception('Failed to obtain access token');
    }
  }

  Future<List<TwitchFollowedChannel>> getFollowedChannels() async {
    if (accessToken.isEmpty || userId.isEmpty) {
      throw Exception('Not authenticated. Call authenticateWithWebView first.');
    }

    final response = await http.get(
      Uri.parse('https://api.twitch.tv/helix/users/follows?from_id=$userId'),
      headers: {
        'Client-ID': clientId,
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> channelsData = data['data'];

      // Fetch profile image URLs for each channel
      List<TwitchFollowedChannel> followedChannels = [];
      for (var channel in channelsData) {
        String channelId = channel['to_id'];
        String login = channel['to_login'];
        String displayName = channel['to_name'];

        // Fetch detailed information including profile image URL
        final channelResponse = await http.get(
          Uri.parse('https://api.twitch.tv/helix/users?id=$channelId'),
          headers: {
            'Client-ID': clientId,
            'Authorization': 'Bearer $accessToken',
          },
        );

        if (channelResponse.statusCode == 200) {
          final channelData = json.decode(channelResponse.body)['data'][0];
          String profileImageUrl = channelData['profile_image_url'];

          TwitchFollowedChannel followedChannel = TwitchFollowedChannel(
            id: channelId,
            login: login,
            name: displayName,
            imageUrl: profileImageUrl,
          );

          followedChannels.add(followedChannel);
        } else {
          throw Exception('Failed to load channel details for $login');
        }
      }

      return followedChannels;
    } else {
      throw Exception('Failed to load followed channels');
    }
  }
}
