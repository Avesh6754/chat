import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatController extends GetxController{
  RxString receiverName="".obs;
  RxString receiverEmail="".obs;
  TextEditingController txtChat=TextEditingController();
  TextEditingController txtUpdateChat=TextEditingController();
  RxString formatedate=''.obs;

  String dateFormate(Timestamp dateTime)
  {
    formatedate.value = DateFormat('MM:ss').format(dateTime.toDate());
return formatedate.value;
  }
  void getReceiver(String email,String name)
  {
    receiverName.value=name;
    receiverEmail.value=email;
  }
}