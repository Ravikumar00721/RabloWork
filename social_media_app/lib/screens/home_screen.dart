import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/api/api_service.dart';  // Import ApiService
import 'package:social_media_app/models/app_data.dart';  // Import AppData Singleton
import 'package:social_media_app/models/post_model.dart';  // PostModel class

class HomeScreenController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  // Fetch posts from the API and store them in the singleton instance
  void fetchPosts() async {
    try {
      isLoading(true);  // Show loading indicator

      // Fetch posts from the API
      List<PostModel> posts = await ApiService().getPosts();

      // Store the fetched posts in AppData singleton
      AppData().setPosts(posts);

    } catch (e) {
      errorMessage.value = 'Failed to load posts: $e';
    } finally {
      isLoading(false); // Hide loading indicator
    }
  }
}

class HomeScreen extends StatelessWidget {
  final HomeScreenController controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    controller.fetchPosts();  // Fetch posts on screen load

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Obx(() {
          if (controller.isLoading.value) {
            return CircularProgressIndicator();  // Show loading spinner
          } else if (controller.errorMessage.isNotEmpty) {
            return Text(controller.errorMessage.value);  // Show error message if any
          } else {
            // Display list of posts
            List<PostModel> posts = AppData().getPosts();
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                var post = posts[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(post.title),
                    subtitle: Text(post.body),
                    onTap: () {
                      Get.toNamed('/post_details', arguments: post.id);
                    },
                  ),
                );
              },
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Add New Post',
      ),
    );
  }

  // Show a dialog to enter post details and then create a post
  void _showCreatePostDialog(BuildContext context) {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    Get.defaultDialog(
      title: "Create New Post",
      content: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: "Enter title"),
          ),
          TextField(
            controller: bodyController,
            decoration: InputDecoration(hintText: "Enter body"),
          ),
        ],
      ),
      textConfirm: "Submit",
      textCancel: "Cancel",
      onConfirm: () async {
        String title = titleController.text.trim();
        String body = bodyController.text.trim();
        
        if (title.isNotEmpty && body.isNotEmpty) {
          try {
            Get.back();  // Close dialog
            controller.isLoading(true);  // Show loading indicator
            // Call the createPost method
            PostModel newPost = await ApiService().createPost(title, body);
            // Update the posts list in AppData
            AppData().addPost(newPost);
          } catch (e) {
            controller.errorMessage.value = 'Failed to create post: $e';
          } finally {
            controller.isLoading(false);
          }
        } else {
          Get.snackbar("Error", "Title and Body cannot be empty");
        }
      },
    );
  }
}
