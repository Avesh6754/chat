
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{

  var txtEmail=TextEditingController();
  var txtPassword=TextEditingController();

  RxBool isHidden=true.obs;

  void hideThePassword(bool value)
  {
    isHidden.value=!value;
  }
}