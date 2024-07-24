class LinkedInAccount {
  final String name;
  final String id;

  LinkedInAccount({
    required this.name,
    required this.id,
  });

  factory LinkedInAccount.fromJson(Map<String, dynamic> json) {
    return LinkedInAccount(
      name: json['name'],
      id: json['id'],
    );
  }
}
