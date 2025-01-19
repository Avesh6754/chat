import 'package:chat_application/controller/chat_Controller.dart';
import 'package:chat_application/modal/userModal.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/service/google_auth.dart';
import 'package:chat_application/service/user_firestore.dart';
import 'package:chat_application/views/signIn/sign_In.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
var chatController=Get.put(ChatController());
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
              Map<String, dynamic> data =
                  snapshot.data!.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    DrawerHeader(
                        child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AuthService.user!.photoURL == null
                          ? NetworkImage(
                              'https://cdn-icons-png.flaticon.com/512/3135/3135715.png')
                          : NetworkImage(AuthService.user!.photoURL!),
                    )),
                    Row(
                      children: [
                        Icon(Icons.email),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          AuthService.user!.email!,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Icon(Icons.drive_file_rename_outline),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      appBar: AppBar(
        title: Text(
          'Chat App',
          style: TextStyle(fontWeight: FontWeight.bold),
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
              icon: Icon(Icons.logout))
        ],
      ),
      body: FutureBuilder(
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
                  child: Text(userList[index].name!.characters.characterAt(0).toString()), // First letter of the name
                  backgroundColor: Colors.blueGrey,
                ),
                title: Text(userList[index].name!.toString()),
                subtitle: Text(userList[index].email!.toString()),
                trailing: const Icon(Icons.chat_bubble_outline),
                onTap: () {
                  // Action on tap
                  chatController.getReceiver(userList[index].email!, userList[index].name!);
                  Get.toNamed('/chat');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Tapped on ${userList[index].name}'),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () {},
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
