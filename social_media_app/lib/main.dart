import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_media_app/screens/home_screen.dart';
import 'package:social_media_app/screens/post_detail_screen.dart';
import 'package:social_media_app/screens/user_details_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Social Media App',
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(name: '/post_details', page: () => PostDetailsScreen()),
        GetPage(name: '/user_profile', page: () => UserDetailsScreen()),  // Register UserDetailsScreen route
      ],
    );
  }
}
