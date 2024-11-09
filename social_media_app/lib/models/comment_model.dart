class CommentModel {
  final int id;
  final String name;
  final String body;

  CommentModel({required this.id, required this.name, required this.body});

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      name: json['name'],
      body: json['body'],
    );
  }
}
