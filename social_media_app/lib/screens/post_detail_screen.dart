import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/models/comment_model.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/api/api_service.dart';

class PostDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postId = Get.arguments as int;  // Get the post ID passed from the previous screen

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: FutureBuilder(
        future: Future.wait([ 
          ApiService().getPosts(),  // Fetch all posts
          ApiService().getComments(postId),  // Fetch comments using postId
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final posts = snapshot.data![0] as List<PostModel>;
            final comments = snapshot.data![1] as List<CommentModel>;

            // Find the post with the matching postId
            final post = posts.firstWhere((post) => post.id == postId);

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display post details
                  Text(
                    post.title,
                    style: Theme.of(context).textTheme.titleLarge,  // Updated to titleLarge
                  ),
                  SizedBox(height: 8),
                  Text(
                    post.body,
                    style: Theme.of(context).textTheme.bodyLarge,  // Updated to bodyLarge
                  ),
                  SizedBox(height: 16),
                  // Add a button to navigate to the User Profile Screen
                  ElevatedButton(
                    onPressed: () {
                      // Pass the actual userId of the post's author
                      final userId = post.userId; // Use the userId from the post
                      Get.toNamed('/user_profile', arguments: userId);
                    },
                    child: Text('View Author Profile'),
                  ),
                  SizedBox(height: 16),
                  // Display comments heading
                  Text(
                    'Comments',
                    style: Theme.of(context).textTheme.titleMedium,  // Updated to titleMedium
                  ),
                  SizedBox(height: 8),
                  // Only make the comment section scrollable
                  Expanded(
                    child: comments.isNotEmpty
                        ? ListView.builder(
                            itemCount: comments.length,
                            itemBuilder: (context, index) {
                              final comment = comments[index];
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(comment.name),
                                  subtitle: Text(comment.body),
                                ),
                              );
                            },
                          )
                        : Center(child: Text('No comments found.')),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data found.'));
          }
        },
      ),
    );
  }
}
