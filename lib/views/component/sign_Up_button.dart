
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../service/auth_service.dart';
import '../signIn/sign_In.dart';


class Sign_Up_Button extends StatelessWidget {
  const Sign_Up_Button({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await AuthService.authService.createAccountWithEmailAndPassword(
            controller.txtEmail.text, controller.txtPassword.text);
        controller.txtPassword.clear();
        controller.txtEmail.clear();
        Get.back();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: const Text(
        'Sign Up',
        style: TextStyle(
            fontSize: 16, color: Colors.white, letterSpacing: 1),
      ),
    );
  }
}