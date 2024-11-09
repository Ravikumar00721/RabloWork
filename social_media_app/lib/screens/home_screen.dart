import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/api/api_service.dart';
import 'package:social_media_app/models/app_data.dart';
import 'package:social_media_app/models/post_model.dart';
import 'package:social_media_app/exception/app_exception.dart';

class HomeScreenController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  // Fetch posts from the API and store them in the singleton instance
  void fetchPosts() async {
    try {
      isLoading(true);  // Show loading indicator
      errorMessage.value = '';  // Clear previous error message
      
      // Fetch posts from the API
      List<PostModel> posts = await ApiService().getPosts();
      AppData().setPosts(posts);  // Store posts in AppData singleton

    } on NetworkException catch (e) {
      errorMessage.value = e.toString();  // Display network error message
    } on TimeoutException catch (e) {
      errorMessage.value = e.toString();  // Display timeout error message
    } on InvalidResponseException catch (e) {
      errorMessage.value = e.toString();  // Display invalid response error message
    } on UnknownException catch (e) {
      errorMessage.value = e.toString();  // Display unknown error message
    } catch (e) {
      errorMessage.value = 'An unexpected error occurred';  // General fallback
    } finally {
      isLoading(false);  // Hide loading indicator
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
            if (posts.isEmpty) {
              return Text('No posts available');  // Handle empty list case
            }
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
            AppData().addPost(newPost);  // Update the posts list in AppData
          } on NetworkException catch (e) {
            controller.errorMessage.value = e.toString();
            Get.snackbar("Error", "Network error: ${e.message}");
          } on TimeoutException catch (e) {
            controller.errorMessage.value = e.toString();
            Get.snackbar("Error", "Timeout: ${e.message}");
          } on InvalidResponseException catch (e) {
            controller.errorMessage.value = e.toString();
            Get.snackbar("Error", "Invalid response: ${e.message}");
          } on UnknownException catch (e) {
            controller.errorMessage.value = e.toString();
            Get.snackbar("Error", "Unknown error: ${e.message}");
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
