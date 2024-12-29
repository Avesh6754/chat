import 'package:chat_application/controller/auth_controller.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/service/google_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sign_in_button/sign_in_button.dart';

var controller = Get.put(AuthController());

class SignIn extends StatelessWidget {
  const SignIn({super.key});

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
                  'Sign In',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      height: 4),
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
                TextField(
                  controller: controller.txtPassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    suffixIcon: Icon(Icons.visibility_off),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    String respnse = await AuthService.authService
                        .sigInWithEmailAndPassword(controller.txtEmail.text,
                            controller.txtPassword.text);
                    User? user = AuthService.authService.getUser();
                    if (user != null && respnse == "Success") {
                      Get.offAndToNamed('/home');
                    } else {
                      Get.snackbar('Sign In Fail !', respnse);
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
                    'Sign In',
                    style: TextStyle(
                        fontSize: 16, color: Colors.white, letterSpacing: 1),
                  ),
                ),
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
                SignInButton(Buttons.google, onPressed: () async {
                  await GoogleAuth.googleAuth.signInWithGoogle();
                  User? user = AuthService.authService.getUser();
                  if (user != null ) {
                    Get.offAndToNamed('/home');
                  }
                }),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      Get.toNamed('/signUp');
                    },
                    child: Text(
                      '''Don't have account ? Sign Up''',
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
