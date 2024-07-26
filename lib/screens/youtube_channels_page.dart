import 'package:flutter/material.dart';
import 'package:notifybear/models/linkedin_account.dart';
import 'package:notifybear/screens/welcome_screen.dart';
import 'package:notifybear/services/linkedin_api_service.dart';
import 'package:notifybear/services/twitch_api_service.dart';
import 'package:notifybear/services/twitch_auth.dart';
import 'package:notifybear/services/youtube_api_service.dart';
import 'package:notifybear/widgets/twitch_channel_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/channel_tile.dart';
import '../models/twitch_followed_channel.dart';
import '../services/instagram_api_service.dart';
import '../shared/my_colors.dart';

class YouTubeChannelsPage extends StatefulWidget {
  @override
  _YouTubeChannelsPageState createState() => _YouTubeChannelsPageState();
}

class _YouTubeChannelsPageState extends State<YouTubeChannelsPage> {
  List channels = [];
  List filteredChannels = [];
  bool isLoading = true;
  bool isAuthenticated = false;
  TextEditingController _searchController = TextEditingController();
  YouTubeApiService _youTubeApiService = YouTubeApiService();
  InstagramApiService _instagramApiService = InstagramApiService();
  TwitchApiService _twitchApiService = TwitchApiService();
  LinkedInApiService _linkedInApiService = LinkedInApiService();
  TwitchAuth twitchAuth = TwitchAuth();
  String selectedPlatform = 'YouTube';

  @override
  void initState() {
    super.initState();
    _loadChannels();
    _searchController.addListener(_filterChannels);
    //_linkedInApiService.authenticate();
    _authenticateWithLinkedIn();
    _authenticateWithTwitch();
  }

  Future<void> _authenticateWithLinkedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('linkedin_access_token');
      if (accessToken != null) {
        setState(() {
          isAuthenticated = true;
        });
        _loadChannels(); // Load LinkedIn accounts after authentication
      }
    } catch (e) {
      print('LinkedIn authentication failed: $e');
      // Handle authentication failure here
    }
  }

  Future<void> _authenticateWithTwitch() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('twitch_access_token');
      if (accessToken != null) {
        setState(() {
          isAuthenticated = true;
        });
        _loadChannels();
      }
    } catch (e) {
      print('twitch authentication failed: $e');
      // Handle authentication failure here
    }
  }
  // Future<void> authenticate() async {
  //   try {
  //     bool success = await _twitchApiService.authenticate(context);
  //     if (success) {
  //       setState(() {
  //         isAuthenticated = true;
  //       });
  //       return true;
  //     }
  //     return false;
  //   } catch (e) {
  //     print('Authentication failed: $e');
  //     return false;
  //   }
  // }

  Future<void> _loadChannels() async {
    setState(() => isLoading = true);
    try {
      if (selectedPlatform == 'YouTube') {
        final loadedChannels = await _youTubeApiService.getSubscribedChannels();
        setState(() {
          channels = loadedChannels;
          filteredChannels = loadedChannels;
          isLoading = false;
        });
      } else if (selectedPlatform == 'Instagram') {
        setState(() {
          channels = [];
          filteredChannels = channels;
          isLoading = false;
        });
      } else if (selectedPlatform == 'Twitch') {
        _authenticateWithTwitch();
        await _twitchApiService.authenticate(context);
        final followedChannels = await _twitchApiService.getFollowedChannels();
        setState(() {
          channels = followedChannels;
          filteredChannels = followedChannels;
          isLoading = false;
        });
      } else if (selectedPlatform == 'LinkedIn') {
        await _linkedInApiService.authenticate();
        final followedAccounts =
            await _linkedInApiService.getFollowedAccounts();

        setState(() {
          channels = followedAccounts;
          filteredChannels = followedAccounts;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading channels: $e');
      setState(() {
        isLoading = false;
      });
      // Show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading the channels: $e')));
    }
  }

  void _filterChannels() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredChannels = channels.where((channel) {
        final channelName = channel.name.toLowerCase();
        return channelName.contains(query);
      }).toList();
    });
  }

  void _onPlatformSelected(String platform) async {
    setState(() {
      selectedPlatform = platform;
      isAuthenticated = false; // Reset authentication state
    });
    _loadChannels();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: MyColors.getBackgroundGradient(),
        ),
        child: Column(children: [
          const SizedBox(
            height: 30,
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 50,
                child: Text(
                  'Add Creators',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(18),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Creators',
                hintStyle: TextStyle(color: Colors.grey[600]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                filled: true,
                fillColor: const Color(0xFF2C2C2E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _buildPlatformButton('YouTube', 'assets/youtube.png'),
                _buildPlatformButton('Instagram', 'assets/instagram.png'),
                _buildPlatformButton('Twitch', 'assets/twitch.png'),
                _buildPlatformButton(
                    'LinkedIn', 'assets/linkedin.png'), // Add LinkedIn button
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredChannels.isEmpty
                    ? Center(
                        child: Text(
                        'No subscribed channels found',
                        style: TextStyle(color: Colors.white),
                      ))
                    : ListView.builder(
                        itemCount: filteredChannels.length,
                        itemBuilder: (context, index) {
                          final channel = filteredChannels[index];

                          if (selectedPlatform == 'YouTube' ||
                              selectedPlatform == 'Instagram') {
                            // Assuming 'ChannelTile' is used for both YouTube and Instagram channels
                            return ChannelTile(channel: channel);
                          } else if (selectedPlatform == 'Twitch' &&
                              channel is TwitchFollowedChannel) {
                            // Ensure to check if the channel is of type TwitchFollowedChannel
                            return TwitchChannelTile(
                                twitchFollowedChannel: channel);
                          } else if (selectedPlatform == 'LinkedIn' &&
                              channel is LinkedInAccount) {
                            // Adjust this for LinkedIn channel display
                            return ListTile(
                              title: Text(channel.name),
                              // Add more UI elements for LinkedIn if needed
                            );
                          }

                          // Handle cases where the platform does not match or the channel type is unexpected
                          return SizedBox
                              .shrink(); // or another appropriate fallback widget
                        },
                      ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 60,
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WelcomeScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildPlatformButton(String platform, String iconPath) {
    return GestureDetector(
      onTap: () => _onPlatformSelected(platform),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: selectedPlatform == platform
              ? Colors.blue
              : Color.fromRGBO(16, 19, 28, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              height: 22,
              width: 22,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              platform,
              style: TextStyle(
                color:
                    selectedPlatform == platform ? Colors.black : Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
