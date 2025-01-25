import 'package:chat_application/controller/auth_controller.dart';
import 'package:chat_application/controller/chat_Controller.dart';
import 'package:chat_application/modal/userModal.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/service/google_auth.dart';
import 'package:chat_application/service/local_notification.dart';
import 'package:chat_application/service/user_firestore.dart';
import 'package:chat_application/views/signIn/sign_In.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/drawer_Section.dart';

var chatController = Get.put(ChatController());
var authController = Get.put(AuthController());

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: FutureBuilder(
          future: UserFirestore.userFirestore.getCurrentUserAndShow(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              Map? data = snapshot.data!.data();
              UserModal userModal = UserModal.fromMap(data!);
              return DraweSection(userModal: userModal);
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Chat App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                print("object");
                await LocalNotification.instance.initNotification();
              },
              icon: const Icon(Icons.notification_add)),
          IconButton(
              onPressed: () async {
                await AuthService.authService.logoutUser();
                await GoogleAuth.googleAuth.signOutFromGoogle();
                User? user = AuthService.authService.getUser();
                if (user == null) {
                  controller.txtEmail.clear();
                  controller.txtPassword.clear();
                  Get.offAndToNamed('/signIn');
                }
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body:
        Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: UserFirestore.userFirestore.readAllUserFromFirestore(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List data = snapshot.data!.docs;
                  List<UserModal> userList = [];
                  for (var user in data) {
                    userList.add(UserModal.fromMap(user.data()));
                  }
                  return ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueGrey,
                          child: Text(userList[index]
                              .name!
                              .characters.toUpperCase()
                              .characterAt(0)
                              .toString()),
                        ),
                        title: Text(userList[index].name!.toString()),
                        subtitle: Text(userList[index].email!.toString()),
                        trailing: const Icon(Icons.chat_bubble_outline),
                        onTap: () {
                          // Action on tap
                          chatController.getReceiver(
                              userList[index].email!, userList[index].name!);
                          Get.toNamed('/chat');
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],

      ),
    );
  }
}

