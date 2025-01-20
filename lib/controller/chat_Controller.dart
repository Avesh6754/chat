import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController{
  RxString receiverName="".obs;
  RxString receiverEmail="".obs;
  TextEditingController txtChat=TextEditingController();
  TextEditingController txtUpdateChat=TextEditingController();
  void getReceiver(String email,String name)
  {
    receiverName.value=name;
    receiverEmail.value=email;
  }
}