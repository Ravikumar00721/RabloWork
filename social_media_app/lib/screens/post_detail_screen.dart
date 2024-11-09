import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/models/comment_model.dart';
import 'package:social_media_app/api/api_service.dart';

class PostDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postId = Get.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: Text('Post Details'),
      ),
      body: FutureBuilder(
        future: ApiService().getComments(postId), // Fetch comments using postId
        builder: (context, AsyncSnapshot<List<CommentModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final comments = snapshot.data!;
            return ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(comment.name),
                    subtitle: Text(comment.body),
                    onTap: () {
                      // Navigate to the UserProfileScreen when the author name is tapped
                      Get.toNamed('/user_profile', arguments: comment.email); // Pass the user email or ID
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No comments found.'));
          }
        },
      ),
    );
  }
}
