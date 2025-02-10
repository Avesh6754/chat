import 'dart:typed_data';

import 'package:chat_application/modal/chat_Modal.dart';
import 'package:chat_application/modal/userModal.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/service/user_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../service/apiHelper.dart';

class ChatController extends GetxController {
  UserModal? recevier;
  RxString receiverName = "".obs;
  RxString receiverEmail = "".obs;
  TextEditingController txtChat = TextEditingController();
  TextEditingController txtUpdateChat = TextEditingController();
  RxString formatedate = ''.obs;
  RxBool isOnline = true.obs;
  RxBool isTyping = false.obs;

  RxString imageUrl = ''.obs;
  RxString lastmessage = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
    UserFirestore.userFirestore.editStatus(
        email: AuthService.authService.getUser()!.email!,
        online: true,
        typing: false);
  }

  String dateFormate(Timestamp dateTime) {
    formatedate.value = DateFormat('MM:ss').format(dateTime.toDate());
    return formatedate.value;
  }

  Future<void> sendImageToServer(ChatModal chat) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? xFile = await imagePicker.pickImage(source: ImageSource.gallery);
    Uint8List image = await xFile!.readAsBytes();
    chat.message = await ApiHelper.apiHelper.uploadImage(image) ?? "";

    await UserFirestore.userFirestore.addChatIntoFirestore(chat);
  }

  void getReceiver(String email, String name, String image, bool online,
      bool typing) {
    receiverName.value = name;
    receiverEmail.value = email;
    imageUrl.value = image;
    isOnline.value = online;
    isTyping.value = typing;
  }

  Future<void> fetchUser()
  async {
    final data= await UserFirestore.userFirestore.fetchReceiverData(receiverEmail.value);
    recevier=UserModal.fromMap(data!);
  }
  @override
  void onClose() {
    // TODO: implement onClose

    super.onClose();
    UserFirestore.userFirestore.editStatus(email:AuthService.authService.getUser()!.email! , online: false, typing: false);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    UserFirestore.userFirestore.editStatus(email:AuthService.authService.getUser()!.email! , online: false, typing: false);
  }
}