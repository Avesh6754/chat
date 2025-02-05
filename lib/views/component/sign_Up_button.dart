import 'package:chat_application/modal/userModal.dart';
import 'package:chat_application/service/user_firestore.dart';
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
        String response = await AuthService.authService
            .createAccountWithEmailAndPassword(
                controller.txtEmail.text, controller.txtPassword.text);
        UserModal userModal = UserModal(
            email: controller.txtEmail.text,
            phone: controller.txtPhone.text,
            name: controller.txtName.text);
        if (response == 'Successfully') {

          await UserFirestore.userFirestore.addUser(userModal);
          controller.txtPassword.clear();
          controller.txtEmail.clear();
          controller.txtPhone.clear();
          controller.txtName.clear();
          Navigator.of(context).pop();

        }
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
        style: TextStyle(fontSize: 16, color: Colors.white, letterSpacing: 1),
      ),
    );
  }
}
