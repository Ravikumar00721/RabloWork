import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/models/user_model.dart'; // Ensure correct import of your UserModel
import 'package:social_media_app/api/api_service.dart';   // Ensure correct import of your ApiService

class UserDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Retrieve the userId or email (string) passed from PostDetailsScreen
    final dynamic userArgument = Get.arguments;  // Get the user argument, could be userId (int) or email (String)

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: FutureBuilder<UserModel>(
        // If the argument is an int, fetch by userId, otherwise fetch by email
        future: (userArgument is int) 
            ? ApiService().getUser(userArgument)  // If it's an int, use userId
            : ApiService().getUserByEmail(userArgument), // If it's a String (email), use getUserByEmail()
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());  // Loading indicator
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load user details'));  // Error message
          } else if (!snapshot.hasData) {
            return Center(child: Text('User not found'));
          } else {
            final user = snapshot.data!;  // Assuming data is of type UserModel
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${user.name}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text('Email: ${user.email}'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
