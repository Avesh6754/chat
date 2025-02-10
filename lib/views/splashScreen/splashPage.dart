import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class Splashpage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAndToNamed('/auth');
    });

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.message,
              color: Colors.purple,
              size: 100,
            ).animate().fade(duration: 500.ms).scale(),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "ChatApp",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ).animate().fade(duration: 2000.ms).scale(),
          ],
        ),
      ),
    );
  }
}
