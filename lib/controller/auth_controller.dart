
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{

  var txtEmail=TextEditingController();
  var txtPassword=TextEditingController();
  var txtName=TextEditingController();
  var txtPhone=TextEditingController();
  RxString sender="".obs;
  RxString recevier="".obs;

  RxBool isHidden=true.obs;

  void hideThePassword(bool value)
  {
    isHidden.value=!value;
  }

}