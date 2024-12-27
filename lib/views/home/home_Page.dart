import 'package:chat_application/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home Screen',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          actions: [
            IconButton(onPressed: () {
              AuthService.authService.logoutUser();
              User? user=AuthService.authService.getUser();
              if(user==null)
                {
                  Get.offAndToNamed('/');
                }
            }, icon: Icon(Icons.logout))
          ],
        ),
    );
  }
}
