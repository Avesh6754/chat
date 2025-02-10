import 'package:chat_application/modal/userModal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Profilepgae extends StatelessWidget {
  const Profilepgae({super.key,   required this.userModal,});

  final UserModal userModal;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Page',
        ),
      ),
      body: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: (userModal.profileImage != null)
                ? NetworkImage(userModal.profileImage!)
                : NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'),
          ),
          Row(
            children: [
              const Icon(Icons.email),
              const SizedBox(
                width: 20,
              ),
              Text(
                userModal.email!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Icon(Icons.person),
              const SizedBox(
                width: 20,
              ),
              Text(
                userModal.name!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const Icon(Icons.phone),
              const SizedBox(
                width: 20,
              ),
              Text(
                userModal.phone!,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )
            ],
          ),
        ],
      ),
    );
  }
}
