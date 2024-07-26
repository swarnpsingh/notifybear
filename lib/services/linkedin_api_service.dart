import 'dart:convert';

import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/linkedin_account.dart';

class LinkedInApiService {
  static const String clientId = '86nn4mthmyd6cg';
  static const String clientSecret = 'rkrS0Ig04zYAFZ2f';
  static const String redirectUri =
      "https://scarredhands.github.io/twitch-redirect/redirect.html";
  static const String _baseUrl = 'https://api.linkedin.com/v2';

  String? _accessToken;

  Future<void> authenticate() async {
    try {
      final result = await FlutterWebAuth.authenticate(
        url: 'https://www.linkedin.com/oauth/v2/authorization?' +
            'response_type=code&client_id=$clientId&redirect_uri=$redirectUri' +
            '&scope=r_liteprofile', // Adjust scope as per your requirements
        callbackUrlScheme: "myapp", // Replace with your app's scheme
      );

      final code = Uri.parse(result).queryParameters['code'];
      await _getAccessToken(code);
    } catch (e) {
      print('Authentication failed: $e');
      throw Exception('Failed to authenticate');
    }
  }

  Future<void> _getAccessToken(String? code) async {
    final response = await http.post(
      Uri.parse('https://www.linkedin.com/oauth/v2/accessToken'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'authorization_code',
        'code': code!,
        'redirect_uri': redirectUri,
        'client_id': clientId,
        'client_secret': clientSecret,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _accessToken = data['access_token'];

      // Store access token securely (example using SharedPreferences)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('linkedin_access_token', _accessToken!);
    } else {
      throw Exception('Failed to get access token');
    }
  }

  Future<List<LinkedInAccount>> getFollowedAccounts() async {
    // Load access token from storage
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('linkedin_access_token');

    if (_accessToken == null) {
      throw Exception('Access token not available');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/me/followedCompanies'),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body)['elements'];
      return data.map((e) => LinkedInAccount.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load followed accounts');
    }
  }
}
