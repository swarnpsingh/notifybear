import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

class TwitchAuth extends StatefulWidget {
  @override
  _TwitchAuthState createState() => _TwitchAuthState();
}

class _TwitchAuthState extends State<TwitchAuth> {
  final String clientId = "ameq4n94nzvqyqloo3523t5hbcgcp8";
  final String redirectUri =
      "https://scarredhands.github.io/twitch-redirect/redirect.html";
  final String scope = "user:read:follows";
  final String state = "cf98e1c2-26a3-43d3-91a9-4ac50b3e627f";

  Future<void> startTwitchAuth() async {
    final authUrl = "https://id.twitch.tv/oauth2/authorize"
        "?client_id=$clientId"
        "&redirect_uri=$redirectUri"
        "&response_type=token"
        "&scope=$scope"
        "&state=$state";

    try {
      final result = await FlutterWebAuth.authenticate(
        url: authUrl,
        callbackUrlScheme: "https",
      );

      final uri = Uri.parse(result);
      final accessToken = uri.fragment
          .split('&')
          .firstWhere((part) => part.startsWith('access_token='))
          .split('=')[1];

      print("Access Token: $accessToken");
      // Use the access token for further API calls
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Twitch Authentication'),
      ),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
