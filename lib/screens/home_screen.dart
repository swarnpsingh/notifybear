import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notifybear/screens/youtube_channels_page.dart';
import 'package:notifybear/widgets/custom_drawer.dart';
import 'package:notifybear/widgets/latest_video_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:url_launcher/url_launcher.dart';

import '../firestore/platforms_data.dart';
import '../models/channel.dart';
import '../services/channel_service.dart';
import '../services/youtube_api_service.dart';
import '../shared/my_colors.dart';
import '../widgets/side_menu_panel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> selectedPlatforms = [];
  late SharedPreferences prefs;
  List<Channel> selectedChannels = [];
  List<Map<String, dynamic>> latestVideos = [];
  bool isLoading = true;
  final PanelController _panelController = PanelController();
  ChannelService _channelService = ChannelService();
  @override
  void initState() {
    super.initState();
    _initPrefs();
    _fetchSelectedChannels();
    _loadSelectedPlatforms();
  }

  Future<void> _loadSelectedPlatforms() async {
    try {
      final platformsData = PlatformsData();
      final platforms = await platformsData.fetchSelectedPlatforms();

      setState(() {
        selectedPlatforms = platforms;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching selected platforms: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching selected platforms: $e')));
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<void> _fetchSelectedChannels() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null) {
        throw 'User ID is null';
      }

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists) {
        final channelData = userDoc['selectedChannels'] as List<dynamic>?;

        if (channelData == null) {
          throw 'Channel data is null';
        }

        final List<Channel> loadedChannels =
            channelData.map((data) => Channel.fromMap(data)).toList();

        setState(() {
          selectedChannels = loadedChannels;
        });

        await _fetchLatestVideos();
      }
    } catch (e) {
      print('Error fetching selected channels: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching selected channels: $e')));
    }
  }

  Future<void> _fetchLatestVideos() async {
    try {
      final youtubeService = YouTubeApiService();
      final videos = await youtubeService.fetchLatestVideos(selectedChannels);

      if (videos == null) {
        throw 'Fetched videos are null';
      }

      setState(() {
        latestVideos = videos;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching latest videos: $e');
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching latest videos: $e')));
    }
  }

  Future<void> _handleVideoClick(String videoId, String videoUrl) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId == null) return;

      final DocumentReference userDoc =
          FirebaseFirestore.instance.collection('users').doc(userId);

      final DocumentSnapshot userSnapshot = await userDoc.get();

      if (userSnapshot.exists) {
        final data = userSnapshot.data() as Map<String, dynamic>;
        final List<dynamic> clickedVideos = data['latestVideos'] ?? [];

        if (!clickedVideos.contains(videoId)) {
          await userDoc.update({
            'latestVideos': FieldValue.arrayUnion([videoId]),
          });

          final DocumentReference videoDoc =
              FirebaseFirestore.instance.collection('videoClicks').doc(videoId);

          final DocumentSnapshot videoSnapshot = await videoDoc.get();

          if (videoSnapshot.exists) {
            await videoDoc.update({
              'clicks': FieldValue.increment(1),
            });
          } else {
            await videoDoc.set({
              'clicks': 1,
            });
          }
        }
      }
      print('Click count updated successfully');
      // Open the video URL in a browser or WebView
      _openVideoUrl(videoUrl);
    } catch (e) {
      print('Error handling video click: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error handling video click: $e')));
    }
  }

  void _openVideoUrl(String videoUrl) async {
    final Uri url = Uri.parse(videoUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _formatPublishedAt(String publishedAt) {
    DateTime dateTime = DateTime.parse(publishedAt);
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      body: SlidingUpPanel(
        controller: _panelController,
        panel: sideMenuPanel(),
        body: _buildMainContent(),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24.0),
          bottomLeft: Radius.circular(24.0),
        ),
        defaultPanelState: PanelState.CLOSED,
        maxHeight:
            MediaQuery.of(context).size.width * 0.5, // Adjust width as needed
        minHeight: 0,
        parallaxEnabled: true,
        parallaxOffset: 0.5,
        backdropEnabled: true,
        backdropOpacity: 0.5,
        slideDirection: SlideDirection.UP, // Slide from right
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: MyColors.getBackgroundGradient(),
      ),
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Row(
                  children: [
                    Builder(builder: (context) {
                      return IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.white,
                        ),
                        iconSize: 35,
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      );
                    }),
                    const Spacer(),
                    IconButton(
                      icon: Icon(Icons.shopping_cart, color: Colors.white),
                      iconSize: 35,
                      onPressed: () {
                        // Implement cart button functionality
                      },
                    ),
                  ],
                ),
                Container(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedChannels.length + 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return GestureDetector(
                          onTap: () async {
                            await _fetchSelectedChannels(); // Ensure channels are fetched
                            // Navigate to the add channel page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => YouTubeChannelsPage(
                                        selectedPlatforms: selectedPlatforms,
                                      )),
                            );
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: CircleAvatar(
                              radius: 35,
                              backgroundColor: Colors.black,
                              child: Icon(
                                Icons.add,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                      } else {
                        final channel = selectedChannels[index - 1];

                        return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CircleAvatar(
                              radius: 33,
                              backgroundImage: NetworkImage(channel.imageUrl),
                            ));
                      }
                    },
                  ),
                ),
                const Divider(
                  color: Colors.white,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text(
                        'Your Notifications',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      const Text('All',
                          style: TextStyle(color: Colors.white, fontSize: 21)),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                          onTap: () {
                            _panelController.isPanelOpen
                                ? _panelController.close()
                                : _panelController.open();
                          },
                          child: Icon(
                            Icons.expand_more_sharp,
                            color: Colors.white,
                            size: 40,
                          ))
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: latestVideos.length,
                    itemBuilder: (context, index) {
                      final video = latestVideos[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: GestureDetector(
                            onTap: () => _handleVideoClick(
                                video['id'] ?? '', video['videoUrl'] ?? ''),
                            child: latestVideoTile(
                              video['thumbnailUrl'] ?? '',
                              video['title'] ?? '',
                              Image.asset('assets/youtube.png'),
                              video['channelProfilePic'] ?? '',
                              Text(
                                '${video['channelName']} • ${video['clicks']} Clicks • ${_formatPublishedAt(video['publishedAt'] ?? '')}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            )),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
