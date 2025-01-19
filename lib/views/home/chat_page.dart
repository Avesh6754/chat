import 'package:chat_application/modal/chat_Modal.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/service/user_firestore.dart';
import 'package:chat_application/views/home/home_Page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatController.receiverName.value),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: UserFirestore.userFirestore
                  .readChatFromFirestore(chatController.receiverEmail.value),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.error.toString()),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List data = snapshot.data!.docs;
                List<ChatModal> chatList = [];
                for (QueryDocumentSnapshot snap in data) {
                  chatList.add(ChatModal.fromMap(snap.data() as Map));
                }
                return Column(
                  children: [
                    ...List.generate(chatList.length,(index)=>Container(
                      alignment: chatList[index].sender ==
                          AuthService.authService.getUser()!.email
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 8),
                        child: ListTile(
                          title: Text(chatList[index].message!),
                          subtitle: Text(chatList[index].time!.toString()),
                        ),
                      ),
                    ),)
                  ],
                );
              },
            )),
            TextField(
              controller: chatController.txtChat,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                      onPressed: () async {
                        ChatModal chat = ChatModal(
                            message: chatController.txtChat.text,
                            recevier: chatController.receiverEmail.value,
                            sender: AuthService.authService.getUser()!.email,
                            time: Timestamp.now());
                        await UserFirestore.userFirestore
                            .addChatIntoFirestore(chat);
                      },
                      icon: Icon(Icons.send))),
            )
          ],
        ),
      ),
    );
  }
}
