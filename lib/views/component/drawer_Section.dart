import 'package:flutter/material.dart';

import '../../modal/userModal.dart';
import '../../service/auth_service.dart';
class DraweSection extends StatelessWidget {
  const DraweSection({
    super.key,
    required this.userModal,
  });

  final UserModal userModal;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          DrawerHeader(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AuthService.user!.photoURL == null
                    ? const NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/3135/3135715.png')
                    : NetworkImage(AuthService.user!.photoURL!),
              )),
          Row(
            children: [
              const Icon(Icons.email),
              const SizedBox(
                width: 20,
              ),
              Text(
                userModal.email!,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
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
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
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
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              )
            ],
          ),
        ],
      ),
    );
  }
}