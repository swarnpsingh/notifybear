class TwitchFollowedChannel {
  final String id;
  final String login;
  final String name;
  final String imageUrl; // New field for profile image URL

  TwitchFollowedChannel({
    required this.id,
    required this.login,
    required this.name,
    required this.imageUrl,
  });

  factory TwitchFollowedChannel.fromJson(Map<String, dynamic> json) {
    return TwitchFollowedChannel(
      id: json['to_id'],
      login: json['to_login'],
      name: json['to_name'],
      imageUrl:
          json['profile_image_url'], // Assuming profile image URL field name
    );
  }
}
