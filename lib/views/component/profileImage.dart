import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/service/user_firestore.dart';
import 'package:chat_application/views/home/profile_Section.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

profileImage(BuildContext context) {
  return GestureDetector(
    onTap: () {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSection(),));
    },
    child: Container(
      margin:  EdgeInsets.all(8),
      child: StreamBuilder<String>(
        stream: UserFirestore.userFirestore.getProfileImage(AuthService.authService.getUser()!.email!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            );
          } else if (snapshot.hasData) {
            return ClipOval(
              child: snapshot.data != null
                  ? CachedNetworkImage(
                imageUrl: snapshot.data!,
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                errorWidget: (context, url, error) =>
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
              )
                  : const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
            );
          } else {
            return const CircleAvatar(
              backgroundColor: Colors.grey,
              child: Icon(Icons.person, color: Colors.white),
            );
          }
        },
      ),
    ),
  );
}