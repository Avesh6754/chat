import 'dart:typed_data';

import 'package:chat_application/modal/userModal.dart';
import 'package:chat_application/service/user_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';
import '../service/apiHelper.dart';
import '../views/home/profile_Section.dart';

class HomeController extends GetxController{
  UserModal? user;
  var txtName=TextEditingController();

  Future<UserModal?> getCurrentUser()
  async {
    user=await UserFirestore.userFirestore.getCurrentUserAndShow();
    if(user != null) homeController.txtName.text = user!.name ?? "";
    update();
    return user;
  }
  Future<void> sendImageToServer(bool choice) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? xFile = await imagePicker.pickImage(source: (choice)?ImageSource.camera:ImageSource.gallery);
    Uint8List image = await xFile!.readAsBytes();
    final url =
        await ApiHelper.apiHelper.uploadImage(image) ?? "";
    await UserFirestore.userFirestore
        .updateProfilePhoto(url: url, userEmail: user!.email);
await getCurrentUser();
    update();
  }
  Future<void> updateUserName(String newName) async {
    user?.name = newName;
await UserFirestore.userFirestore.updateUserName(newName);
    update(); // Notify UI to update
  }

}