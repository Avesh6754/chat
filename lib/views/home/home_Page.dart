import 'dart:developer';

import 'package:chat_application/controller/auth_controller.dart';
import 'package:chat_application/controller/chat_Controller.dart';
import 'package:chat_application/modal/userModal.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/service/google_auth.dart';
import 'package:chat_application/service/local_notification.dart';
import 'package:chat_application/service/user_firestore.dart';
import 'package:chat_application/views/home/profilePgae.dart';
import 'package:chat_application/views/signIn/sign_In.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

var chatController = Get.put(ChatController());

final AuthController authController = Get.put(AuthController());

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
@override
  void initState()  {
    // TODO: implement initState
    super.initState();

    if(chatController.isOnline.value==false)
      {
        chatController.isOnline.value=true;
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: Drawer(
        backgroundColor: Colors.black,
        width: 250,
        shape: Border.all(color: Colors.white24,width: 1),
        child:StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: UserFirestore.userFirestore.getCurrentUserAndShow(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasData && snapshot.data!.exists) {
              Map<String, dynamic>? data = snapshot.data!.data();
              if (data == null) {
                return const Center(child: Text("User data is null"));
              }

              UserModal userModal = UserModal.fromMap(data);

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    DrawerHeader(
                      child: StatefulBuilder(
                        builder: (context, setState) => GestureDetector(
                          onTap: () async {
                            setState(() {});
                            await controller.sendImageToServer(userModal);
                          },
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: (userModal.profileImage != null &&
                                userModal.profileImage!.isNotEmpty &&
                                Uri.tryParse(userModal.profileImage!)
                                    ?.hasAbsolutePath ==
                                    true)
                                ? NetworkImage(userModal.profileImage!)
                                : const NetworkImage(
                                'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.email, color: Colors.white),
                        const SizedBox(width: 20),
                        Text(
                          userModal.email ?? "No email",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.person, color: Colors.white),
                        const SizedBox(width: 20),
                        Text(
                          userModal.name ?? "No name",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.phone, color: Colors.white),
                        const SizedBox(width: 20),
                        Text(
                          userModal.phone ?? "No phone",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white),
                        )
                      ],
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text("No user data found"));
          },
        ),

      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        elevation: 2,
        shadowColor: Colors.white24,
        title: const Text(
          'Chat App',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                print("object");
                await LocalNotification.instance.initNotification();
              },
              icon: const Icon(Icons.notification_add, color: Colors.white)),
          IconButton(
              onPressed: () async {},
              icon: const Icon(Icons.schedule, color: Colors.white)),
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
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: userList[index].isOnline == true
                          ? Text(
                              'Online',
                              style: TextStyle(color: Colors.green),
                            )
                          : Text(
                              'Offline',
                              style: TextStyle(color: Colors.green),
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
