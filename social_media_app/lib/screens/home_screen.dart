import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/models/app_data.dart';  // Import AppData Singleton
import 'package:social_media_app/models/post_model.dart';  // PostModel class

class HomeScreenController extends GetxController {
  var isLoading = true.obs;
  var errorMessage = ''.obs;

  // Fetch posts and store them in the singleton instance with dummy data
  void fetchPosts() async {
    try {
      isLoading(true);  // Show loading indicator

      // Simulate network delay for loading data
      await Future.delayed(Duration(seconds: 2));

      // Dummy data to simulate posts
      List<Map<String, dynamic>> fetchedPosts = [
        {'id': 1, 'title': 'Post 1', 'body': 'Post 1 body content goes here...'},
        {'id': 2, 'title': 'Post 2', 'body': 'Post 2 body content goes here...'},
        {'id': 3, 'title': 'Post 3', 'body': 'Post 3 body content goes here...'},
        {'id': 4, 'title': 'Post 4', 'body': 'Post 4 body content goes here...'},
      ];

      // Convert the dummy data to List<PostModel>
      List<PostModel> posts = fetchedPosts.map((post) => PostModel.fromJson(post)).toList();

      // Store the fetched posts in AppData singleton
      AppData().setPosts(posts);

    } catch (e) {
      errorMessage.value = 'Failed to load posts';
    } finally {
      isLoading(false); // Hide loading indicator
    }
  }
}

class HomeScreen extends StatelessWidget {
  final HomeScreenController controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    // Fetch posts when the screen is initialized
    controller.fetchPosts();

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
            // Get the posts from AppData singleton
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
                      // Navigate to PostDetailsScreen with post ID
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
        onPressed: () {
          // Action for FAB, for now just a placeholder
          print("FAB clicked");
          // You can later show a dialog or navigate to a new screen to add a new post
        },
        child: Icon(Icons.add),
        tooltip: 'Add New Post',
      ),
    );
  }
}
