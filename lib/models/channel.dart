class Channel {
  final String name;
  final String imageUrl;
  final String id;

  Channel({required this.name, required this.imageUrl, required this.id});

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['resourceId']['channelId'] ?? '',
      name: json['title'],
      imageUrl: json['thumbnails']['default']['url'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }

  factory Channel.fromMap(Map<String, dynamic> map) {
    return Channel(
      id: map['id'] ?? '',
      name: map['name'] ?? " ",
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}
