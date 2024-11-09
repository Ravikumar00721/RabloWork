import 'package:social_media_app/models/post_model.dart';
class AppData {
  // Singleton instance
  static final AppData _instance = AppData._internal();
  
  factory AppData() {
    return _instance;
  }

  AppData._internal();  // Private constructor

  List<PostModel> _posts = [];  // List to hold posts

  // Get posts
  List<PostModel> getPosts() {
    return _posts;
  }

  // Set posts
  void setPosts(List<PostModel> posts) {
    _posts = posts;
  }

  // Add a new post
  void addPost(PostModel post) {
    _posts.add(post);
  }

}
