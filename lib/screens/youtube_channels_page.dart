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
      final loadedChannels = await _youTubeApiService.getSubscribedChannels();
      setState(() {
        channels = loadedChannels;
        isLoading = false;
      });
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
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredChannels.isEmpty
                    ? Center(child: Text('No subscribed channels found'))
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
