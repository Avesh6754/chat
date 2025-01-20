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
        title: Text(chatController.receiverEmail.value),
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
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                List data = snapshot.data!.docs;
                List<ChatModal> chatList = [];
                for (QueryDocumentSnapshot snap in data) {
                  chatList.add(ChatModal.fromMap(snap.data() as Map));
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ...List.generate(chatList.length,(index)=>Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        alignment: chatList[index].sender ==
                            AuthService.authService.getUser()!.email
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          // color: Colors.green.shade100,
                          decoration: BoxDecoration(
                              color:chatList[index].sender ==
                                  AuthService.authService.getUser()!.email
                                  ? Colors.green.shade100
                                  :  Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Padding(

                            padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                            child: Text(chatList[index].message!),
                          ),
                            // subtitle: Text(chatList[index].time!.toString()),
                          ),
                        ),
                    ),
                    ),
                  ],
                );
              },
            )),
            TextField(
              controller: chatController.txtChat,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25)
                  ),
                  suffixIcon: IconButton(
                      onPressed: () async {
                        ChatModal chat = ChatModal(
                            message: chatController.txtChat.text,
                            recevier: chatController.receiverEmail.value,
                            sender: AuthService.authService.getUser()!.email,
                            time: Timestamp.now());
                        chatController.txtChat.clear();
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
