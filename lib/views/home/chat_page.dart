import 'dart:typed_data';

import 'package:chat_application/modal/chat_Modal.dart';
import 'package:chat_application/service/apiHelper.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/service/user_firestore.dart';
import 'package:chat_application/views/home/home_Page.dart';
import 'package:chat_application/views/signIn/sign_In.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    // TODO: implement initState
    UserFirestore.userFirestore.editStatus(
        email: AuthService.authService.getUser()!.email!,
        online: true,
        typing: false);
    print('dmfnjfndfnjdfndnj');
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    UserFirestore.userFirestore.editStatus(
        email: AuthService.authService.getUser()!.email!,
        online: false,
        typing: false);
    print('dmfnjfndfnjdfndnj');
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: Colors.grey[900],
        title: ListTile(
          leading: Obx(
            () => Container(
              decoration: BoxDecoration(
                  color: (chatController.isOnline.value) ? Colors.green : null,
                  shape: BoxShape.circle),
              child: CircleAvatar(
                backgroundImage: (chatController.imageUrl.value.isEmpty)
                    ? const NetworkImage(
                        'https://cdn-icons-png.flaticon.com/512/3135/3135715.png')
                    : NetworkImage(chatController.imageUrl.value),
              ),
            ),
          ),
          title: Text(
            chatController.receiverName.value,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: (!chatController.isOnline.value)
              ? Text(
                  DateTime.now().toString(),
                  style: TextStyle(color: Colors.white70),
                )
              : Text(
                  'Online',
                  style: TextStyle(color: Colors.green),
                ),
        ),
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
                    child: Text(snapshot.error.toString(),
                        style: TextStyle(color: Colors.white)),
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
                              chatController.lastmessage.value =
                                  chatList[index].message!;
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
                                                    recevier: chatController
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
                            child: Align(
                              alignment: chatList[index].sender ==
                                      AuthService.authService.getUser()!.email
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: chatList[index].sender ==
                                            AuthService.authService
                                                .getUser()!
                                                .email
                                        ? Colors.purple
                                        : Colors.pink.shade700,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      (chatList[index].isImage!)
                                          ? Image.network(
                                              chatList[index].message!,
                                              height: 150,
                                              width: 150,
                                              fit: BoxFit.cover,
                                            )
                                          : Text(
                                              chatList[index].message!,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white),
                                            ),
                                      Text(
                                        chatController
                                            .dateFormate(chatList[index].time!),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey.shade500,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                ),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: chatController.txtChat,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(25)),
                          hintText: 'Type a message',
                          hintStyle: TextStyle(color: Colors.white70)),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.white),
                    onPressed: () async {
                      ChatModal chat = ChatModal(
                        message: '',
                        isImage: true,
                        recevier: chatController.receiverEmail.value,
                        sender: AuthService.authService.getUser()!.email,
                        time: Timestamp.now(),
                      );
                      await chatController.sendImageToServer(chat);
                    },
                  ),
                  IconButton(
                      onPressed: () async {
                        ChatModal chat = ChatModal(
                            message: chatController.txtChat.text,
                            recevier: chatController.receiverEmail.value,
                            sender: AuthService.authService.getUser()!.email,
                            time: Timestamp.now(),
                            isImage: false);
                        chatController.txtChat.clear();
                        await UserFirestore.userFirestore
                            .addChatIntoFirestore(chat);
                      },
                      icon: const Icon(Icons.send, color: Colors.white)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
