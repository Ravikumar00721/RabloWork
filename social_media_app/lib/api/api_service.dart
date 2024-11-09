import 'package:dio/dio.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/models/comment_model.dart';
import 'package:social_media_app/models/user_model.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://jsonplaceholder.typicode.com';

  // Fetch posts from the API
  Future<List<PostModel>> getPosts() async {
    try {
      final response = await _dio.get('$_baseUrl/posts');
      if (response.statusCode == 200) {
        // Ensure the data is a list and safely map it to PostModel
        return (response.data as List)
            .map((json) => PostModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load posts, status code: ${response.statusCode}');
      }
    } catch (e) {
      // Log or handle the error here for better debugging
      throw Exception('Error fetching posts: $e');
    }
  }

  // Fetch comments for a specific post
  Future<List<CommentModel>> getComments(int postId) async {
    try {
      final response = await _dio.get('$_baseUrl/posts/$postId/comments');
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => CommentModel.fromJson(json))
            .toList();
      } else {
        throw Exception('Failed to load comments, status code: ${response.statusCode}');
      }
    } catch (e) {
      // Log or handle the error here for better debugging
      throw Exception('Error fetching comments for post $postId: $e');
    }
  }

  // Fetch user details by userId
  Future<UserModel> getUser(int userId) async {
    try {
      final response = await _dio.get('$_baseUrl/users/$userId');
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw Exception('Failed to load user details, status code: ${response.statusCode}');
      }
    } catch (e) {
      // Log or handle the error here for better debugging
      throw Exception('Error fetching user $userId details: $e');
    }
  }

  Future<UserModel> getUserByEmail(String email) async {
    try {
      final response = await _dio.get('$_baseUrl/users', queryParameters: {'email': email});
      if (response.statusCode == 200 && response.data.isNotEmpty) {
        return UserModel.fromJson(response.data[0]);  // Assuming the first match is the correct user
      } else {
        throw Exception('Failed to load user details');
      }
    } catch (e) {
      rethrow;
    }
  }
}
