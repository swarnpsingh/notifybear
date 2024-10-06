import 'package:flutter/material.dart';

import '../models/channel.dart';
import '../models/channel_tile.dart';
import '../models/linkedin_account.dart';
import '../models/twitch_followed_channel.dart';
import '../services/channel_service.dart';
import '../shared/my_colors.dart';
import '../widgets/platform_button.dart';
import '../widgets/twitch_channel_tile.dart';

class YourCreatorsPage extends StatefulWidget {
  const YourCreatorsPage({super.key});

  @override
  State<YourCreatorsPage> createState() => _YourCreatorsPageState();
}

class _YourCreatorsPageState extends State<YourCreatorsPage> {
  List<Channel> selectedChannels = [];
  String selectedPlatform = 'YouTube';
  List<String> selectedPlatforms = [];
  bool isLoading = true;
  ChannelService channelService = ChannelService();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSelectedChannels();
    _loadSelectedPlatforms();
    _searchController.addListener(_filterChannels);
  }

  Future<void> _fetchSelectedChannels() async {
    try {
      final loadedChannels = await channelService.fetchSelectedChannels();
      setState(() {
        selectedChannels = loadedChannels;
      });
      // await fetchLatestVideos();
    } catch (e) {
      print('Error fetching selected channels: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching selected channels: $e')));
    }
  }

  Future<void> _loadSelectedPlatforms() async {
    try {
      final platforms = await channelService.loadSelectedPlatforms();
      setState(() {
        selectedPlatforms = platforms;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching selected platforms: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching selected platforms: $e')));
    }
  }

  void _onPlatformSelected(String platform) {
    setState(() {
      selectedPlatform = platform;
    });

    _searchController.clear(); // Clear the search query when changing platforms
  }

  void _filterChannels() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      selectedChannels = selectedChannels
          .where((channel) => channel.name.toLowerCase().contains(query)
              // final channelName = channel.name.toLowerCase().contains(query);
              // return channelName.contains(query);
              )
          .toList();
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
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                height: 50,
                child: Text(
                  'Your Creators',
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
                PlatformButton(
                  platform: 'YouTube',
                  iconPath: 'assets/youtube.png',
                  isSelected: selectedPlatform == 'YouTube',
                  onPressed: () => _onPlatformSelected('YouTube'),
                ),
                PlatformButton(
                  platform: 'Instagram',
                  iconPath: 'assets/instagram.png',
                  isSelected: selectedPlatform == 'Instagram',
                  onPressed: () => _onPlatformSelected('Instagram'),
                ),
                PlatformButton(
                  platform: 'Twitch',
                  iconPath: 'assets/twitch.png',
                  isSelected: selectedPlatform == 'Twitch',
                  onPressed: () => _onPlatformSelected('Twitch'),
                ),
                PlatformButton(
                  platform: 'LinkedIn',
                  iconPath: 'assets/linkedin.png',
                  isSelected: selectedPlatform == 'LinkedIn',
                  onPressed: () => _onPlatformSelected('LinkedIn'),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : selectedChannels.isEmpty
                    ? Center(
                        child: Text(
                        'No subscribed channels found',
                        style: TextStyle(color: Colors.white),
                      ))
                    : ListView.builder(
                        itemCount: selectedChannels.length,
                        itemBuilder: (context, index) {
                          final channel = selectedChannels[index];

                          if (selectedPlatform == 'YouTube') {
                            // Assuming 'ChannelTile' is used for both YouTube and Instagram channels
                            return ChannelTile(
                              channel: channel,
                              platform: 'youtube',
                            );
                          } else if (selectedPlatform == 'Twitch' &&
                              channel is TwitchFollowedChannel) {
                            // Ensure to check if the channel is of type TwitchFollowedChannel
                            return TwitchChannelTile(
                              //twitchFollowedChannel: channel,
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
        ]),
      ),
    );
  }
}
