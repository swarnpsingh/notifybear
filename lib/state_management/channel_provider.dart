import 'package:flutter/material.dart';

import '../models/channel.dart';
import '../services/instagram_api_service.dart';
import '../services/linkedin_api_service.dart';
import '../services/twitch_api_service.dart';
import '../services/youtube_api_service.dart';

class ChannelProvider extends ChangeNotifier {
  List<Channel> youtubeChannels = [];
  List<Channel> instagramChannels = [];
  List<Channel> twitchChannels = [];
  List<Channel> linkedInChannels = [];
  List<Channel> filteredChannels = [];

  bool isLoading = true;
  String selectedPlatform = 'YouTube'; // Default platform

  // Track if channels have been loaded for each platform
  Map<String, bool> loadedPlatforms = {
    'YouTube': false,
    'Instagram': false,
    'Twitch': false,
    'LinkedIn': false,
  };

  final YouTubeApiService _youTubeApiService = YouTubeApiService();
  final InstagramApiService _instagramApiService = InstagramApiService();
  final TwitchApiService _twitchApiService = TwitchApiService();
  final LinkedInApiService _linkedInApiService = LinkedInApiService();

  Future<void> loadChannels(List<String> selectedPlatforms) async {
    // Check if any of the selected platforms haven't been loaded yet
    bool needLoading = selectedPlatforms.any(
      (platform) =>
          !(loadedPlatforms[platform] ?? false), // Default to false if null
    );

    // If no platforms need loading, just update the filtered channels
    if (!needLoading) {
      _updateFilteredChannels();
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      // Only load channels for platforms that haven't been loaded yet
      if (selectedPlatforms.contains('YouTube') &&
          !loadedPlatforms['YouTube']!) {
        youtubeChannels = await _youTubeApiService.getSubscribedChannels();
        loadedPlatforms['YouTube'] = true;
      }
      if (selectedPlatforms.contains('Instagram') &&
          !loadedPlatforms['Instagram']!) {
        instagramChannels = await _instagramApiService.getInstagramChannels();
        loadedPlatforms['Instagram'] = true;
      }
      // if (selectedPlatforms.contains('Twitch') && !loadedPlatforms['Twitch']!) {
      //   twitchChannels = await _twitchApiService.getFollowedChannels();
      //   loadedPlatforms['Twitch'] = true;
      // }
      // if (selectedPlatforms.contains('LinkedIn') && !loadedPlatforms['LinkedIn']!) {
      //   linkedInChannels = await _linkedInApiService.getFollowedAccounts();
      //   loadedPlatforms['LinkedIn'] = true;
      // }

      _updateFilteredChannels();
    } catch (e) {
      print('Error loading channels: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _updateFilteredChannels() {
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
    notifyListeners();
  }

  void setSelectedPlatform(String platform) {
    selectedPlatform = platform;
    _updateFilteredChannels();
  }
}
