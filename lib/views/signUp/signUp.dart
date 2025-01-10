import 'package:chat_application/controller/auth_controller.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../component/sign_Up_button.dart';

var controller = Get.put(AuthController());

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Sign Up',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      height: 4),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller.txtName,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller.txtPhone,
                  decoration: InputDecoration(
                    labelText: 'Phone',
                    hintText: 'Enter your Phone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller.txtEmail,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'Enter your email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => TextField(
                    controller: controller.txtPassword,
                    obscureText: controller.isHidden.value,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            controller
                                .hideThePassword(controller.isHidden.value);
                          },
                          icon: (controller.isHidden.value == false)
                              ? Icon(Icons.visibility)
                              : Icon(Icons.visibility_off)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                Sign_Up_Button(),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text('or'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Image.asset(
                    'assets/image/google.png',
                    height: 25,
                    width: 25,
                  ),
                  label: const Text('Sign Up with Google',
                      style: TextStyle(
                        letterSpacing: 0.5,
                      )),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      '''Already have account ? Sign In''',
                      style: TextStyle(
                        letterSpacing: 0.5,
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
