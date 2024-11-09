import 'package:dio/dio.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/models/comment_model.dart';
import 'package:social_media_app/models/user_model.dart';
import 'package:social_media_app/exception/app_exception.dart';

class ApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<PostModel>> getPosts() async {
    try {
      final response = await _dio.get('$_baseUrl/posts');
      if (response.statusCode == 200) {
        int userIdCounter = 1; // Start userId from 1 or any other initial value

        // Ensure the data is a list and map it to PostModel with incremented userId
        return (response.data as List).map((json) {
          json['userId'] = userIdCounter++; // Manually add and increment userId
          return PostModel.fromJson(json);
        }).toList();
      } else {
        throw InvalidResponseException(
            'Failed to load posts, status code: ${response.statusCode}');
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
        throw InvalidResponseException(
            'Failed to load comments, status code: ${response.statusCode}');
      }
    } catch (e) {
      // Log or handle the error here for better debugging
      throw Exception('Error fetching comments for post $postId: $e');
    }
  }

  Future<UserModel> getUser(int userId) async {
    try {
      final response = await _dio.get(
          '$_baseUrl/users/$userId'); // Ensure this API fetches the right user
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw InvalidResponseException(
            'Failed to load user details, status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user details: $e');
    }
  }

  Future<PostModel> createPost(String title, String body) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/posts',
        data: {
          'title': title,
          'body': body,
          'userId': 1
        }, // Example userId, adjust as needed
      );

      if (response.statusCode == 201) {
        // HTTP status code for resource creation
        return PostModel.fromJson(response.data);
      } else {
        throw InvalidResponseException(
            "Failed to create post: ${response.statusCode}");
      }
    } on DioError catch (e) {
      throw NetworkException("Network error occurred while creating post: $e");
    } catch (e) {
      throw UnknownException("An unknown error occurred: $e");
    }
  }
}
