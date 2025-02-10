import 'dart:developer';

import 'package:chat_application/controller/auth_controller.dart';
import 'package:chat_application/controller/chat_Controller.dart';
import 'package:chat_application/main.dart';
import 'package:chat_application/modal/userModal.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/service/google_auth.dart';
import 'package:chat_application/service/local_notification.dart';
import 'package:chat_application/service/user_firestore.dart';

import 'package:chat_application/views/home/profile_Section.dart';
import 'package:chat_application/views/signIn/sign_In.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/profileImage.dart';

var chatController = Get.put(ChatController());

final AuthController authController = Get.put(AuthController());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (chatController.isOnline.value == false) {
      chatController.isOnline.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(

        leading: profileImage(context),
        backgroundColor: Colors.black,
      centerTitle: true,
        title: const Text(
          'Chat App',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
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
              icon: const Icon(Icons.logout, color: Colors.white))
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Expanded(
            child: StreamBuilder(
              stream: UserFirestore.userFirestore.readAllUserFromFirestore(),
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
                      leading: Container(
                        decoration: BoxDecoration(
                            color: (userList[index].isOnline!)
                                ? Colors.purple
                                : null,
                            shape: BoxShape.circle),
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: CircleAvatar(
                            backgroundImage: (userList[index].profileImage !=
                                        null &&
                                    userList[index].profileImage!.isNotEmpty &&
                                    Uri.tryParse(userList[index].profileImage!)
                                            ?.hasAbsolutePath ==
                                        true)
                                ? NetworkImage(userList[index].profileImage!)
                                : const NetworkImage(
                                    'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
                          ),
                        ),
                      ),
                      title: Text(
                        userList[index].name!.toString(),
                        style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w600,letterSpacing: 1),
                      ),
                      subtitle:
                           Text(
                             userList[index].email!.toString(),
                              style:  TextStyle(color: Colors.grey,letterSpacing: 1.2)
                            ),

                      trailing: const Icon(Icons.chat_bubble_outline,
                          color: Colors.white),
                      onTap: () {
                        // Action on tap
                        chatController.getReceiver(
                            userList[index].email!,
                            userList[index].name!,
                            userList[index].profileImage!,
                            userList[index].isOnline!,
                            userList[index].isTyping!);

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
