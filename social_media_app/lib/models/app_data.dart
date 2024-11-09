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

  // Update an existing post
  void updatePost(int postId, PostModel updatedPost) {
    int index = _posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      _posts[index] = updatedPost;
    }
  }

  // Delete a post
  void deletePost(int postId) {
    _posts.removeWhere((post) => post.id == postId);
  }
}
