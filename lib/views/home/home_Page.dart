import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/service/google_auth.dart';
import 'package:chat_application/views/signIn/sign_In.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List users = [
      {'name': 'Alice', 'lastMessage': 'Hey there!'},
      {'name': 'Bob', 'lastMessage': 'What'},
      {'name': 'Charlie', 'lastMessage': 'See you soon.'},
      {'name': 'Diana', 'lastMessage': 'Can we meet tomorrow?'},
      {'name': 'Eve', 'lastMessage': 'Let'},
      {'name': 'Alice', 'lastMessage': 'Hey there!'},
      {'name': 'Bob', 'lastMessage': 'What'},
      {'name': 'Charlie', 'lastMessage': 'See you soon.'},
      {'name': 'Diana', 'lastMessage': 'Can we meet tomorrow?'},
      {'name': 'Eve', 'lastMessage': 'Let'},
      {'name': 'Alice', 'lastMessage': 'Hey there!'},
      {'name': 'Bob', 'lastMessage': 'What'},
      {'name': 'Charlie', 'lastMessage': 'See you soon.'},
      {'name': 'Diana', 'lastMessage': 'Can we meet tomorrow?'},
      {'name': 'Eve', 'lastMessage': 'Let'},
      {'name': 'Alice', 'lastMessage': 'Hey there!'},
      {'name': 'Bob', 'lastMessage': 'What'},
      {'name': 'Charlie', 'lastMessage': 'See you soon.'},
      {'name': 'Diana', 'lastMessage': 'Can we meet tomorrow?'},
      {'name': 'Eve', 'lastMessage': 'Let'},
    ];
    return Scaffold(
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              DrawerHeader(
                  child: CircleAvatar(
                radius: 50,
                    backgroundImage:AuthService.user!.photoURL==null?NetworkImage('https://cdn-icons-png.flaticon.com/512/3135/3135715.png'): NetworkImage(AuthService.user!.photoURL!),
              )),
              Row(

                children: [
                  Icon(Icons.email),
                  SizedBox(width: 20,),
                  Text(AuthService.user!.email!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)
                ],
              ),
              SizedBox(height: 20,),
              Row(

                children: [
                  Icon(Icons.drive_file_rename_outline),
                  SizedBox(width: 20,),
                 Text(AuthService.user!.displayName!,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)
                ],
              ),

            ],
          ),
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
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(user['name']![0]), // First letter of the name
              backgroundColor: Colors.blueGrey,
            ),
            title: Text(user['name']!),
            subtitle: Text(user['lastMessage']!),
            trailing: const Icon(Icons.chat_bubble_outline),
            onTap: () {
              // Action on tap
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Tapped on ${user['name']}'),
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
      ),
    );
  }
}
