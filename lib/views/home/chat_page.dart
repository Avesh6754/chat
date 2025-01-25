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
                List<String> docIdList = [];
                for (QueryDocumentSnapshot snap in data) {
                  docIdList.add(snap.id);
                  chatList.add(ChatModal.fromMap(snap.data() as Map));
                }
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      ...List.generate(
                        chatList.length,
                        (index) => GestureDetector(
                          onLongPress: () {

                            if (chatList[index].sender ==
                                AuthService.authService.getUser()!.email) {
                              chatController.txtUpdateChat =
                                  TextEditingController(
                                      text: chatList[index].message);
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Update'),
                                    content: TextField(
                                      controller: chatController.txtUpdateChat,
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            String updateId = docIdList[index];
                                            UserFirestore.userFirestore
                                                .updateMessage(
                                                    recevier:
                                                        chatController
                                                            .receiverEmail.value,
                                                    message: chatController
                                                        .txtUpdateChat.text,
                                                    updateId: updateId);
                                            Get.back();
                                          },
                                          child: const Text('Update')),
                                      TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: const Text('Cancel'))
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          onDoubleTap: () {
                            if (chatList[index].sender ==
                                AuthService.authService.getUser()!.email) {
                              UserFirestore.userFirestore.deleteMessage(
                                  recevier: chatController.receiverEmail.value,
                                  removeId: docIdList[index]);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              alignment: chatList[index].sender ==
                                      AuthService.authService.getUser()!.email
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                // color: Colors.green.shade100,
                                decoration: BoxDecoration(
                                    color: chatList[index].sender ==
                                            AuthService.authService
                                                .getUser()!
                                                .email
                                        ? Colors.green.shade100
                                        : Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 20),
                                  child: Column(
                                    children: [
                                      Text(chatList[index].message!,style: TextStyle(fontSize: 15),),
                                      Text(chatController.dateFormate(chatList[index].time!),style: TextStyle(fontSize: 10,color: Colors.grey.shade700),),
                                    ],
                                  ),
                                ),
                                // subtitle: Text(chatList[index].time!.toString()),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )),
            TextField(
              controller: chatController.txtChat,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25)),
                  suffixIcon: IconButton(
                      onPressed: () async {
                        ChatModal chat = ChatModal(
                            message: chatController.txtChat.text,
                            recevier: chatController.receiverEmail.value,
                            sender: AuthService.authService.getUser()!.email,
                            time: Timestamp.now(),

                        );
                        chatController.txtChat.clear();
                        await UserFirestore.userFirestore
                            .addChatIntoFirestore(chat);
                      },
                      icon: const Icon(Icons.send))),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
