class PostModel {
  final int id;
  final String title;
  final String body;
  final int userId;  // Add userId to link each post to a specific user

  PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,  // Initialize userId
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      userId: json['userId'],  // Parse userId from the API response
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'userId': userId,  // Include userId when converting to JSON
    };
  }
}
