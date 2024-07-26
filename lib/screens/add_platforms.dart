import 'package:flutter/material.dart';
import 'package:notifybear/models/social_platform.dart';
import 'package:notifybear/screens/youtube_channels_page.dart';
import 'package:notifybear/services/twitch_api_service.dart';

import '../shared/my_colors.dart';

class AddPlatforms extends StatefulWidget {
  const AddPlatforms({super.key});

  @override
  State<AddPlatforms> createState() => _AddPlatformsState();
}

class _AddPlatformsState extends State<AddPlatforms> {
  List<SocialPlatform> displayedPlatforms = [];
  TwitchApiService twitchApiService = TwitchApiService();
  TextEditingController searchController = TextEditingController();
  static List<SocialPlatform> platforms = [
    SocialPlatform(name: 'YouTube', iconPath: 'assets/youtube.png'),
    SocialPlatform(name: 'Twitch', iconPath: 'assets/twitch.png'),
    SocialPlatform(name: 'Instagram', iconPath: 'assets/instagram.png'),
    SocialPlatform(name: 'TikTok', iconPath: 'assets/tiktok.png'),
    SocialPlatform(name: 'LinkedIn', iconPath: 'assets/linkedin.png'),
  ];

  @override
  void initState() {
    super.initState();
    displayedPlatforms = platforms;
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String searchTerm = searchController.text.toLowerCase();
    print("Search term: $searchTerm");
    setState(() {
      displayedPlatforms = platforms
          .where((platform) => platform.name.toLowerCase().contains(searchTerm))
          .toList();
      print(
          "Displayed platforms: ${displayedPlatforms.map((e) => e.name).toList()}"); // Debugging print statement
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: MyColors.getBackgroundGradient(),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Add Social Platforms',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: 360,
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search Apps',
                      hintStyle: TextStyle(color: Colors.grey[600]),
                      prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                      filled: true,
                      fillColor: const Color(0xFF2C2C2E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: displayedPlatforms.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Image.asset(
                                    displayedPlatforms[index].iconPath,
                                    width: 50,
                                    height: 50,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    displayedPlatforms[index].name,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 60,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => YouTubeChannelsPage()));
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
