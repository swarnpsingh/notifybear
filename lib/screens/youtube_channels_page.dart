import 'package:flutter/material.dart';
import 'package:notifybear/services/youtube_api_service.dart';

import '../models/channel.dart';
import '../models/channel_tile.dart';
import '../services/instagram_api_service.dart';
import '../shared/my_colors.dart';

class YouTubeChannelsPage extends StatefulWidget {
  @override
  _YouTubeChannelsPageState createState() => _YouTubeChannelsPageState();
}

class _YouTubeChannelsPageState extends State<YouTubeChannelsPage> {
  List<Channel> channels = [];
  List<Channel> filteredChannels = [];
  bool isLoading = true;
  TextEditingController _searchController = TextEditingController();
  YouTubeApiService _youTubeApiService = YouTubeApiService();
  InstagramApiService _instagramApiService = InstagramApiService();
  String selectedPlatform = 'YouTube';

  @override
  void initState() {
    super.initState();
    _loadChannels();
    _searchController.addListener(_filterChannels);
  }

  Future<void> _loadChannels() async {
    setState(() => isLoading = true);
    try {
      if (selectedPlatform == 'YouTube') {
        final loadedChannels = await _youTubeApiService.getSubscribedChannels();
        setState(() {
          channels = loadedChannels;
          filteredChannels = loadedChannels; //isme dikkat aa sakti hai
          isLoading = false;
        });
      } else if (selectedPlatform == 'Instagram') {
        setState(() {
          channels = [];
          filteredChannels = channels;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading channels: $e');
      setState(() {
        isLoading = false;
      });
      // Show an error message to the user
      SnackBar(content: Text('Error loading the channels: $e'));
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

  void _onPlatformSelected(String platform) {
    setState(() {
      selectedPlatform = platform;
      _loadChannels();
    });
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPlatformButton('YouTube', 'assets/youtube.png'),
              _buildPlatformButton('Instagram', 'assets/instagram.png'),
            ],
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
                          return ChannelTile(channel: filteredChannels[index]);
                        },
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
