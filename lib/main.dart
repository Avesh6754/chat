import 'package:chat_application/firebase_options.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/service/local_notification.dart';
import 'package:chat_application/service/user_firestore.dart';
import 'package:chat_application/views/component/auth_Manager.dart';
import 'package:chat_application/views/home/chat_page.dart';
import 'package:chat_application/views/home/home_Page.dart';
import 'package:chat_application/views/signIn/sign_In.dart';
import 'package:chat_application/views/signUp/signUp.dart';
import 'package:chat_application/views/splashScreen/splashPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/home_controller.dart';
var homeController=Get.put(HomeController());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await homeController.getCurrentUser();
  // await UserFirestore.userFirestore.readAllUserFromFirestore();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(
          name: '/',
          page: () =>   Splashpage(),
        ),
        GetPage(
          name: '/auth',
          page: () => const AuthManager(),
        ),
        GetPage(
          name: '/signIn',
          page: () =>  SignIn(),
        ),

        GetPage(
          name: '/signUp',
          page: () => const SignUp(),
        ),
        GetPage(
          name: '/home',
          page: () => const HomePage(),
        ),
        GetPage(
          name: '/chat',
          page: () =>  ChatPage(),
        ),
      ],
    );
  }
}
