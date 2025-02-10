import 'package:chat_application/controller/auth_controller.dart';
import 'package:chat_application/modal/userModal.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/service/google_auth.dart';
import 'package:chat_application/service/user_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';

var controller = Get.put(AuthController());



class SignIn extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: "logo",
                child: const Icon(Icons.chat, size: 80, color: Colors.purple)
                    .animate()
                    .scale(delay: 200.ms, duration: 600.ms),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: authController.txtEmail,

                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: Colors.purple),
                  hintText: "Email",
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() => TextField(
                controller: authController.txtPassword,
                obscureText: authController.isHidden.value,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Colors.purple),
                  hintText: "Password",
                  hintStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.grey[900],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      authController.isHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      authController.hideThePassword(authController.isHidden.value);
                    },
                  ),
                ),
              )),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  String response = await AuthService.authService
                      .sigInWithEmailAndPassword(authController.txtEmail.text, authController.txtPassword.text);

                  User? user = AuthService.authService.getUser();
                  if (user != null && response == "Success") {
                    Get.offAndToNamed('/home');
                  } else {
                    Get.snackbar('Sign In Fail !', response);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 80),
                ),
                child: const Text("Login", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Get.toNamed('/signUp'),
                child: const Text("Don't have an account? Sign up",
                    style: TextStyle(color: Colors.white)),
              ).animate().fade(delay: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
}


