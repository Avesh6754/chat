import 'package:flutter/material.dart';

import '../../service/auth_service.dart';
import '../home/home_Page.dart';
import '../signIn/sign_In.dart';

class AuthManager extends StatelessWidget {
  const AuthManager({super.key});

  @override
  Widget build(BuildContext context) {
    return (AuthService.authService.getUser()==null)?SignIn():HomePage();
  }
}
