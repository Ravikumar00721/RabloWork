import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {
  var count = 0.obs;

  void increment() {
    count++;
  }
}

class HomeScreen extends StatelessWidget {
  final HomeScreenController controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() => Text(
                  'Button pressed: ${controller.count.value} times',
                  style: TextStyle(fontSize: 20),
                )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.increment,
              child: Text('Increment Count'),
            ),
          ],
        ),
      ),
    );
  }
}
