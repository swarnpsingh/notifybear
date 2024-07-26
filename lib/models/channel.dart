class Channel {
  final String name;
  final String imageUrl;

  Channel({required this.name, required this.imageUrl});

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      name: json['title'],
      imageUrl: json['thumbnails']['default']['url'],
    );
  }
}
