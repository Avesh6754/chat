import 'dart:developer';
import 'dart:typed_data';

import 'package:chat_application/modal/userModal.dart';
import 'package:chat_application/service/user_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../service/apiHelper.dart';

class AuthController extends GetxController {
  var txtEmail = TextEditingController();
  var txtPassword = TextEditingController();
  var txtName = TextEditingController();
  var txtPhone = TextEditingController();
  var profilePicture =
      'https://cdn-icons-png.flaticon.com/512/3135/3135715.png'.obs;
  var defaultImage = ''.obs;

  RxBool isHidden = true.obs;

  void hideThePassword(bool value) {
    isHidden.value = !value;
  }


}
