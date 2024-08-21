import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notifybear/screens/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/channel.dart';
import '../models/channel_tile.dart';
import '../models/linkedin_account.dart';
import '../models/twitch_followed_channel.dart';
import '../services/instagram_api_service.dart';
import '../services/linkedin_api_service.dart';
import '../services/twitch_api_service.dart';
import '../services/twitch_auth.dart';
import '../services/youtube_api_service.dart';
import '../shared/my_colors.dart';
import '../widgets/twitch_channel_tile.dart';

class YouTubeChannelsPage extends StatefulWidget {
  final List<String> selectedPlatforms;
  YouTubeChannelsPage({required this.selectedPlatforms});
  @override
  _YouTubeChannelsPageState createState() => _YouTubeChannelsPageState();
}

class _YouTubeChannelsPageState extends State<YouTubeChannelsPage> {
  List channels = [];
  List filteredChannels = [];
  List<Channel> selectedChannels = [];
  bool isLoading = true;
  bool isAuthenticated = false;
  TextEditingController _searchController = TextEditingController();
  YouTubeApiService _youTubeApiService = YouTubeApiService();
  InstagramApiService _instagramApiService = InstagramApiService();
  TwitchApiService _twitchApiService = TwitchApiService();
  LinkedInApiService _linkedInApiService = LinkedInApiService();
  TwitchAuth twitchAuth = TwitchAuth();
  String selectedPlatform = 'YouTube';
  List youtubeChannels = [];
  List instagramChannels = [];
  List twitchChannels = [];
  List linkedInChannels = [];

  @override
  void initState() {
    super.initState();
    _loadChannels();
    _searchController.addListener(_filterChannels);
    //_linkedInApiService.authenticate();
    _authenticateWithLinkedIn();
    _authenticateWithTwitch();
    _loadSelectedChannels();
    _loadChannels();
  }

  Future<void> _loadSelectedChannels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final channelData = userDoc['selectedChannels'] as List<dynamic>;
        final List<Channel> loadedChannels =
            channelData.map((data) => Channel.fromMap(data)).toList();

        setState(() {
          selectedChannels = loadedChannels;
        });
      }
    } catch (e) {
      print('Error loading selected channels: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading selected channels: $e')));
    }

    _authenticateWithLinkedIn();
    _authenticateWithTwitch();
    _loadChannels();
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
      // Clear previous channels
      youtubeChannels.clear();
      instagramChannels.clear();
      twitchChannels.clear();
      linkedInChannels.clear();

      if (widget.selectedPlatforms.contains('YouTube')) {
        final loadedChannels = await _youTubeApiService.getSubscribedChannels();
        setState(() {
          youtubeChannels.addAll(loadedChannels);
        });
      }
      if (widget.selectedPlatforms.contains('Instagram')) {
        final instagramChannels =
            await _instagramApiService.getInstagramChannels();
        setState(() {
          instagramChannels.addAll(instagramChannels);
        });
      }
      if (widget.selectedPlatforms.contains('Twitch')) {
        await _twitchApiService.authenticate(context);
        final twitchChannels = await _twitchApiService.getFollowedChannels();
        setState(() {
          twitchChannels.addAll(twitchChannels);
        });
      }
      if (widget.selectedPlatforms.contains('LinkedIn')) {
        await _linkedInApiService.authenticate();
        final linkedInChannels =
            await _linkedInApiService.getFollowedAccounts();
        setState(() {
          linkedInChannels.addAll(linkedInChannels);
        });
      }

      // Update filteredChannels based on the selectedPlatform
      _updateFilteredChannels();

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error loading channels: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading the channels: $e')));
    }
  }

  void _updateFilteredChannels() {
    setState(() {
      switch (selectedPlatform) {
        case 'YouTube':
          filteredChannels = List.from(youtubeChannels);
          break;
        case 'Instagram':
          filteredChannels = List.from(instagramChannels);
          break;
        case 'Twitch':
          filteredChannels = List.from(twitchChannels);
          break;
        case 'LinkedIn':
          filteredChannels = List.from(linkedInChannels);
          break;
        default:
          filteredChannels = [];
      }
    });
    _filterChannels(); // Apply any existing search query
  }

  void _filterChannels() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredChannels = filteredChannels
          .where((channel) => channel.name.toLowerCase().contains(query)
              // final channelName = channel.name.toLowerCase().contains(query);
              // return channelName.contains(query);
              )
          .toList();
    });
  }

  void _onPlatformSelected(String platform) {
    setState(() {
      selectedPlatform = platform;
      isAuthenticated = false; // Reset authentication state
    });
    _updateFilteredChannels();
    _searchController.clear(); // Clear the search query when changing platforms
  }

  void _toggleChannelSelection(Channel channel) {
    setState(() {
      if (selectedChannels.contains(channel)) {
        selectedChannels.remove(channel);
      } else {
        selectedChannels.add(channel);
      }
    });
  }

  Future<void> _saveSelectedChannels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString(
          'user_id'); // Assume user ID is stored in SharedPreferences

      final List<Map<String, dynamic>> channelData =
          selectedChannels.map((channel) => channel.toMap()).toList();

      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'selectedChannels': channelData,
      });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
      );
    } catch (e) {
      print('Error saving selected channels: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving selected channels: $e')));
    }
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
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
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
            padding: const EdgeInsets.all(18),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _filterChannels(),
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
                            return ChannelTile(
                              channel: channel,
                              onAdd: () => _toggleChannelSelection(channel),
                              platform: 'youtube',
                            );
                          } else if (selectedPlatform == 'Twitch' &&
                              channel is TwitchFollowedChannel) {
                            // Ensure to check if the channel is of type TwitchFollowedChannel
                            return TwitchChannelTile(
                              twitchFollowedChannel: channel,
                              onAdd: () {},
                              platform: 'twitch',
                            );
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
              onPressed: _saveSelectedChannels,
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
    // Only show the button if the platform is in the selectedPlatforms list
    if (!widget.selectedPlatforms.contains(platform)) {
      return SizedBox.shrink();
    }
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
