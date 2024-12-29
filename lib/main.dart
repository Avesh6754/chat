import 'package:chat_application/firebase_options.dart';
import 'package:chat_application/service/auth_service.dart';
import 'package:chat_application/views/component/auth_Manager.dart';
import 'package:chat_application/views/home/home_Page.dart';
import 'package:chat_application/views/signIn/sign_In.dart';
import 'package:chat_application/views/signUp/signUp.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<void> main()
async {
WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());


}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/', page: () => AuthManager(),),
        GetPage(name: '/signIn', page: () => SignIn(),),
        GetPage(name: '/signUp', page: () => SignUp(),),
        GetPage(name: '/home', page: () => HomePage(),),
      ],
    );

  }
}
