import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/models/user_model.dart';  // Ensure correct import of your UserModel
import 'package:social_media_app/api/api_service.dart';   // Ensure correct import of your ApiService

class UserDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final int userId = Get.arguments as int;  // Get the userId passed from the PostDetailsScreen

    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: FutureBuilder<UserModel>(
        future: ApiService().getUser(userId),  // Fetch user details using userId
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
                  Text('Username: ${user.username}'),
                  SizedBox(height: 8),
                  Text('Phone: ${user.phone}'),
                  SizedBox(height: 8),
                  Text('Website: ${user.website}'),
                  SizedBox(height: 16),
                  Text(
                    'Address:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('Street: ${user.address.street}'),
                  Text('Suite: ${user.address.suite}'),
                  Text('City: ${user.address.city}'),
                  Text('Zipcode: ${user.address.zipcode}'),
                  SizedBox(height: 16),
                  Text(
                    'Company:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text('Name: ${user.company.name}'),
                  Text('Catch Phrase: ${user.company.catchPhrase}'),
                  Text('BS: ${user.company.bs}'),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

